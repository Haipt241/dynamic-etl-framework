"""ETL services; importing value conversions does not initialize database clients."""
from importlib import import_module

_EXPORTS = {'DataExtractor': 'data_extraction', 'DataTransformer': 'data_transformation'}
__all__ = list(_EXPORTS)


def __getattr__(name):
    if name not in _EXPORTS:
        raise AttributeError(name)
    value = getattr(import_module(f'{__name__}.{_EXPORTS[name]}'), name)
    globals()[name] = value
    return value
