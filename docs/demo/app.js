'use strict';
const $ = id => document.getElementById(id);
let designDirty = false;
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
function ensureApplied(){if(designDirty)throw Error('Khai báo API đã thay đổi. Phân tích lại trước khi lưu schema hoặc job.');if(draft&&(JSON.stringify(JSON.parse($('schema-json').value))!==JSON.stringify(draft.schema)||JSON.stringify(JSON.parse($('config-json').value))!==JSON.stringify(draft.config)))throw Error('Cấu hình nâng cao chưa được áp dụng. Bấm Áp dụng cấu hình nâng cao trước.');}
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
  const root=$('field-editor');root.replaceChildren();const map=$('schema-map');map.replaceChildren();
  $('schema-count').textContent=`${draft.schema.endpoints.length} bảng / endpoint`;
  for(const [index,endpoint] of draft.schema.endpoints.entries()){
    const keys=()=>endpoint.fields.filter(f=>f.is_primary_key).map(f=>f.db_column);
    const card=document.createElement('article');card.className='schema-card';card.id='table-review-'+index;
    const heading=text('h3',endpoint.name);card.append(heading);
    const parent=draft.schema.endpoints.find(ep=>(ep.nested_extractions||[]).some(ex=>ex.table_name===endpoint.name));
    card.append(text('p',parent?`${parent.name} → ${endpoint.name}`:'API → '+endpoint.name,'muted'));
    if(endpoint.identity_field&&(endpoint.nested_extractions||[]).length)card.append(text('p','Nested identity: '+endpoint.identity_field+' → child FK','muted'));
    const summary=text('p','','pk-summary');card.append(summary);
    const jump=text('button',endpoint.name,'secondary');const mapKeys=text('small','');jump.append(mapKeys);jump.onclick=()=>card.scrollIntoView({behavior:'smooth'});map.append(jump);
    const updateSummary=()=>{const selected=keys();const hasKey=endpoint.fields.some(f=>f.is_primary_key&&!['ClientID','OrganisationID'].includes(f.db_column));summary.textContent=hasKey?'PK ('+selected.join(', ')+')':'Chưa chọn khoá chính';summary.classList.toggle('missing-key',!hasKey);mapKeys.textContent=summary.textContent;};updateSummary();
    if(!endpoint.identity_field&&endpoint.fields.some(f=>f.is_json_value))card.append(text('p','Mảng chưa có định danh cha được giữ dạng JSON text để tránh tạo quan hệ sai.','muted'));
    const table=document.createElement('table');const tr=document.createElement('tr');for(const title of ['API field','DB column','SQL type','Primary key','Nullable'])tr.append(text('th',title));const head=document.createElement('thead');head.append(tr);table.append(head);const body=document.createElement('tbody');
    for(const field of endpoint.fields||[]){
      const row=document.createElement('tr');row.classList.toggle('pk-row',!!field.is_primary_key);const name=text('td',field.api_name);if(field.is_foreign_key)name.append(text('small',' · FK'));if(field.sample_has_nulls)name.append(text('small',' · NULL trong mẫu'));row.append(name);
      const inputs={};
      for(const property of ['db_column','data_type','is_primary_key','nullable']){
        const cell=document.createElement('td');const input=document.createElement('input');inputs[property]=input;const boolean=property==='is_primary_key'||property==='nullable';input.type=boolean?'checkbox':'text';if(boolean)input.checked=!!field[property];else input.value=field[property];
        input.disabled=(property==='nullable'&&field.is_primary_key)||(property==='is_primary_key'&&(field.is_json_value||field.sample_has_nulls));
        input.setAttribute('aria-label',`${endpoint.name}.${field.api_name} ${property}`);
        input.addEventListener('change',()=>{
          field[property]=boolean?input.checked:input.value;
          if(field.is_primary_key){field.nullable=false;inputs.nullable.checked=false;if(property==='is_primary_key'&&['TEXT','LONGTEXT','MEDIUMTEXT'].includes(field.data_type.toUpperCase())){field.data_type='VARCHAR(255)';inputs.data_type.value=field.data_type;notice('Cột PK dạng text đã chuyển sang VARCHAR(255). Kiểm tra độ dài dữ liệu trước khi lưu.');}}
          inputs.nullable.disabled=!!field.is_primary_key;row.classList.toggle('pk-row',!!field.is_primary_key);
          endpoint.database_schema=endpoint.database_schema||{};endpoint.database_schema.primary_key=keys();updateSummary();changed();syncJson();
        });cell.append(input);row.append(cell);
      }body.append(row);
    }table.append(body);const wrap=document.createElement('div');wrap.className='table-wrap';wrap.append(table);card.append(wrap);root.append(card);
  }
}
function loadDraft(data){designDirty=false;draft={name:data.name,schema:data.schema,config:data.config};templates=data.templates||{};definitionId=data.id||null;sql=data.sql||{};$('name').value=data.name;$('base_url').value=data.schema.api_config.base_url;if(!data._keepSamples)renderEndpointRows(data.schema.endpoints.filter(e=>!e.is_virtual_endpoint).map(e=>({name:e.name,path:e.api_details?.path||'/',data_path:e.response_structure?.root_data_field||''})));const auth=data.config.auth_type;if(auth&&!Array.from($('auth').options).some(o=>o.value===auth))$('auth').add(new Option(auth+' · cấu hình provider',auth));$('auth').value=auth||'api_key';$('reviewed').checked=false;designDirty=false;syncJson();renderFields();showParameters();$('sql-preview').textContent=sql[$('sql-kind').value]||'Sinh SQL để xem trước.';$('active-definition').textContent=definitionId?`${data.name} · phiên bản ${definitionId.slice(0,8)}`:'Bản nháp chưa lưu.';}
async function refreshDefinitions(){const rows=await api('definitions');$('saved').replaceChildren(new Option('Chọn phiên bản',''));for(const row of rows)$('saved').add(new Option(`${row.name} · ${new Date(row.created*1000).toLocaleString()} · ${row.id.slice(0,8)}`,row.id));if(definitionId)$('saved').value=definitionId;}
action('load-saved',async()=>{if(!$('saved').value)throw Error('Chọn phiên bản trước.');loadDraft(await api('definitions/'+$('saved').value));notice('Đã mở phiên bản.');});
let sourceFilename='input.json';
$('source-file').addEventListener('change',async event=>{try{const files=[...event.target.files];if(!files.length)return;let size=0;const parts=[];for(const file of files){size+=file.size;if(size>800000)throw Error('Tổng tài liệu tối đa 800 KB.');parts.push(files.length===1?await file.text():'SOURCE FILE: '+file.name+'\n'+await file.text());}sourceFilename=files[0].name;$('source-document').value=parts.join('\n\n');}catch(e){notice(e.message,true);}});
action('discover-endpoints',async()=>{
  const result=await api('discover',{content:$('source-document').value,filename:sourceFilename});
  if(result.base_url)$('base_url').value=result.base_url;
  renderEndpointRows(result.endpoints);
  $('discovery-report').hidden=false;
  $('discovery-report').textContent=result.endpoints.map(r=>r.name+' ← '+r.source).concat(result.warnings).join('\n');
  notice('Đã đề xuất endpoint. Duyệt URL, tên bảng và mẫu JSON trước khi phân tích schema.');
});
let analysisName='', analysisSchemaSnapshot='', analysisPolling=null;
function showAnalysisEndpoints(){
  const schema=JSON.parse($('analysis-schema').value);
  if(!Array.isArray(schema.endpoints))throw Error('Schema cần danh sách endpoints.');
  analysisSchemaSnapshot=$('analysis-schema').value;
  $('analysis-endpoints').replaceChildren();
  const roots=schema.endpoints.filter(e=>!e.is_virtual_endpoint);
  $('analysis-coverage').textContent=roots.length+' API / '+schema.endpoints.length+' tables';
  for(const endpoint of roots){const label=text('label','','check');const checkbox=document.createElement('input');checkbox.type='checkbox';checkbox.checked=true;checkbox.dataset.endpoint=endpoint.name;checkbox.onchange=()=>{$('analysis-reviewed').checked=false;};label.append(checkbox,text('span',endpoint.name+' · '+(endpoint.api_details?.method||'GET')+' '+(endpoint.api_details?.path||'?')+' · '+(endpoint.fields||[]).length+' fields'));$('analysis-endpoints').append(label);}
  $('analysis-reviewed').checked=false;
}
function showAnalysis(result){
  analysisName=result.name;
  $('analysis-review').hidden=false;
  $('analysis-summary').textContent=result.summary||'';
  $('analysis-config').value=JSON.stringify(result.config,null,2);
  $('analysis-schema').value=JSON.stringify(result.schema,null,2);
  $('analysis-validation').textContent=(result.validation_errors||[]).join('\n');
  $('analysis-overview').replaceChildren();
  for(const [label,value] of [['Base URL',result.schema.api_config?.base_url],['Auth',result.config.auth_type],['Pagination',result.schema.api_config?.pagination?.type]])$('analysis-overview').append(text('p',label+': '+(value||'?')));
  $('analysis-findings').replaceChildren();
  for(const f of result.findings||[]){const item=text('details');item.append(text('summary',f.topic+': '+f.value),text('p',(f.source||'')+' · '+(f.verified_quote?'Trích dẫn khớp tài liệu':'Cần xác minh nguồn')),text('blockquote',f.quote||''));$('analysis-findings').append(item);}
  $('analysis-missing').replaceChildren();for(const item of result.missing_information||[])$('analysis-missing').append(text('li',item));
  showAnalysisEndpoints();$('analysis-review').scrollIntoView({behavior:'smooth'});
}
async function pollAnalysis(id){
  try{const task=await api('analyses/'+id);if(task.status==='running'){analysisPolling=setTimeout(()=>pollAnalysis(id),1500);return;}
    localStorage.removeItem('etl-analysis-id');$('analyze-agent').disabled=false;
    if(task.status==='failed')throw Error(task.error);
    $('analysis-progress').textContent='Đã phân tích. Cần duyệt hai đầu ra.';showAnalysis(task.result);
  }catch(e){$('analyze-agent').disabled=false;$('analysis-progress').textContent=e.message;localStorage.removeItem('etl-analysis-id');}
}
$('analyze-agent').addEventListener('click',async()=>{
  $('analyze-agent').disabled=true;try{
    const declared={description:$('analysis-description').value};
    if($('analysis-use-form').checked)for(const key of ['base_url','auth','header','rate_limit','pagination','page_param','size_param','page_size'])declared[key]=$(key).value;
    const result=await api('analyses',{name:$('name').value,content:$('source-document').value,urls:$('analysis-urls').value.split(/\r?\n/).map(v=>v.trim()).filter(Boolean),declared});
    localStorage.setItem('etl-analysis-id',result.id);$('analysis-progress').textContent='Agent đang đọc tài liệu và đề xuất config/schema...';pollAnalysis(result.id);
  }catch(e){notice(e.message,true);$('analysis-progress').textContent=e.message;$('analyze-agent').disabled=false;}
});
for(const id of ['analysis-config','analysis-schema'])$(id).addEventListener('input',()=>{$('analysis-reviewed').checked=false;});
action('analysis-refresh',()=>showAnalysisEndpoints());
action('apply-analysis',async()=>{
  if(!$('analysis-reviewed').checked)throw Error('Duyệt config và schema trước khi áp dụng.');
  if($('analysis-schema').value!==analysisSchemaSnapshot)throw Error('Cập nhật danh sách từ JSON trước khi áp dụng.');
  const schema=JSON.parse($('analysis-schema').value),config=JSON.parse($('analysis-config').value);
  const selected=new Set([...$('analysis-endpoints').querySelectorAll('input:checked')].map(i=>i.dataset.endpoint));
  let count;do{count=selected.size;for(const ep of schema.endpoints)if(selected.has(ep.name))for(const child of ep.nested_extractions||[])selected.add(child.table_name);}while(count!==selected.size);
  schema.endpoints=schema.endpoints.filter(e=>selected.has(e.name));
  config.endpoints=schema.endpoints.filter(e=>!e.is_virtual_endpoint).map(e=>e.name);
  const definition=await api('analysis-review',{name:analysisName,schema,config,reviewed:true});
  loadDraft(definition);$('analysis-validation').textContent='';notice('Đã áp dụng hai đầu ra vào bản nháp. Tiếp tục duyệt PK và SQL.');$('schema').scrollIntoView({behavior:'smooth'});
});
api('analysis-status').then(status=>{$('agent-status').textContent=status.provider+(status.model?' · '+status.model:'')+' · '+(status.ready?'Ready':status.message);}).catch(e=>{$('agent-status').textContent=e.message;});
try{const id=localStorage.getItem('etl-analysis-id');if(id){$('analyze-agent').disabled=true;pollAnalysis(id);}}catch(_){}
function renderEndpointRows(rows){
  designDirty=true;
  $('endpoint-rows').replaceChildren();
  for(const row of rows)addEndpointRow(row);
}
function addEndpointRow(row={}){
  designDirty=true;
  const card=text('article','','endpoint-row');const grid=text('div','','grid three');
  for(const [key,label,value] of [['name','Endpoint',row.name||row.endpoint||''],['path','URL / path',row.url||row.path||''],['data_path','JSON data path',row.data_path||'']]){
    const field=text('label',label),input=document.createElement('input');input.dataset.key=key;input.value=value;input.required=key!=='data_path';field.append(input);grid.append(field);
  }
  const sample=document.createElement('textarea');sample.dataset.key='sample';sample.rows=3;sample.placeholder='Sample JSON';sample.value=row.sample===undefined?'':JSON.stringify(row.sample,null,2);
  const remove=text('button','Xoá dòng','secondary');remove.type='button';remove.onclick=()=>{card.remove();designDirty=true;};card.append(grid,sample,remove);$('endpoint-rows').append(card);
}
function importEndpointList(value){
  let rows;
  if(value.trim().startsWith('[')||value.trim().startsWith('{')){const parsed=JSON.parse(value);rows=Array.isArray(parsed)?parsed:parsed.endpoints;}
  else rows=value.trim().split(/\r?\n/).filter(line=>line.trim()).map(line=>{const [name,path,data_path='']=line.split(/\t|\|/).map(v=>v.trim());return {name,path,data_path};});
  if(!Array.isArray(rows)||!rows.length||rows.some(r=>!r||typeof r!=='object'||!r.name&&!r.endpoint||!r.path&&!r.url))throw Error('Danh sách cần tên endpoint và URL/path cho mỗi dòng.');
  renderEndpointRows(rows);
}
action('import-endpoints',()=>importEndpointList($('endpoint-import').value));
action('add-endpoint',()=>addEndpointRow());
$('endpoint-list-file').addEventListener('change',async event=>{try{const file=event.target.files[0];if(file){if(file.size>4000000)throw Error('Mẫu JSON tối đa 4 MB.');importEndpointList(await file.text());}}catch(e){notice(e.message,true);}});
$('endpoint-samples').addEventListener('change',async event=>{try{
  const rows=[...document.querySelectorAll('.endpoint-row')];const pending=[];
  for(const file of event.target.files){if(file.size>4000000)throw Error('Mẫu JSON tối đa 4 MB.');const name=file.name.replace(/\.json$/i,'');const matches=rows.filter(r=>r.querySelector('[data-key=name]').value.toLowerCase()===name.toLowerCase());if(matches.length!==1)throw Error('Không tìm được endpoint duy nhất cho file: '+file.name);pending.push([matches[0],JSON.parse(await file.text())]);}
  for(const [row,sample] of pending)row.querySelector('[data-key=sample]').value=JSON.stringify(sample,null,2);
  designDirty=true;notice('Đã nạp các mẫu JSON.');
}catch(e){notice(e.message,true);}});
$('design-form').addEventListener('submit',async event=>{event.preventDefault();const button=event.submitter;button.disabled=true;try{
  const data={};for(const id of ['name','base_url','auth','header','rate_limit','pagination','page_param','size_param','page_size'])data[id]=$(id).value;
  data.endpoints=[...document.querySelectorAll('.endpoint-row')].map((row,index)=>{const item={};for(const key of ['name','path','data_path'])item[key]=row.querySelector('[data-key='+key+']').value;try{item.sample=JSON.parse(row.querySelector('[data-key=sample]').value);}catch(_){throw Error('Sample JSON: '+(item.name||index+1));}return item;});
  const inferred=await api('infer',data);loadDraft({...inferred,_keepSamples:true});notice('Đã suy luận schema. Kiểm tra khoá chính, kiểu dữ liệu và bảng con.');$('schema').scrollIntoView({behavior:'smooth'});
}catch(e){notice(e.message,true);}finally{button.disabled=false;}});
renderEndpointRows([{name:'Records',path:'/records'}]);
designDirty=false;
$('design-form').addEventListener('input',()=>{designDirty=true;});

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
  logId=result.id;showTab('monitor');notice('SIMULATION: one example cycle started; no real worker or database connection.');await refreshJobs();
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
