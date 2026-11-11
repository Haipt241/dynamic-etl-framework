/* Static demonstration adapter only. Never forwards requests to a backend. */
'use strict';
(() => {
  const clone = value => JSON.parse(JSON.stringify(value));
  const fixture = window.DEMO_DEFINITION;
  const definitions = [clone(fixture)];
  const saved = [
    {id:'demo-job-orders',name:'Demo · Orders sync',definition_id:fixture.id,integration_name:fixture.name,mode:'upsert',interval:60,bindings:{}},
    {id:'demo-job-review',name:'Demo · One-off validation',definition_id:fixture.id,integration_name:fixture.name,mode:'upsert',interval:0,bindings:{}}
  ];
  const runs = [];
  const now = () => Date.now()/1000;
  function sameSchema(body) {
    if(JSON.stringify(body.schema)!==JSON.stringify(fixture.schema)||JSON.stringify(body.config)!==JSON.stringify(fixture.config)||body.name!==fixture.name||Object.keys(body.templates||{}).length)
      throw Error('Static demo: SQL is pre-generated for the sample schema. Use the local Python app to generate SQL for your edits or templates.');
  }
  window.fetch = async (url, options={}) => {
    try {
      if(typeof url!=='string'||!url.startsWith('/api/'))throw Error('External requests are disabled in this demo.');
      const path=url.slice(5), body=options.body?JSON.parse(options.body):undefined;
      let result;
      if(path==='analysis-status') result={provider:'Static demo',ready:false,message:'Live AI disabled. Use the local app with your configured provider.'};
      else if(path==='job-parameters')result={literal_parameters:['EtaniClientID','EtaniOrganisationID']};
      else if(path==='definitions'&&!body) result=definitions;
      else if(path.startsWith('definitions/'))result=definitions.find(d=>d.id===path.split('/')[1]);
      else if(path==='preview'){sameSchema(body);result={sql:fixture.sql};}
      else if(path==='definitions'&&body){sameSchema(body);const id='demo-version-'+Date.now();definitions.push({...clone(body),id,sql:clone(fixture.sql),created:now()});result={id};}
      else if(path==='saved-jobs'&&!body)result=saved;
      else if(path==='saved-jobs'&&body){const def=definitions.find(d=>d.id===body.definition_id);if(!def)throw Error('Open or save a sample version first.');const id='demo-job-'+Date.now();saved.push({...clone(body),id,integration_name:def.name});result={id};}
      else if(/^saved-jobs\/[^/]+$/.test(path)){const job=saved.find(j=>j.id===path.split('/')[1]);result={job,definition:definitions.find(d=>d.id===job?.definition_id)};}
      else if(/^saved-jobs\/[^/]+\/run$/.test(path)){
        if(!body.confirm_write)throw Error('Confirm the simulated run using the checkbox. No database writes occur.');
        if(runs.filter(r=>r.status==='running').length>=4)throw Error('Demo worker limit reached.');
        const job=saved.find(j=>j.id===path.split('/')[1]);
        const run={id:'demo-run-'+Date.now(),name:job.integration_name,saved_job_id:job.id,mode:body.initialize?'insert':job.mode,status:'running',created:now(),updated:now(),details:{cycles:0}};
        runs.unshift(run);setTimeout(()=>{if(run.status==='running'){run.status='completed';run.details.cycles=1;run.updated=now();}},6000);result={id:run.id};
      } else if(path==='jobs') result=runs;
      else if(/^jobs\/[^/]+\/stop$/.test(path)){const run=runs.find(r=>r.id===path.split('/')[1]);run.status='cancelled';run.updated=now();result={ok:true};}
      else if(/^jobs\/[^/]+\/log$/.test(path))result={text:'[SIMULATION ONLY]\nLoaded reviewed configuration.\nSimulated independent worker lifecycle.\nNo vendor requests, AI calls, credentials or database writes.\nThis is not evidence of a real sync.'};
      else throw Error('This operation requires the local Python backend. In this static demo, open the sample version to review schema/SQL and use Saved jobs to simulate execution.');
      if(result===undefined)throw Error('Demo item not found.');
      return new Response(JSON.stringify(clone(result)),{status:200,headers:{'Content-Type':'application/json'}});
    } catch(error){return new Response(JSON.stringify({error:error.message}),{status:400,headers:{'Content-Type':'application/json'}});}
  };
  document.addEventListener('DOMContentLoaded',()=>{
    const checkbox=document.getElementById('confirm-write');
    checkbox.parentElement.lastChild.textContent=' Allow a simulated run. No database or external API will be contacted.';
    document.getElementById('run').textContent='Simulate run';
    document.getElementById('initialize-job').textContent='Simulate initialization';
    document.getElementById('language').value='en';
    document.getElementById('language').dispatchEvent(new Event('change'));
    document.querySelectorAll('#run-parameters input').forEach(input=>input.disabled=true);
  });
})();
