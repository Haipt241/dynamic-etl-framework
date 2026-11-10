/* UI-only localization. Never rewrite schema, SQL, input values or worker logs. */
(() => {
  const messages = {
    'Từ API đến dữ liệu.': 'From API to data.',
    'Khai báo một lần. Tái sử dụng luồng tích hợp. Theo dõi từng lần đồng bộ.': 'Configure once. Reuse your integration workflow. Track every sync.',
    'Thiết kế integration': 'Design an integration',
    'Chạy & giám sát': 'Run & monitor',
    'Khai báo API mới hoặc tiếp tục phiên bản đã lưu': 'Configure a new API or continue a saved version',
    'Phiên bản đã lưu': 'Saved versions', 'Chưa chọn': 'Not selected',
    'Chọn phiên bản': 'Select a version', 'Mở phiên bản': 'Open version',
    'Tên integration': 'Integration name', 'Đường dẫn API · GET': 'API path · GET',
    'Đường dẫn dữ liệu trong JSON': 'JSON data path', 'Khoá chính': 'Primary key',
    'Tên header': 'Header name', 'Rate limit · requests/phút': 'Rate limit · requests/minute',
    'Tham số page / offset': 'Page / offset parameter', 'Tham số kích thước trang': 'Page size parameter',
    'Số bản ghi/trang': 'Records per page', 'Mẫu JSON trả về từ API': 'Sample API response JSON',
    'Phân tích mẫu →': 'Analyze sample →', 'Thêm endpoint vào bản nháp': 'Add endpoint to draft',
    'Mẫu được phân tích tại máy. Không gọi AI. Duyệt kiểu dữ liệu trước khi chạy.': 'Samples are analyzed locally, without AI calls. Review data types before running.',
    'Chưa có schema': 'No schema yet',
    'Object được làm phẳng; mảng có ID thành bảng con qua nested_extractions. Mảng chưa có khoá giữ dạng JSON text.': 'Objects are flattened; arrays with IDs become child tables through nested_extractions. Unkeyed arrays remain JSON text.',
    'Phân tích mẫu hoặc mở phiên bản đã lưu để duyệt cấu trúc.': 'Analyze a sample or open a saved version to review its structure.',
    'Cấu hình nâng cao · schema, auth, incremental, reconciliation': 'Advanced configuration · schema, auth, incremental, reconciliation',
    'Runtime config · chỉ lưu tên biến môi trường': 'Runtime config · store environment variable names only',
    'Áp dụng cấu hình nâng cao': 'Apply advanced configuration',
    'OAuth và auth đặc thù cần cấu hình nâng cao tương thích với runtime. Không nhập secret vào JSON.': 'OAuth and custom authentication require compatible advanced runtime configuration. Do not put secrets in JSON.',
    'Loại SQL': 'SQL type', 'Import template SQL': 'Import SQL template',
    'Dùng template mặc định': 'Use default template', 'Sinh & xem SQL': 'Generate & preview SQL',
    'Template SQL hỗ trợ Jinja:': 'SQL templates support Jinja:',
    '. Sinh SQL để kiểm tra trước khi chạy INSERT.': '. Generate SQL for review before running INSERT.',
    'SQL preview sẽ xuất hiện ở đây.': 'The SQL preview will appear here.',
    'Tôi đã duyệt schema, khoá chính và SQL': 'I have reviewed the schema, primary keys and SQL',
    'Lưu phiên bản': 'Save version', 'Tối đa 4 job độc lập': 'Up to 4 independent jobs',
    'Chọn một phiên bản đã lưu để chạy.': 'Select a saved version to run.',
    'Chế độ': 'Mode', 'UPSERT · đồng bộ dữ liệu': 'UPSERT · sync data',
    'INSERT · tạo SQL và đồng bộ': 'INSERT · execute setup SQL and sync',
    'Lặp lại sau mỗi lần hoàn tất · giây': 'Repeat after each completed run · seconds',
    '0 = chạy một lần, lặp tối thiểu 10 giây': '0 = run once; minimum repeat interval is 10 seconds',
    'Bắt đầu job': 'Start job',
    'Cho phép job ghi vào database đang cấu hình; INSERT dùng SQL gốc có DROP TABLE và có thể xoá dữ liệu bảng đích; hãy đọc SQL preview trước.': 'Allow this job to write to the configured database. INSERT SQL includes DROP TABLE and may delete destination data; review the SQL preview first.',
    'Dùng DB/AWS đã cấu hình trong môi trường chạy. Secret nhập ở đây chỉ dùng trong bộ nhớ worker. Đóng tab không dừng job; tắt server sẽ dừng job. Reconciliation dùng logic của provider, chưa có màn hình đối soát riêng.': 'Uses the DB/AWS settings in the runtime environment. Secrets entered here are used in worker memory. Closing the tab does not stop jobs; shutting down the server does. Reconciliation uses the existing runtime logic; a dedicated reconciliation screen is not yet available.',
    'Trạng thái': 'Status', 'Vòng chạy': 'Cycles', 'Cập nhật': 'Updated', 'Thao tác': 'Actions',
    'Nhật ký job': 'Job log', 'Chọn “Log” để xem tiến trình.': 'Select “Log” to inspect progress.',
    'Bản nháp chưa lưu.': 'Unsaved draft.',
    'Cấu hình đã thay đổi. Sinh SQL để duyệt lại.': 'Configuration changed. Regenerate SQL for review.',
    'Cấu hình nâng cao chưa được áp dụng. Bấm Áp dụng cấu hình nâng cao trước.': 'Advanced configuration has not been applied. Select Apply advanced configuration first.',
    'Nhập giá trị hoặc dùng biến môi trường server': 'Enter a value or use the server environment variable',
    'Sinh SQL để xem trước.': 'Generate SQL to preview it.',
    'Chọn phiên bản trước.': 'Select a version first.', 'Đã mở phiên bản.': 'Version opened.',
    'Endpoint phải thuộc cùng tên integration và base URL.': 'The endpoint must use the same integration name and base URL.',
    'Tên endpoint hoặc bảng con đã tồn tại.': 'An endpoint or child table with that name already exists.',
    'Đã suy luận schema. Kiểm tra khoá chính, kiểu dữ liệu và bảng con.': 'Schema inferred. Review primary keys, data types and child tables.',
    'Mẫu JSON tối đa 4 MB.': 'JSON samples must be 4 MB or smaller.',
    'Tạo integration hoặc mở phiên bản đã lưu trước.': 'Create an integration or open a saved version first.',
    'Đã áp dụng cấu hình nâng cao; cần sinh lại SQL.': 'Advanced configuration applied; regenerate SQL.',
    'Template SQL không được để trống.': 'The SQL template cannot be empty.',
    'Đã khôi phục template mặc định.': 'Default template restored.', 'Chưa có schema.': 'No schema available.',
    'SQL đã sinh bằng generator hiện có. Chưa thực thi vào DB.': 'SQL generated. Nothing has been executed against the database.',
    'Sinh và kiểm tra SQL trước khi lưu.': 'Generate and review SQL before saving.',
    'Xác nhận đã duyệt schema và SQL.': 'Confirm you have reviewed the schema and SQL.',
    'Đã lưu phiên bản. Có thể nhập tham số và bắt đầu job.': 'Version saved. Enter runtime parameters to start a job.',
    'Lưu hoặc mở một phiên bản trước khi chạy.': 'Save or open a version before running.',
    'Job đã khởi động trong tiến trình riêng.': 'Job started in its own process.',
    'Chưa có job.': 'No jobs yet.', 'Dừng': 'Stop',
    'data.items (để trống nếu là mảng)': 'data.items (leave empty for a root array)',
    'Trường API': 'API field', 'Cột DB': 'DB column', 'Kiểu SQL': 'SQL type', 'Cho phép null': 'Nullable',
    'Đang chờ': 'queued', 'Đang chạy': 'running', 'Đợi vòng tiếp': 'waiting', 'Đang thử lại': 'retrying',
    'Hoàn tất': 'completed', 'Lỗi một phần': 'partial', 'Thất bại': 'failed', 'Bị gián đoạn': 'interrupted', 'Đã dừng': 'cancelled',
    'Quy trình sử dụng ứng dụng': 'Application workflow',
    'Khai báo API.': 'Configure the API.',
    'Nhập tên integration, URL, endpoint, auth, phân trang, rate limit và mẫu JSON.': 'Enter an integration name, URL, endpoint, authentication, pagination, rate limit and sample JSON.',
    'Phân tích mẫu.': 'Analyze the sample.',
    'Tool đề xuất cột SQL, làm phẳng object và tạo bảng con cho mảng có ID.': 'The tool suggests SQL columns, flattens objects and creates child tables for arrays with IDs.',
    'Duyệt schema.': 'Review the schema.',
    'Kiểm tra kiểu dữ liệu, khoá chính, nullable và quan hệ bảng con. Thêm endpoint nếu cần.': 'Check data types, primary keys, nullability and child-table relationships. Add endpoints as needed.',
    'Duyệt SQL.': 'Review SQL.',
    'Xem stage, prod, view, procedure; import template SQL nếu cần. Chưa có thao tác ghi DB ở bước này.': 'Inspect stage, prod, view and procedure SQL; import a SQL template if needed. This step does not write to the database.',
    'Lưu phiên bản.': 'Save a version.',
    'Xác nhận schema và SQL để lưu cấu hình. Các lần thay đổi tạo phiên bản mới.': 'Confirm the schema and SQL to save the configuration. Further changes create new versions.',
    'Chạy job.': 'Run a job.',
    'Nhập tham số và secret; chọn INSERT để khởi tạo hoặc UPSERT để đồng bộ; đặt chu kỳ lặp nếu cần.': 'Enter parameters and secrets; choose INSERT for setup or UPSERT for synchronization, and optionally set a repeat interval.',
    'Theo dõi và xử lý lỗi.': 'Monitor and handle errors.',
    'Xem trạng thái, số vòng và log. Dừng job nếu cần. Sau lỗi hoặc dừng giữa chừng, kiểm tra dữ liệu trước khi chạy lại.': 'Watch status, cycles and logs. Stop a job when needed. After a failure or interruption, check the data before running it again.',
    'INSERT có thể xoá và tạo lại bảng theo SQL đã duyệt. Đóng tab vẫn giữ job chạy; tắt server sẽ dừng job. Reconcile dùng logic runtime hiện có; chưa có màn hình đối soát riêng.': 'INSERT may drop and recreate tables according to the reviewed SQL. Jobs continue when the tab closes, but stop when the server shuts down. Reconciliation uses existing runtime logic; a dedicated reconciliation screen is not yet available.',
    'Tên integration này đã được sử dụng. Chọn tên khác.': 'This integration name is already in use. Choose a different name.',
    'Cần xác nhận cho phép ghi DB trước khi chạy.': 'Confirm that this job will write to the configured database',
    'Job không còn chạy.': 'Job is not running',
    'Đã có job chạy cho integration/client/organisation này.': 'A job is already running for this provider/client/organisation',
    'Tối đa 4 job đồng thời; hãy dừng một job trước.': 'Maximum 4 simultaneous jobs; stop a job first',
    'Thao tác thất bại. Xem log server.': 'Operation failed. Check the server log.',
    'Tải lại trang trước khi gửi yêu cầu.': 'Reload the tool page before making requests',
    'Không tìm thấy phiên bản.': 'Definition not found'
  };
  Object.assign(messages, {
  "01 · Chuẩn bị integration": "01 · Prepare integration",
  "02 · Job đã lưu": "02 · Saved jobs",
  "03 · Chạy & giám sát": "03 · Run & monitor",
  "Tạo job từ phiên bản đã duyệt": "Create a job from a reviewed version",
  "Tên job": "Job name",
  "Lưu job": "Save job",
  "Job đã lưu": "Saved jobs",
  "Tạo job mới": "Create a new job",
  "Job lưu phiên bản integration, tham số và chu kỳ. Thông tin xác thực được tham chiếu qua biến môi trường; có thể nhập tạm khi chạy.": "A job saves its integration version, parameters and interval. Credentials use environment references or temporary inputs at launch.",
  "Lưu job không ghi DB. Chọn Khởi tạo DB trong chi tiết job để chạy SQL đã duyệt.": "Saving a job does not write to the database. Choose Initialize DB in the job details to execute the reviewed SQL.",
  "Chọn job để xem integration, schema, SQL và cấu hình chạy.": "Select a job to inspect its integration, schema, SQL and execution settings.",
  "Cấu hình integration và job": "Integration and job configuration",
  "Schema đã duyệt": "Reviewed schema",
  "SQL đã duyệt": "Reviewed SQL",
  "Tham số cho lần chạy này": "Parameters for this run",
  "Để trống để dùng cấu hình job. Giá trị nhập ở đây chỉ dùng cho lần chạy, không lưu vào job.": "Leave blank to use the saved job configuration. Overrides apply only to this run and are not saved.",
  "Chạy job đã chọn": "Run selected job",
  "Khởi tạo DB & đồng bộ lần đầu": "Initialize DB & first sync",
  "Dùng làm job mới": "Use as a new job",
  "Mỗi lần chạy có worker, cấu hình và log riêng. Khởi tạo DB chạy INSERT một lần; chạy định kỳ dùng chế độ đã lưu.": "Each run has its own worker, configuration and log. DB initialization runs INSERT once; recurring execution uses the saved mode.",
  "Chọn job để chạy": "Select a job to run",
  "Job / Lần chạy": "Job / Run",
  "Nhật ký lần chạy": "Run log",
  "Biến môi trường": "Environment variable",
  "Giá trị cố định": "Fixed value",
  "Đã lưu job. Có thể chọn job và chạy nhiều worker độc lập.": "Job saved. Select jobs to start independent workers.",
  "Chưa có job đã lưu. Tạo integration, duyệt SQL và lưu job.": "No saved jobs yet. Prepare an integration, review SQL and save a job.",
  "Chọn job trước.": "Select a job first.",
  "Lưu job.": "Save a job.",
  "Đặt tên job, chọn phiên bản integration, tham số và chu kỳ chạy. Job được lưu để sử dụng lại.": "Name the job and choose its integration version, parameters and interval. The job is saved for reuse.",
  "Mở tab Job đã lưu, chọn job để xem chi tiết. Khởi tạo DB nếu cần, sau đó chạy và theo dõi từng worker ở tab giám sát.": "Open Saved jobs and select a job to inspect its details. Initialize the database if needed, then run and monitor each worker in the monitoring tab.",
  "Nhật ký job": "Run log"
});
  Object.assign(messages, {"Chọn PK trực tiếp trên các cột bên dưới. Chọn nhiều cột để tạo khoá chính ghép. PK không được NULL; mẫu dữ liệu không chứng minh tính duy nhất của toàn bộ API.": "Select PK columns below. Choose multiple columns for a composite primary key. Keys cannot be NULL; samples cannot prove uniqueness across the entire API.", "Chưa chọn khoá chính": "Primary key not selected", "Mảng chưa có định danh cha được giữ dạng JSON text để tránh tạo quan hệ sai.": "Arrays without a parent identity are kept as JSON text to avoid incorrect relationships.", "Cột PK dạng text đã chuyển sang VARCHAR(255). Kiểm tra độ dài dữ liệu trước khi lưu.": "The text key column was changed to VARCHAR(255). Verify data lengths before saving.", "NULL trong mẫu": "NULL in sample"});
  Object.assign(messages, {"Danh sách endpoint": "Endpoint list", "Import tài liệu API / dữ liệu raw": "Import API documentation / raw data", "OpenAPI/Swagger JSON hoặc YAML, Postman collection, JSON mẫu hoặc tài liệu text có dòng GET URL. Tool đề xuất tên bảng snake_case; bạn duyệt endpoint và mẫu trước khi sinh schema.": "OpenAPI/Swagger JSON or YAML, Postman collections, sample JSON, or text with GET URL lines. The tool proposes snake_case table names; review endpoints and samples before generating schemas.", "Tài liệu nguồn": "Source document", "Phân tích tài liệu": "Analyze document", "Đã đề xuất endpoint. Duyệt URL, tên bảng và mẫu JSON trước khi phân tích schema.": "Endpoints proposed. Review URLs, table names and JSON samples before schema inference.", "Nhập nhiều dòng: tên endpoint, URL/path, đường dẫn dữ liệu JSON (tuỳ chọn), cách nhau bằng Tab hoặc dấu |. Có thể import JSON chứa danh sách và sample của từng endpoint.": "Enter rows: endpoint name, URL/path, optional JSON data path, separated by Tab or |. You can also import JSON with endpoints and their samples.", "Nạp danh sách": "Load list", "Import danh sách JSON": "Import endpoint list", "Nạp nhiều mẫu JSON": "Upload multiple JSON samples", "Thêm dòng": "Add row", "Xoá dòng": "Remove row", "File mẫu đặt theo tên endpoint, ví dụ Orders.json. URL không đủ để suy luận cột; mỗi endpoint cần mẫu JSON. GET, auth và phân trang dùng cấu hình chung bên trên.": "Name sample files after endpoints, e.g. Orders.json. A URL alone cannot determine columns; each endpoint needs a JSON sample. GET, authentication and pagination use the shared settings above.", "Phân tích tất cả endpoint →": "Analyze all endpoints →", "Duyệt tất cả bảng và PK ở bước Schema & SQL.": "Review all tables and primary keys in Schema & SQL.", "Danh sách cần tên endpoint và URL/path cho mỗi dòng.": "Each row needs an endpoint name and URL/path.", "Đã nạp các mẫu JSON.": "JSON samples loaded."});
  messages['Khai báo API đã thay đổi. Phân tích lại trước khi lưu schema hoặc job.']='API inputs changed. Analyze again before saving a schema or job.';
  const reverse = new Map(Object.entries(messages).map(([vi,en]) => [en,vi]));
  const patterns = [
    [/^(\d+) bảng \/ endpoint$/, n => `${n} tables / endpoints`],
    [/^(.*?) · bảng con$/, name => `${name} · child table`],
    [/^(.*?) · endpoint API$/, name => `${name} · API endpoint`],
    [/^(.*?) · phiên bản (\w+)$/, (name,id) => `${name} · version ${id}`],
    [/^(.*?) · cấu hình provider$/, name => `${name} · runtime configuration`],
    [/^Đã import template (.+)\. Sinh SQL để kiểm tra\.$/, kind => `Imported ${kind} template. Generate SQL to review it.`],
    [/^Không kết nối được server: (.*)$/, detail => `Cannot connect to the server: ${detail}`]
  ];
  const nodes = new WeakMap(), placeholders = new WeakMap();
  let language = 'vi';
  try { language = localStorage.getItem('etl-language') === 'en' ? 'en' : 'vi'; } catch (_) {}
  function translate(source) {
    const trimmed=source.trim();
    const canonical=reverse.get(trimmed)||trimmed;
    let result=language==='en' ? (messages[canonical]||canonical) : canonical;
    if(language==='en') {
      for(const [pattern, render] of patterns){const match=canonical.match(pattern);if(match){result=render(...match.slice(1));break;}}
      const nav=canonical.match(/^(0[123])\s+(.*)$/);
      if(nav&&!messages[canonical])result=nav[1]+'   '+(messages[nav[2]]||nav[2]);
    }
    return source.replace(trimmed,result);
  }
  function apply() {
    observer.disconnect();
    document.documentElement.lang=language;
    document.getElementById('language').value=language;
    const walker=document.createTreeWalker(document.body,NodeFilter.SHOW_TEXT);
    while(walker.nextNode()) {
      const node=walker.currentNode;
      if(!node.nodeValue.trim()||node.parentElement.closest('script,style,textarea,code,#log-id,#field-editor td,#jobs td:first-child:not([colspan]),#parameters label > input,#run-parameters label,#job-detail-config,#job-detail-schema,#job-detail-sql,#job-detail-title,#job-detail-version,#job-detail-summary,#saved-jobs-list button'))continue;
      let record=nodes.get(node);
      if(!record||node.nodeValue!==record.last)record={source:node.nodeValue,last:node.nodeValue};
      // SQL itself is never localized; only the exact placeholder messages are recognized.
      if(node.parentElement.closest('#sql-preview,#logs')&&!messages[record.source.trim()]&&!reverse.has(record.source.trim()))continue;
      const value=translate(record.source);
      if(value!==node.nodeValue)node.nodeValue=value;
      record.last=value;nodes.set(node,record);
    }
    for(const input of document.querySelectorAll('[placeholder]')){
      if(input.matches('textarea'))continue;
      if(!placeholders.has(input))placeholders.set(input,input.getAttribute('placeholder'));
      input.setAttribute('placeholder',translate(placeholders.get(input)));
    }
    observer.observe(document.body,{childList:true,subtree:true,characterData:true});
  }
  const observer=new MutationObserver(apply);
  document.getElementById('language').addEventListener('change',event=>{
    language=event.target.value;
    try{localStorage.setItem('etl-language',language);}catch(_){}
    apply();
  });
  apply();
})();
