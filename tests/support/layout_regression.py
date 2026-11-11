import contextlib
import importlib
import io
import json
import os
from pathlib import Path
import runpy
import sys
from unittest.mock import patch
import boto3

sys.path.insert(0, str(Path.cwd()))
os.environ.update(USE_AWS_DB="True", AWS_EC2_METADATA_DISABLED="true", AWS_RDS_HOST="localhost")
class FakeSession:
    def client(self, *, service_name, region_name):
        assert service_name == "secretsmanager"
        return self

    def get_secret_value(self, *, SecretId):
        return {"SecretString": '{"username":"test","password":"test"}'}

with patch.object(boto3.session, "Session", FakeSession):
    from dynamic_integrations import IntegrationRegistry
    from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
    from dynamic_integrations.compatibility.integrations.qbo_integration import QBOIntegration
    from dynamic_integrations.IntegrationPackage import IntegrationPackage as HistoricalPackage
    from dynamic_integrations.compatibility.package import IntegrationPackage
    assert HistoricalPackage is IntegrationPackage
    from dynamic_integrations.base_integration import BaseIntegration
    assert issubclass(QBOIntegration, BaseIntegration)
    assert issubclass(XeroblueIntegration, BaseIntegration)
    from dynamic_integrations.runtime.integration_dynamic import DynamicIntegration

    assert "XEROBLUE" in IntegrationRegistry.list_integrations()
    packages = Path("dynamic_integrations/generated_integrations")
    count = 0
    for folder in sorted(packages.iterdir()):
        slug = folder.name
        adapter = folder / f"{slug}_integration.py"
        if not adapter.is_file():
            continue
        module = importlib.import_module(".".join(adapter.with_suffix("").parts))
        assert any(isinstance(value, type) and value is not DynamicIntegration and
                   issubclass(value, DynamicIntegration) and value.__module__ == module.__name__
                   for value in vars(module).values()), adapter
        for resource in (folder / "schemas" / f"{slug}_schema.json",
                         Path("dynamic_integrations/generator/config") / f"{slug}_config.json"):
            json.loads(resource.read_text())
        assert list((folder / "sql").glob("*.sql")), folder
        count += 1

    for entry in ("run_dynamic_integration.py", "dynamic_integrations/generator.py"):
        with patch.object(sys, "argv", [entry, "--help"]), contextlib.redirect_stdout(io.StringIO()) as output:
            try:
                runpy.run_path(entry, run_name="__main__")
            except SystemExit as error:
                assert error.code == 0, (entry, error)
        assert "usage:" in output.getvalue().lower(), entry
        print("CLI help OK:", entry)
    print("Generated providers imported and assets validated:", count)

    from types import SimpleNamespace
    from dynamic_integrations.runtime.configured_integration import ConfiguredIntegration, create_integration
    from dynamic_integrations.generator.utils import Utils
    from dynamic_integrations.generator.handlers import GeneratorHandlers
    from run_dynamic_integration import IntegrationWorkflowOrchestrator
    from tempfile import TemporaryDirectory

    client_fields = {
        "etani_client_id": {"env_var": "EtaniClientID", "default_value": "TEST_CLIENT100"},
        "etani_organisation_id": {"env_var": "EtaniOrganisationID", "default_value": "21"},
    }
    with patch.dict(os.environ, {"EtaniClientID": "TEST_CLIENT100", "EtaniOrganisationID": "21"}), patch(
        "dynamic_integrations.runtime.integration_dynamic.get_firm_id", return_value=1
    ), patch.object(DynamicIntegration, "_calculate_max_date_string", return_value="2020-01-01"):
        for provider in ("simpro", "myob_detailed"):
            old = create_integration(provider)
            settings = {"endpoints": old.config["endpoints"]}
            if hasattr(old, "integration_original_name"):
                settings["integration_original_name"] = old.integration_original_name
            new = ConfiguredIntegration(provider, settings)
            assert type(old) is not ConfiguredIntegration
            assert new.get_endpoints_list() == old.get_endpoints_list(), provider
            assert new.table_prefix_eva == old.table_prefix_eva, provider
            assert new.table_client_eva == old.table_client_eva, provider
            assert new.get_procedure_name("Employees") == old.get_procedure_name("Employees"), provider
            assert new.config["auth_type"] == old.config["auth_type"], provider
            print("Adapter parity:", provider)

        with TemporaryDirectory() as temp:
            temp = Path(temp)
            config_file = temp / "provider_config.json"
            definition = {
                "auth_type": "api_key",
                "required_env_vars": ["EtaniClientID", "EtaniOrganisationID"],
                "env_vars_config": client_fields,
                "env_var_validations": {"EtaniClientID": "lambda x: 'CLIENT' in x"},
            }
            config_file.write_text(json.dumps(definition))
            original = config_file.read_bytes()
            runner = object.__new__(IntegrationWorkflowOrchestrator)
            runner.integration_name = "audit_provider"
            runner.parameters = {"EtaniClientID": "TEST_CLIENT201", "EtaniOrganisationID": "12"}
            runner.integration_dir = temp
            runner.config_file = config_file
            schema = {
                "api_config": {"base_url": "https://api.example.test"},
                "endpoints": [{"name": "Orders"}, {"name": "OrderLines", "is_virtual_endpoint": True}],
            }
            with patch.object(Utils, "load_integration_config", side_effect=lambda name: json.loads(original)), patch.object(
                ConfiguredIntegration, "_load_schema", return_value=schema
            ), patch("dynamic_integrations.database.sql_helper.refresh_aws_engines_if_needed"), patch.object(
                ConfiguredIntegration, "run_full_sync", autospec=True, return_value={"status": "completed"}
            ) as sync:
                assert runner._update_configuration()["success"]
                assert config_file.read_bytes() == original
                result = runner._run_integration_direct(upsert_mode=True)
                assert result["success"], result
                integration = sync.call_args.args[0]
                assert type(integration) is ConfiguredIntegration
                assert integration.get_endpoints_list() == ["Orders"]
                assert integration.table_prefix_eva == "c201_12_audit_provider_"
                assert integration.upsert_mode
                print("New provider works through CLI without adapter or config file writes")

            previous_cwd = Path.cwd()
            try:
                os.chdir(temp)
                GeneratorHandlers().handle_dynamic_integration_file([{"integration_name": "audit_provider"}])
                generated = Path("generated_integrations/audit_provider/audit_provider_integration.py")
                assert generated.is_file()
                compile(generated.read_text(), str(generated), "exec")
            finally:
                os.chdir(previous_cwd)

        with patch(
            "dynamic_integrations.runtime.configured_integration.import_module",
            side_effect=ModuleNotFoundError("missing dependency", name="some_dependency"),
        ):
            try:
                create_integration("simpro")
            except ModuleNotFoundError as error:
                assert error.name == "some_dependency"
            else:
                raise AssertionError("A broken existing adapter was hidden by fallback")
