# Quy trình sử dụng / Application workflow

Mở `http://127.0.0.1:8765`, chọn **Tiếng Việt / English** ở đầu trang. Ngôn ngữ được ghi nhớ trên trình duyệt; chuyển ngôn ngữ không làm mất dữ liệu đang nhập.

Open `http://127.0.0.1:8765` and select **Tiếng Việt / English** in the header. The browser remembers your choice; switching languages preserves your current inputs.

Các integration cũ được giữ trong mã nguồn để đối chiếu và kiểm thử nội bộ. Chúng không phải danh sách template để người dùng lựa chọn. **Phiên bản đã lưu / Saved versions** chỉ chứa các cấu hình đã được lưu qua tool.

Legacy integrations are retained in the codebase for internal comparison and regression testing. They are not exposed as selectable templates. **Saved versions** contains configurations previously saved through the tool.

## Ba tab / Three tabs

| Tab | Tiếng Việt | English |
| --- | --- | --- |
| Chuẩn bị integration / Prepare integration | Thiết kế API, duyệt schema và SQL, lưu phiên bản rồi đặt tên và lưu job. Schema/config và SQL được xuất thành file theo phiên bản. | Design the API, review schema/SQL, save a version, then name and save a reusable job. Versioned schema/config and SQL files are materialized. |
| Job đã lưu / Saved jobs | Chọn job để xem đầy đủ integration, schema, SQL, tham số và chu kỳ. Có thể tạo job mới từ job hiện tại. | Select a job to inspect its integration, schema, SQL, bindings and interval. Clone its configuration into a new job. |
| Chạy & giám sát / Run & monitor | Mỗi lần chạy có ID, worker và log riêng. Chạy nhiều job, xem trạng thái và dừng riêng từng lần chạy. | Each execution has its own ID, worker and log. Run multiple jobs, monitor them and stop individual executions. |

**Job đã lưu khác lần chạy:** job tồn tại sau khi tắt server; một job có thể có nhiều lần chạy trong lịch sử. Không tự chạy lại khi server khởi động. / **Saved jobs differ from runs:** a job survives server shutdown and may have many historical runs. Restarting the server does not automatically start jobs.

| Bước / Step | Tiếng Việt | English | Kết quả / Result |
| --- | --- | --- | --- |
| 1. API | Nhập tên integration, base URL, endpoint GET, phương thức auth, header, phân trang, rate limit, đường dẫn dữ liệu và mẫu JSON. | Enter the integration name, base URL, GET endpoint, authentication, header, pagination, rate limit, data path and sample JSON. | Bản khai báo API / API definition |
| 2. Phân tích / Analyze | Bấm **Phân tích mẫu**. Object được làm phẳng; mảng object có ID thành bảng con; mảng chưa có khoá giữ JSON text. | Select **Analyze sample**. Objects are flattened; arrays of objects with IDs become child tables; unkeyed arrays remain JSON text. | Schema đề xuất / Proposed schema |
| 3. Duyệt / Review | Kiểm tra tên cột, kiểu SQL, khoá chính, nullable và bảng con. Dùng **Thêm endpoint vào bản nháp** cho API cùng integration. | Review column names, SQL types, primary keys, nullability and child tables. Use **Add endpoint to draft** for more endpoints in the same integration. | Schema đã kiểm tra / Reviewed schema |
| 4. SQL | Bấm **Sinh & xem SQL**, xem stage/prod/view/procedure. Có thể import template SQL rồi sinh lại. | Select **Generate & preview SQL** and inspect stage/prod/view/procedure output. Optionally import a SQL template and regenerate. | SQL để duyệt, chưa ghi DB / SQL for review, no DB writes |
| 5. Phiên bản / Version | Xác nhận đã duyệt schema và SQL, bấm **Lưu phiên bản**. Thay đổi về sau được lưu thành phiên bản mới. | Confirm review and select **Save version**. Later changes are saved as a new version. | Cấu hình cố định cho job / Immutable job definition |
| 6. Lưu job / Save job | Đặt tên, chọn chế độ và chu kỳ, khai báo giá trị client/organisation hoặc tên biến môi trường. Secret chỉ lưu dưới dạng tham chiếu. | Name the job, set mode/interval and bind client/organisation values or environment variable names. Credentials are stored only as references. | Job tái sử dụng / Reusable job |
| 7. Thực thi / Execute | Chọn job ở tab Job đã lưu. Xem chi tiết, xác nhận ghi DB rồi chạy. Nút Khởi tạo DB chạy INSERT một lần; nút Chạy job dùng chế độ đã lưu. | Select a saved job, inspect details, confirm DB writes and run. Initialize DB runs INSERT once; Run job uses the saved mode. | Worker riêng / Isolated worker |
| 8. Giám sát / Monitor | Xem trạng thái, số vòng, log; dừng job nếu cần. Sau lỗi hoặc dừng giữa chừng, kiểm tra/đối soát dữ liệu trước khi chạy lại. | Inspect status, cycles and logs; stop a job if needed. After failure or interruption, check/reconcile data before restarting. | Lịch sử thực thi / Execution history |

## Dữ liệu đầu vào / Inputs

| Thông tin / Information | Mục đích / Purpose |
| --- | --- |
| Tên integration / Integration name | Định danh cấu hình và tên bảng / Identify the configuration and tables |
| Base URL + endpoint | Xác định API được gọi / Identify the API to call |
| Auth + header | Chọn cách xác thực; secret nhập khi chạy / Select authentication; enter secrets at runtime |
| Data path | Chỉ ra mảng bản ghi, ví dụ `data.items`; để trống nếu JSON gốc là mảng / Locate the record array, e.g. `data.items`; leave empty for a root array |
| Primary key | Chọn một hoặc nhiều cột trực tiếp trên bảng ở bước duyệt schema; không cần nhập khi khai báo API / Select one or multiple columns in the visual schema review, rather than entering a key during API setup |
| Pagination + page size | Lấy các trang kế tiếp / Retrieve subsequent pages |
| Rate limit | Giới hạn số request mỗi phút theo API / Set the API request budget per minute |
| Sample JSON | Suy luận cấu trúc; không chứng minh dữ liệu đầy đủ / Infer structure; does not prove data completeness |
| Client/organisation + credentials | Xác định đích ghi và quyền API khi chạy / Select destination context and API credentials at runtime |

## Luồng thực thi / Execution flow

```mermaid
flowchart TD
    A["API + Auth + Sample"] --> B["Infer and review schema"]
    B --> C["Generate or import SQL"]
    C --> D{"Review approved?"}
    D -->|No| B
    D -->|Yes| E["Save version"]
    E --> S["Save named job and parameter bindings"]
    S --> T["Select job and inspect configuration"]
    T --> F["Start isolated worker with a new run ID"]
    T --> P["Initialize DB: one INSERT run"]
    P --> G
    F --> G["Existing ETL: API → transform → DB"]
    G --> H{"Cycle result"}
    H -->|Success, repeat enabled| I["Wait, then UPSERT"]
    I --> G
    H -->|Success, run once| J["Completed"]
    H -->|Error or partial| K["Bounded retry or failed/partial"]
    K --> L["Inspect logs and reconcile"]
```

## Hành vi cần biết / Operational behavior

- **INSERT** dùng SQL đã duyệt để khởi tạo rồi đồng bộ. Generator hiện tại có `DROP TABLE`; có thể xoá dữ liệu bảng đích. **UPSERT** dùng cấu trúc đã có. / **INSERT** executes reviewed setup SQL, then syncs. The existing generator includes `DROP TABLE`, which can delete destination data. **UPSERT** uses the existing structure.
- Chu kỳ `0` chạy một lần; chu kỳ lặp tối thiểu 10 giây, tính từ khi vòng trước kết thúc. Sau INSERT thành công, vòng tiếp theo dùng UPSERT. / Interval `0` runs once; repeated cycles wait at least 10 seconds after the previous cycle finishes. After a successful INSERT, later cycles use UPSERT.
- Tối đa 4 job độc lập; chặn chạy trùng integration/client/organisation. / Up to 4 independent jobs; duplicate provider/client/organisation jobs are blocked.
- Đóng tab không dừng job; tắt server sẽ dừng job. Khi server khởi động lại, job dở dang được đánh dấu interrupted, không tự phục hồi từ trang API cuối cùng. / Closing the tab does not stop jobs; shutting down the server does. After restart, unfinished jobs are marked interrupted, without automatic page-level recovery.
- Reconciliation dùng logic runtime hiện có; chưa có màn hình đối soát riêng hoặc bằng chứng tự động rằng mọi dữ liệu API đã được lấy đủ. / Reconciliation uses existing runtime logic; there is no dedicated reconciliation screen or independent automatic proof of source completeness yet.
- Form thông thường hỗ trợ GET và bốn kiểu auth cơ bản. OAuth hoặc auth đặc thù cần cấu hình nâng cao tương thích; phương thức auth chưa được runtime hỗ trợ cần bổ sung code. / The standard form supports GET and four basic auth modes. OAuth/custom auth requires compatible advanced configuration; unsupported authentication methods require runtime code.
- Ngôn ngữ UI đổi được, còn tên trường API, giá trị cấu hình, SQL và log kỹ thuật giữ nguyên để đối chiếu chính xác. / UI language can change; API field names, configuration values, SQL and technical logs remain unchanged for accurate diagnosis.

## Tham số và dữ liệu / Parameters and data

Các giá trị định tuyến như client/organisation được lưu trực tiếp hoặc tham chiếu biến môi trường. Auth/token/password dùng tên biến môi trường (ví dụ `VENDOR_API_KEY`), không lưu secret trong SQLite. Có thể nhập secret tạm trong chi tiết job cho từng lần chạy; nó chỉ nằm trong bộ nhớ worker. / Routing values such as client/organisation may be saved literally or as environment references. Auth/token/password values use environment names, not plaintext secrets in SQLite. Temporary per-run secret inputs remain in worker memory.

Lưu phiên bản/job chưa thực thi SQL. Chọn **Khởi tạo DB & đồng bộ lần đầu** khi sẵn sàng chạy SQL đã duyệt. Không chạy hai job cùng integration/client/organisation đồng thời để tránh ghi chồng dữ liệu. / Saving a version/job does not execute SQL. Choose **Initialize DB & first sync** to execute reviewed SQL. Concurrent runs for the same integration/client/organisation are rejected to avoid overlapping writes.

## Duyệt bảng và chọn PK / Visual table and key review

Sau khi phân tích mẫu, chọn bảng trong danh sách để mở phần duyệt cột. Tích một cột cho PK đơn hoặc nhiều cột cho PK ghép. Các cột khoá được tô màu và hiển thị trong `PK (...)`; NULL bị tắt. Cột có NULL trong mẫu hoặc chứa mảng JSON không thể được chọn làm PK. Khi chọn cột TEXT, tool chuyển sang VARCHAR(255) và yêu cầu kiểm tra độ dài.

After sample inference, select a table from the overview and choose one or multiple PK columns. Key rows are highlighted and summarized as `PK (...)`; nullable is disabled. Columns containing sample NULLs or JSON arrays cannot be selected. Selecting a TEXT key changes it to VARCHAR(255), with a data-length review notice.

Mẫu không có `id` vẫn được phân tích. Phải chọn PK trước khi sinh SQL/lưu phiên bản. `OrganisationID` vẫn được gợi ý để tách dữ liệu tổ chức; riêng cột này không đủ làm khoá bản ghi. Nested extraction tiếp tục dùng `identity_field` riêng để nối cha–con; thay PK SQL không tự đổi quan hệ đó. Nếu chưa có định danh cha, mảng được giữ dạng JSON text thay vì tạo FK sai. Chưa có trình chỉnh quan hệ FK ghép trực quan.

Samples without `id` can be analyzed. Select a PK before generating SQL or saving. `OrganisationID` remains a suggested scope column but is insufficient on its own. Nested extraction retains its separate `identity_field`; editing SQL keys does not redefine parent-child relationships. Arrays without a parent identity remain JSON text. A visual composite-FK editor is not yet available.
