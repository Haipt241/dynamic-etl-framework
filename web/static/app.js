'use strict';
const $ = id => document.getElementById(id);
let draft = null, definitionId = null, sql = {}, templates = {}, logId = null;
let selectedJob = null, selectedDefinition = null, savedJobs = [], literalParameters = new Set();
const token = document.querySelector('meta[name="tool-token"]').content;
function notice(message, error=false) { $('notice').textContent=message; $('notice').className=error?'error':''; }
async function api(path, body) {
  const response = await fetch('/api/'+path, {method:body===undefined?'GET':'POST',headers:{'Content-Type':'application/json','X-Tool-Token':token},body:body===undefined?undefined:JSON.stringify(body)});
  const data = await response.json(); if(!response.ok) throw Error(data.error || 'Request failed'); return data;
}
function action(id, callback) { $(id).addEventListener('click', async event => { event.preventDefault(); $(id).disabled=true; try {await callback();} catch(e) {notice(e.message,true);} finally {$(id).disabled=false;} }); }
function text(tag, value, cls) {const node=document.createElement(tag);node.textContent=value;if(cls)node.className=cls;return node;}
function changed(){definitionId=null;sql={};$('reviewed').checked=false;$('sql-preview').textContent='Cấu hình đã thay đổi. Sinh SQL để duyệt lại.';$('active-definition').textContent='Bản nháp chưa lưu.';}
function ensureApplied(){if(draft&&(JSON.stringify(JSON.parse($('schema-json').value))!==JSON.stringify(draft.schema)||JSON.stringify(JSON.parse($('config-json').value))!==JSON.stringify(draft.config)))throw Error('Cấu hình nâng cao chưa được áp dụng. Bấm Áp dụng cấu hình nâng cao trước.');}
function syncJson() {$('schema-json').value=JSON.stringify(draft.schema,null,2);$('config-json').value=JSON.stringify(draft.config,null,2);}
function variableNames(definition){return [...new Set([...(definition.config.required_env_vars||[]),...Object.values(definition.config.env_vars_config||{}).map(f=>f.env_var).filter(Boolean)])];}
function showParameters(bindings={}){
  $('parameters').replaceChildren();
  for(const variable of variableNames(draft)){
    const label=text('label',variable);const source=document.createElement('select');source.dataset.source=variable;
    source.add(new Option('Biến môi trường','env'));
    if(literalParameters.has(variable))source.add(new Option('Giá trị cố định','value'));
    const binding=bindings[variable]||{env:variable};source.value='value' in binding?'value':'env';
    const input=document.createElement('input');input.dataset.parameter=variable;input.autocomplete='off';input.value=binding.value??binding.env??variable;
    source.onchange=()=>{input.value=source.value==='env'?variable:'';};label.append(source,input);$('parameters').append(label);
  }
}
function showTab(name){
  for(const panel of document.querySelectorAll('.tab-panel'))panel.hidden=panel.id!=='tab-'+name;
  for(const button of document.querySelectorAll('[data-tab]')){const active=button.dataset.tab===name;button.classList.toggle('active',active);button.setAttribute('aria-pressed',String(active));}
}
for(const button of document.querySelectorAll('[data-tab]'))button.onclick=()=>showTab(button.dataset.tab);
function renderFields(){
  const root=$('field-editor');root.replaceChildren();
  $('schema-count').textContent=`${draft.schema.endpoints.length} bảng / endpoint`;
  for(const endpoint of draft.schema.endpoints){
    root.append(text('div',endpoint.name+(endpoint.is_virtual_endpoint?' · bảng con':' · endpoint API'),'table-label'));
    const table=document.createElement('table');const tr=document.createElement('tr');for(const title of ['API field','DB column','SQL type','Primary key','Nullable'])tr.append(text('th',title));const head=document.createElement('thead');head.append(tr);table.append(head);
    const body=document.createElement('tbody');
    for(const field of endpoint.fields||[]){const row=document.createElement('tr');row.append(text('td',field.api_name));for(const property of ['db_column','data_type','is_primary_key','nullable']){const cell=document.createElement('td');const input=document.createElement('input');const boolean=property==='is_primary_key'||property==='nullable';input.type=boolean?'checkbox':'text';if(boolean)input.checked=!!field[property];else input.value=field[property];input.setAttribute('aria-label',`${endpoint.name}.${field.api_name} ${property}`);input.addEventListener('change',()=>{field[property]=boolean?input.checked:input.value;if(property==='is_primary_key'||property==='db_column'){endpoint.database_schema=endpoint.database_schema||{};endpoint.database_schema.primary_key=endpoint.fields.filter(f=>f.is_primary_key).map(f=>f.db_column);}changed();syncJson();});cell.append(input);row.append(cell);}body.append(row);}table.append(body);root.append(table);
  }
}
function loadDraft(data){draft={name:data.name,schema:data.schema,config:data.config};templates=data.templates||{};definitionId=data.id||null;sql=data.sql||{};$('name').value=data.name;$('base_url').value=data.schema.api_config.base_url;const first=data.schema.endpoints.find(e=>!e.is_virtual_endpoint);if(first){$('endpoint').value=first.name;$('path').value=first.api_details?.path||'/';$('data_path').value=first.response_structure?.root_data_field||'';$('primary_key').value=first.identity_field||first.fields?.find(f=>f.is_primary_key)?.api_name||'id';}const auth=data.config.auth_type;if(auth&&!Array.from($('auth').options).some(o=>o.value===auth))$('auth').add(new Option(auth+' · cấu hình provider',auth));$('auth').value=auth||'api_key';$('reviewed').checked=false;syncJson();renderFields();showParameters();$('sql-preview').textContent=sql[$('sql-kind').value]||'Sinh SQL để xem trước.';$('active-definition').textContent=definitionId?`${data.name} · phiên bản ${definitionId.slice(0,8)}`:'Bản nháp chưa lưu.';}
async function refreshDefinitions(){const rows=await api('definitions');$('saved').replaceChildren(new Option('Chọn phiên bản',''));for(const row of rows)$('saved').add(new Option(`${row.name} · ${new Date(row.created*1000).toLocaleString()} · ${row.id.slice(0,8)}`,row.id));if(definitionId)$('saved').value=definitionId;}
action('load-saved',async()=>{if(!$('saved').value)throw Error('Chọn phiên bản trước.');loadDraft(await api('definitions/'+$('saved').value));notice('Đã mở phiên bản.');});
$('design-form').addEventListener('submit',async event=>{event.preventDefault();const button=event.submitter;button.disabled=true;try{const data={};for(const id of ['name','base_url','endpoint','path','data_path','primary_key','auth','header','rate_limit','pagination','page_param','size_param','page_size'])data[id]=$(id).value;data.sample=JSON.parse($('sample').value);const inferred=await api('infer',data);if($('append-endpoint').checked&&draft){if(draft.name!==inferred.name||draft.schema.api_config.base_url!==inferred.schema.api_config.base_url)throw Error('Endpoint phải thuộc cùng tên integration và base URL.');const names=new Set(draft.schema.endpoints.map(e=>e.name.toLowerCase()));if(inferred.schema.endpoints.some(e=>names.has(e.name.toLowerCase())))throw Error('Tên endpoint hoặc bảng con đã tồn tại.');inferred.schema={...draft.schema,endpoints:[...draft.schema.endpoints,...inferred.schema.endpoints]};inferred.config=draft.config;}loadDraft(inferred);notice('Đã suy luận schema. Kiểm tra khoá chính, kiểu dữ liệu và bảng con.');$('schema').scrollIntoView({behavior:'smooth'});}catch(e){notice(e.message,true);}finally{button.disabled=false;}});
$('sample-file').addEventListener('change',async event=>{const file=event.target.files[0];if(file){if(file.size>4000000){notice('Mẫu JSON tối đa 4 MB.',true);return;}$('sample').value=await file.text();}});
action('apply-json',async()=>{if(!draft)throw Error('Tạo integration hoặc mở phiên bản đã lưu trước.');draft.schema=JSON.parse($('schema-json').value);draft.config=JSON.parse($('config-json').value);changed();renderFields();showParameters();notice('Đã áp dụng cấu hình nâng cao; cần sinh lại SQL.');});
$('template-file').addEventListener('change',async event=>{const file=event.target.files[0];if(!file)return;const template=await file.text();if(!template.trim()){notice('Template SQL không được để trống.',true);return;}templates[$('sql-kind').value]=template;changed();notice(`Đã import template ${$('sql-kind').value}. Sinh SQL để kiểm tra.`);});
action('clear-template',async()=>{delete templates[$('sql-kind').value];changed();notice('Đã khôi phục template mặc định.');});
$('sql-kind').addEventListener('change',()=>{$('sql-preview').textContent=sql[$('sql-kind').value]||'Sinh SQL để xem trước.';});
action('preview',async()=>{if(!draft)throw Error('Chưa có schema.');ensureApplied();sql=(await api('preview',{...draft,templates})).sql;$('sql-preview').textContent=sql[$('sql-kind').value];notice('SQL đã sinh bằng generator hiện có. Chưa thực thi vào DB.');});
action('save',async()=>{ensureApplied();if(!draft||!Object.keys(sql).length)throw Error('Sinh và kiểm tra SQL trước khi lưu.');if(!$('reviewed').checked)throw Error('Xác nhận đã duyệt schema và SQL.');const result=await api('definitions',{...draft,templates,reviewed:true});definitionId=result.id;await refreshDefinitions();$('active-definition').textContent=`${draft.name} · phiên bản ${definitionId.slice(0,8)}`;notice('Đã lưu phiên bản. Có thể nhập tham số và bắt đầu job.');$('job-builder').scrollIntoView({behavior:'smooth'});});
action('save-job',async()=>{
  if(!definitionId)throw Error('Lưu hoặc mở một phiên bản trước khi chạy.');
  ensureApplied();const bindings={};
  for(const input of $('parameters').querySelectorAll('input')){const key=input.dataset.parameter;const source=Array.from($('parameters').querySelectorAll('select')).find(el=>el.dataset.source===key);if(input.value)bindings[key]={[source.value]:input.value};}
  const result=await api('saved-jobs',{name:$('job-name').value,definition_id:definitionId,bindings,mode:$('mode').value,interval:Number($('interval').value)});
  await refreshSavedJobs();await openJob(result.id);notice('Đã lưu job. Có thể chọn job và chạy nhiều worker độc lập.');
});
async function refreshSavedJobs(){
  savedJobs=await api('saved-jobs');$('saved-jobs-list').replaceChildren();
  if(!savedJobs.length)$('saved-jobs-list').append(text('p','Chưa có job đã lưu. Tạo integration, duyệt SQL và lưu job.','empty'));
  for(const job of savedJobs){const button=text('button',job.name,'job-card secondary');button.append(text('small',`${job.integration_name||job.definition_id.slice(0,8)} · ${job.mode.toUpperCase()} · ${job.interval}s`));button.onclick=()=>openJob(job.id).catch(e=>notice(e.message,true));$('saved-jobs-list').append(button);}
}
async function openJob(ident){
  const data=await api('saved-jobs/'+ident);selectedJob=data.job;selectedDefinition=data.definition;
  $('job-detail').hidden=false;$('job-detail-title').textContent=selectedJob.name;
  $('job-detail-version').textContent=`${selectedDefinition.name} · ${selectedDefinition.id.slice(0,8)}`;
  $('job-detail-summary').textContent=`${selectedJob.mode.toUpperCase()} · ${selectedJob.interval}s · ${selectedDefinition.schema.api_config.base_url}`;
  $('job-detail-config').textContent=JSON.stringify({job:selectedJob,integration:selectedDefinition.config},null,2);
  $('job-detail-schema').textContent=JSON.stringify(selectedDefinition.schema,null,2);
  $('job-detail-sql').textContent=Object.entries(selectedDefinition.sql).map(([kind,sql])=>`-- ${kind}\n${sql}`).join('\n\n');
  $('run-parameters').replaceChildren();
  for(const key of variableNames(selectedDefinition)){const binding=selectedJob.bindings[key];const label=text('label',key);const input=document.createElement('input');input.dataset.parameter=key;input.autocomplete='off';input.type=literalParameters.has(key)?'text':'password';input.placeholder=binding?.env?`ENV: ${binding.env}`:(binding?.value||'Server environment');label.append(input);$('run-parameters').append(label);}
  $('confirm-write').checked=false;showTab('saved-jobs');
}
async function startSelected(initialize=false){
  if(!selectedJob)throw Error('Chọn job trước.');const parameters={};
  for(const input of $('run-parameters').querySelectorAll('input'))if(input.value)parameters[input.dataset.parameter]=input.value;
  const result=await api(`saved-jobs/${selectedJob.id}/run`,{parameters,initialize,confirm_write:$('confirm-write').checked});
  for(const input of $('run-parameters').querySelectorAll('input'))input.value='';
  logId=result.id;showTab('monitor');notice('Job đã khởi động trong tiến trình riêng.');await refreshJobs();
}
action('run',()=>startSelected());action('initialize-job',()=>startSelected(true));
action('select-job',async()=>{await refreshSavedJobs();showTab('saved-jobs');});
action('new-job',async()=>{showTab('prepare');});
action('clone-job',async()=>{loadDraft(selectedDefinition);showParameters(selectedJob.bindings);$('job-name').value=selectedJob.name+' copy';$('mode').value=selectedJob.mode;$('interval').value=selectedJob.interval;showTab('prepare');});
async function refreshJobs(){
  const jobs=await api('jobs');$('running-count').textContent=String(jobs.filter(j=>['queued','running','waiting','retrying'].includes(j.status)).length)+' / 4 workers';$('jobs').replaceChildren();
  if(!jobs.length){const row=document.createElement('tr');const cell=text('td','Chưa có job.');cell.colSpan=5;row.append(cell);$('jobs').append(row);}
  for(const job of jobs){const row=document.createElement('tr');const nameCell=document.createElement('td');const saved=savedJobs.find(item=>item.id===job.saved_job_id);const name=text('button',`${saved?.name||job.name} / ${job.id.slice(0,8)} · ${(job.mode||"upsert").toUpperCase()}`,'secondary');if(job.saved_job_id)name.onclick=()=>openJob(job.saved_job_id).catch(e=>notice(e.message,true));else name.disabled=true;nameCell.append(name);row.append(nameCell);const status=document.createElement('td');status.append(text('span',job.status,'status '+job.status));row.append(status,text('td',String(job.details.cycles||0)),text('td',new Date(job.updated*1000).toLocaleTimeString()));const actions=document.createElement('td');const log=text('button','Log','secondary');log.onclick=async()=>{logId=job.id;await refreshLog();};actions.append(log);if(['queued','running','waiting','retrying'].includes(job.status)){const stop=text('button','Dừng','secondary');stop.onclick=async()=>{try{await api(`jobs/${job.id}/stop`,{});await refreshJobs();}catch(e){notice(e.message,true);}};actions.append(stop);}row.append(actions);$('jobs').append(row);}
  await refreshLog();
}
async function refreshLog(){if(logId){$('log-id').textContent=logId.slice(0,8);$('logs').textContent=(await api(`jobs/${logId}/log`)).text;}}
for(const id of ['schema-json','config-json'])$(id).addEventListener('input',changed);
async function init(){try{literalParameters=new Set((await api('job-parameters')).literal_parameters);await refreshDefinitions();await refreshSavedJobs();await refreshJobs();}catch(e){notice(e.message,true);}}
init();let polling=false;setInterval(async()=>{if(polling)return;polling=true;try{await refreshJobs();}catch(e){notice('Không kết nối được server: '+e.message,true);}finally{polling=false;}},3000);
