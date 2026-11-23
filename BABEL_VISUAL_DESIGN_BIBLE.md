# BABEL — VISUAL, UI & WORLD DESIGN BIBLE

**Loại tài liệu:** Implementation-oriented design specification  
**Dự án:** Babel  
**Engine context:** Godot 4.x / GDScript (project context: Godot 4.7)  
**Phạm vi:** Chuẩn mỹ thuật, giao diện và trình bày thế giới
**Đối tượng đọc:** Codex, lập trình viên, UI implementer và artist.

---

## 0. Vai trò tài liệu

Tài liệu này quy định hướng mỹ thuật, giao diện và cách trình bày thế giới của BABEL. Luật chơi và tiến trình phát triển được ghi trong [GAME_DESIGN.md](GAME_DESIGN.md) và [ROADMAP.md](ROADMAP.md). Khi triển khai nội dung chưa có đặc tả cụ thể, hãy giữ đúng các nguyên tắc bên dưới và không tự xem chi tiết mới là lore chính thức.

## 1. Bản sắc sản phẩm và trải nghiệm

### 1.1 Core identity

**CONFIRMED STYLE:** Dark Fantasy, Gothic, 2D Illustration.

Babel phải tạo cảm giác như một tác phẩm minh họa có thể tương tác: một hành trình nguy hiểm, căng thẳng, cô độc và bí ẩn qua một thế giới tôn giáo cổ xưa, áp bức và mục ruỗng.

Cảm xúc chủ đạo:
- Nguy hiểm và áp lực sinh tồn.
- Cô độc, lạc lõng.
- Bất an, bí ẩn và tò mò.
- Khám phá căn phòng, sinh vật, giáo phái và lore chưa biết.
- Cảm giác về lịch sử tôn giáo cổ xưa và những địa điểm linh thiêng đã suy tàn.

Reference được người dùng nêu: **Darkest Dungeon, Blasphemous, Fear & Hunger**. Chỉ chắt lọc mood, tương phản sáng tối, ngôn ngữ minh họa, ornament, grotesque imagery và cảm giác thế giới áp bức. Không sao chép UI, asset hay thiết kế đặc trưng của các game đó.

### 1.2 Rendering, độ chi tiết và vật liệu

- **CONFIRMED:** Trình bày 2D illustration.
- **CONFIRMED:** Mức chi tiết trung bình; đủ để tạo thế giới có chiều sâu nhưng không làm hình ảnh quá nhiễu.
- **CONFIRMED:** Ánh sáng cinematic, cân bằng sáng và tối.
- **CONFIRMED materials:** Đá, kim loại, sắt gỉ.
- **CONFIRMED frames:** Khung cổ điển, ornate, Gothic.
- Hình nền thế giới phải giàu chi tiết nhưng UI vẫn phải dễ đọc.
- Dùng negative space và focal point có chủ đích để người chơi phân biệt môi trường, quái vật, bẫy và điểm tương tác.

### 1.3 Nguyên tắc trình bày

Ưu tiên artwork căn phòng. UI là lớp thông tin tiết chế đặt trên thế giới, không phải dashboard lấn át hình ảnh. Phần lớn chức năng phụ được ẩn cho đến khi người chơi yêu cầu mở.

## 2. Thế giới, camera và căn phòng

### 2.1 Camera và mô hình room

- **CONFIRMED:** Góc nhìn first-person, trình bày theo fixed scene.
- Mỗi room là một bức tranh/background minh họa tĩnh.
- Người chơi không tự do di chuyển trong một không gian 3D liên tục.
- Người chơi gieo xúc xắc để quyết định di chuyển. Sau kết quả, background thay đổi dần để truyền đạt hành trình sang room tiếp theo.
- **CONFIRMED reveal rule:** Hiển thị toàn bộ căn phòng ngay từ đầu. Người chơi quan sát và tự nhận diện nguy hiểm; không reveal từng phần.
- Quái vật đã hiện diện trong artwork của room. Người chơi phát hiện chúng bằng quan sát; không cần hiệu ứng pop-in riêng cho mọi enemy.

### 2.2 Bố cục artwork room

- Background room chiếm toàn màn hình và mang phần lớn bầu không khí.
- Monster có thể là asset/layer riêng nhưng phải hòa nhập tự nhiên vào background.
- Bố cục cần đọc được môi trường, silhouette quái vật, bẫy và điểm đáng chú ý.
- Animation môi trường rất ít; room gần như tĩnh.
- Có thể dùng chuyển động khí quyển rất nhẹ: lửa, khói, bụi, vải, tàn lửa hoặc ánh sáng. Tránh animation nền quá bận rộn.
- Nhận diện vùng đến từ background, kiến trúc, palette và motif, không đến từ việc thay UI.

### 2.3 Room type và discovery

Các room type đã xuất hiện trong prototype/thiết kế:
- Monster
- Trap
- Pray
- Teleport
- Event
- Bonfire

Đây là danh sách hiện biết, chưa khẳng định là taxonomy cuối cùng.

Quy tắc Dictionary:
- Room và trap chỉ được ghi nhận sau khi người chơi vượt qua.
- Monster chỉ được ghi nhận sau khi người chơi sống sót qua trận chiến.
- Không hiển thị đầy đủ enemy stats trong combat HUD.

### 2.4 Chuyển room

- **CONFIRMED duration:** khoảng 0.5–0.8 giây.
- Fade về đen rồi reveal room mới.
- Có thể thêm camera tiến về phía trước, nhịp bước/camera bob nhẹ và tiếng bước chân trước hoặc quanh thời điểm chuyển cảnh.
- Cảm giác chuyển cảnh phải có trọng lượng và chủ đích, không giống chuyển tab UI.
- Không kéo dài camera travel không cần thiết; giữ rõ cấu trúc room-based.

## 3. Art direction UI dùng chung

### 3.1 Một hệ UI cho cả ba vùng

**QUY TẮC CONFIRMED QUAN TRỌNG:** Cả ba vùng dùng chung một hệ UI.

Không tạo HUD layout riêng, panel structure riêng, vị trí button riêng hoặc ba bộ skin UI tách biệt theo vùng.

Các yếu tố phải giống nhau ở Region A, B, C:
- Cấu trúc và vị trí HUD.
- Các chức năng Inventory, Character/Status, Skill, Dictionary/Bestiary, Quest/Journal, Settings.
- Hình học panel và behavior tương tác.
- Typography system.
- Ngôn ngữ frame và icon tổng thể.
- Vị trí và behavior của nút action chính.

Sự khác biệt vùng chỉ nằm ở nội dung thế giới:
- Background và kiến trúc môi trường.
- Thiết kế quái vật.
- Thiết kế NPC và trang phục.
- Minh họa item/card rơi ra.
- Motif và biểu tượng giáo phái xuất hiện trong thế giới hoặc artwork nội dung.

UI là công cụ ổn định để người chơi đi qua những thế giới khác nhau.

### 3.2 Typography

**CONFIRMED:**
- Font tiêu đề: Gothic.
- Font nội dung: readable serif.
- Ưu tiên: cân bằng không khí và khả năng đọc.

Hướng dẫn:
- Gothic display font cho title, heading, nhãn lớn và một số tiêu đề trang trí.
- Readable serif cho mô tả, lore, item effect, Dictionary và đoạn văn dài.
- Không dùng blackletter quá cầu kỳ cho paragraph dài hoặc label nhỏ.
- Tạo hierarchy bằng size, weight, spacing và contrast, không chỉ bằng font trang trí.
- Font phải hỗ trợ đầy đủ dấu tiếng Việt nếu nội dung/localization tiếng Việt được sử dụng.

### 3.3 Iconography

**CONFIRMED:**
- Icon style: engraved.
- Màu icon: monochrome.
- Mỗi giáo phái có hệ biểu tượng riêng.

Icon nên trông như được khắc, chạm, dập hoặc ăn mòn trên vật liệu. Mặc định dùng monochrome tiết chế; không biến mọi icon thành minh họa nhiều màu. Biểu tượng giáo phái có thể xuất hiện trên kiến trúc, room art, quần áo NPC, item, relic và Dictionary.

**Chưa quy định:** Biểu tượng chính thức của Babel.

### 3.4 Frame và vật liệu UI

**CONFIRMED:**
- UI frame: ornate Gothic.
- Kim loại: aged bronze.
- Bề mặt panel: dark stone.
- Hoa văn: religious.
- Nguồn gốc frame Inventory: liên quan đến một cult.

Frame nên có cảm giác là vật thể tôn giáo được chế tác hoặc di vật, không phải viền fantasy phẳng thông thường. Aged bronze dùng cho cạnh, góc, chi tiết khắc, bản lề và highlight. Dark stone là bề mặt chính. Ornament tôn giáo phải tiết chế, không đặt chi tiết dày phía sau text.

**Chưa quy định:** Chính xác cult/tổ chức/di vật nào tạo ra Inventory frame. Không tạo ba UI frame khác nhau cho ba vùng.

### 3.5 Mật độ UI và bố cục

- **CONFIRMED:** Artwork chiếm toàn màn hình, chỉ có một số ít control hiện thường trực.
- Bố cục tham khảo sự tiết chế kiểu Diablo: thế giới là trung tâm, thông tin nhân vật và vài nút nằm dưới đáy màn hình.
- Panel phụ chỉ xuất hiện khi được mở.
- Cân bằng artwork và UI; không bên nào lấn át bên còn lại.
- Hầu hết thành phần UI có Gothic frame, nhưng ornament không được ảnh hưởng readability.

## 4. HUD

### 4.1 Character HUD

- **CONFIRMED placement:** Góc dưới bên trái.
- Khu vực này chỉ có portrait nhân vật và hiển thị HP.
- Portrait tròn, gợi nhớ Diablo.
- HP hiển thị bằng các pip/segment rời, không phải thanh liên tục.
- Theo quyết định UI mới, HUD hiển thị Mind bằng thang trực quan −5..+5 có số hiện tại; portrait tiếp tục đổi sắc thái để truyền đạt trạng thái.

### 4.2 Mind portrait

- **CONFIRMED:** Có 3–5 trạng thái portrait phân biệt rõ.
- Mind càng thấp, portrait càng trở nên điên loạn/bất ổn.
- Chi tiết có thể thay đổi: mắt và đồng tử; nụ cười/nét mặt; da, vết thương, vết nứt; tư thế và hình dáng cơ thể.
- Portrait là phương tiện phản ánh trạng thái và kể chuyện, không phải chỉ báo số liệu.
- Các trạng thái phải phân biệt được ở kích thước HUD nhỏ.
- Khi mở Inventory, nhân vật xuất hiện toàn thân. Tư thế và diện mạo thay đổi theo trang bị.
- **Chưa quy định:** Ngưỡng Mind cụ thể và số portrait state cuối cùng trong khoảng 3–5.

### 4.3 Nút action chính

- **CONFIRMED placement:** Góc dưới bên phải.
- Nút tròn lớn, tham khảo action control kiểu Diablo.
- Không có text label.
- Nút phụ thuộc ngữ cảnh: icon và màu nền đổi theo action hiện tại.
- Ví dụ màu do người dùng đưa ra: Move = xanh lá; Attack = đỏ; Pray = tím.
- Đây là ví dụ ngữ nghĩa màu; bảng màu chính xác cho toàn bộ action chưa được quy định.
- Nhấn nút là thực thi action hiện tại ngay lập tức. Không thêm bước xác nhận phụ trừ khi một action cụ thể thật sự cần.
- Lần đầu mỗi loại xúc xắc được sử dụng, tên loại xúc xắc được ghi vào Dictionary. Nút không hiển thị text label.

### 4.4 Các control giữa đáy màn hình

Các chức năng:
1. Inventory
2. Character / Status
3. Skill
4. Dictionary / Bestiary
5. Quest / Journal
6. Settings

Giữ chúng gọn, không cạnh tranh với room artwork.

## 5. Panel, Inventory và Dictionary

### 5.1 Behavior mở panel

- **CONFIRMED:** Inventory và Dictionary mở thành panel trung tâm.
- Background/thế giới tối đi khi mở panel lớn.
- Panel gồm hai nửa trượt vào từ hai phía đối diện và ghép lại ở giữa.
- Thời gian mở: khoảng 0.5–0.7 giây.
- Chuyển động có trọng lượng như hai mặt vật liệu nặng khép lại.
- Click bên ngoài panel để đóng.
- Các panel lớn dùng ngôn ngữ chuyển động nhất quán, trừ khi quyết định sau này quy định ngoại lệ.

### 5.2 Cấu trúc Inventory

**CONFIRMED:**
- Bên trái: 4 ô túi đồ và 1 ô vũ khí riêng.
- Bên phải: nhân vật toàn thân và các ô trang bị.
- Card/item là hình chữ nhật đứng.
- Khi ở trạng thái mở rộng/chưa chọn, card có minh họa và effect.
- Khi đặt vào slot, card thu gọn chỉ còn minh họa.
- Chọn card thì card phóng to và hiển thị đầy đủ thông tin.
- Selected state: expand, không chỉ viền sáng mỏng.
- Disabled/locked state: darkened.

Inventory phải có cảm giác người chơi đang thao tác với card/relic vật lý nằm trong một artifact frame liên quan đến giáo phái.

### 5.3 Nhân vật trong Inventory

- Hiển thị nhân vật toàn thân trong Inventory.
- Tư thế nhân vật thay đổi theo trang bị.
- Trang bị nên tác động trực quan lên nhân vật nếu pipeline asset hỗ trợ.
- Không giới hạn nhân vật ở portrait tròn HUD; Inventory là nơi thể hiện full-body equipment.

### 5.4 Dictionary / Bestiary

Dictionary là bách khoa toàn thư mở khóa theo khám phá, có cách phân loại kiểu bảo tàng/taxonomy. Reference cảm giác tổ chức là Bestiary/Codex của The Witcher 3, không sao chép UI.

**Danh mục đã chốt:**
- Monsters
- Room types
- Traps
- Characters / NPCs
- Items / Cards
- Cults
- Regions / Floors
- Secrets / Lore notes
- Dice types (lần đầu sử dụng mỗi loại xúc xắc sẽ ghi tên vào đây)

Quy tắc:
- Monster entry mở sau khi người chơi sống sót qua trận chiến.
- Room và trap entry mở sau khi vượt qua.
- Không đưa full monster stats lên combat HUD; thông tin thuộc Dictionary.
- Dictionary thể hiện quá trình khám phá và tích lũy tri thức, không phải database đầy đủ mở sẵn từ đầu.
- **Chưa quy định:** Trường dữ liệu mỗi entry, trạng thái hoàn thành, sort/filter.

### 5.5 Thông tin enemy trong combat

- Trong combat, chỉ hiển thị hình ảnh monster như đại diện trực quan của enemy.
- Không có monster HP panel hoặc detailed enemy stat block trên combat HUD.
- Không tự thêm monster HP bar chỉ vì RPG thường có.
- Thông tin và lore enemy nằm trong Dictionary sau điều kiện discovery phù hợp.
- Demon/monster art hiện tại trong prototype là placeholder, không được xem là chuẩn thiết kế cuối.

## 6. Dice, movement và combat feedback

### 6.1 Trình bày xúc xắc

- **CONFIRMED:** Xúc xắc 2D minh họa, lăn trên một bề mặt.
- Reference cách trình bày: dice presentation có cảm giác vật lý, có chủ đích của Baldur's Gate 3, nhưng chuyển hóa theo chất liệu Gothic minh họa của Babel.
- Xúc xắc phải có cảm giác nặng.
- Có khoảnh khắc va chạm/tiếp đất rõ.
- Mặt/icon kết quả phát sáng để báo kết quả.
- Tránh popup số ngẫu nhiên xuất hiện tức thì.

Trình tự gợi ý:
1. Xúc xắc xuất hiện trên bề mặt lăn.
2. Xúc xắc lăn với quán tính và trọng lượng.
3. Xúc xắc va/đáp xuống rõ ràng.
4. Mặt/icon kết quả phát sáng.
5. Game xử lý action dựa trên kết quả.

**Chưa quy định:** Timing chi tiết, camera framing, physics implementation và sound design. Cảm giác nặng, tactile là yêu cầu đã chốt.

### 6.2 Movement feedback

- Sau kết quả dice, truyền đạt chuyển động tiến về phía trước.
- Camera movement và step rhythm/bob nhẹ.
- Footstep audio hỗ trợ chuyển động.
- Chuyển sang room kế tiếp bằng fade-to-black.
- Người chơi phải cảm nhận kết quả di chuyển đã đưa họ qua chuỗi room, dù room presentation là fixed-scene.

### 6.3 Combat presentation

- Monster đã có mặt trong room art.
- Khi combat, dice của player và monster xuất hiện đồng thời.
- Khi outcome được quyết định, hiển thị impact/attack effect.
- Monster nhận damage: flinch mạnh rồi trở về idle.
- Player nhận damage: một health pip vỡ, màn hình rung nhẹ.
- Screen shake tiết chế; cảm giác nặng chứ không hỗn loạn.
- Monster idle gần như bất động và có tính đe dọa.
- Không cho enemy chuyển động liên tục làm xao nhãng artwork.

### 6.4 Death

- Player death có một death sequence minh họa riêng.
- Đây là sự kiện có ý nghĩa kể chuyện, không chỉ là game-over overlay thông thường.
- **Chưa quy định:** Trình tự, thời lượng và branching.

## 7. Nguyên tắc animation

### 7.1 Ngôn ngữ chuyển động

- **CONFIRMED:** Mượt, tinh tế, tiết chế.
- Phần lớn môi trường gần như tĩnh.
- Tương tác quan trọng phải có trọng lượng và quan hệ nguyên nhân-kết quả rõ.
- Tránh UI bounce, overshoot, elastic motion quá mức hoặc idle animation liên tục.
- Chuyển động củng cố cảm giác vật lý: dice nặng, panel nặng, chuyển cảnh có chủ đích, impact dứt khoát.

### 7.2 Timing đã chốt

| Tương tác | Thời lượng mục tiêu |
|---|---:|
| Room transition | 0.5–0.8 giây |
| Mở Inventory / Dictionary | 0.5–0.7 giây |

Đây là khoảng thời lượng mục tiêu, không phải yêu cầu frame-perfect.

### 7.3 Bảng feedback

| Sự kiện | Feedback yêu cầu |
|---|---|
| Dice roll | Lăn 2D nặng trên bề mặt |
| Dice result | Mặt/icon kết quả phát sáng |
| Player movement | Cảm giác tiến về trước, nhịp bước nhẹ, footsteps |
| Room transition | Fade to black rồi reveal room |
| Combat resolution | Dice player và monster giải quyết đồng thời, sau đó impact |
| Player mất HP | Một pip vỡ, screen shake nhẹ |
| Monster mất HP | Flinch mạnh rồi trở về idle gần tĩnh |
| Mở Inventory / Dictionary | Background tối, hai nửa panel ghép lại |
| Chọn card | Card phóng to và hiện đầy đủ thông tin |
| Card/control disabled | Darkened |
| Player death | Death sequence minh họa riêng |

## 8. Quy tắc thế giới theo vùng

### 8.1 Ba vùng

| Region | Giáo phái | Bản sắc đã chốt |
|---|---|---|
| Region A | Dục Đạo Giáo | Ham muốn, dục vọng, cám dỗ, tôn giáo nhục cảm suy đồi |
| Region B | Hỏa Ngục Giáo | Bạo lực, trừng phạt, đau khổ, Địa Ngục là Thiên Đường |
| Region C | Đà La Môn | Chiếm hữu tất cả, tham lam, sự hoàn mỹ áp đặt, thao túng thực tại |

Các vùng phải có cảm giác như những thế giới riêng. Khác biệt thể hiện qua:
- Background artwork.
- Kiến trúc và motif môi trường.
- Monster design.
- NPC design và trang phục.
- Dropped item/relic/card illustration.
- Cult symbol và decorative motif trong thế giới.

Không thay global UI layout và không tạo interface system riêng cho từng vùng.

### 8.2 Quan hệ Floor 1 và Floor 2

**QUY TẮC GLOBAL CONFIRMED:**
- Floor 2 là phiên bản dị giáo của Floor 1.
- Hướng dị giáo tổng thể: **Blasphemous**.
- Floor 2 giữ kiến trúc/motif nhận diện được từ Floor 1 nhưng remix layout.
- Mức biến đổi: **Extreme**.
- Floor 2 gần như một thế giới kinh dị khác, nhưng người chơi vẫn nhận ra nguồn gốc motif.
- Không chỉ phủ màu tối hơn, thêm máu hoặc xác chết.
- Biểu tượng thiêng, giáo lý, nghi thức, kiến trúc và sinh vật bị bóp méo, đảo ngược, báng bổ hoặc đẩy tới cực hạn.
- Mỗi vùng diễn giải quy tắc này theo chủ đề riêng.

### 8.3 Bảng so sánh vùng

| Thành phần | Region A | Region B | Region C |
|---|---|---|---|
| Động lực cốt lõi | Ham muốn / khoái lạc | Bạo lực / trừng phạt | Chiếm hữu mọi thứ / hoàn mỹ |
| Visual identity | Tôn giáo Gothic nhục cảm suy đồi | Đại giáo đường địa ngục | Cung điện arcane xa hoa |
| Palette | Đen, đỏ thẫm, vàng | Đen, crimson, cam lửa | Vàng, tím, đen |
| Kiến trúc | Đền thờ suy đồi | Infernal cathedral | Palace xa hoa |
| Monster | Người / humanoid | Executioners | Hybrid |
| NPC | Devotees | Fanatics | Aristocrats |
| Drop | Relics | Mixed | Treasures |
| Floor 2 | Flesh | Eternal Hell | Transformation |

## 9. Region A — Dục Đạo Giáo

### 9.1 Core concept

**CONFIRMED:** Dục Đạo Giáo là tôn giáo lấy ham muốn và tình dục làm trung tâm.

Giáo phái tôn thờ dục vọng, ham muốn tình dục, khoái lạc, cám dỗ và sự từ bỏ kiềm chế. Kiến trúc, nghi thức, trang phục, tạo hình cơ thể và hình ảnh tôn giáo phải thể hiện một nền tôn giáo suy đồi, nơi nhục cảm được nâng thành giáo lý.

Đây không phải một khu vực quỷ generic chỉ có màu đỏ. Bản sắc của nó là một nền văn minh tôn giáo xa hoa, quyến rũ, suy đồi và bất an.

### 9.2 Gameplay purpose

**CONFIRMED CORE GOAL:** Region A tác động lên Mind của người chơi. Mục tiêu nền tảng của vùng là đưa Mind về 0 và khiến người chơi chìm vào trạng thái khoái lạc tột độ.

Đây là quan hệ chủ đề/gameplay ở cấp vùng. Không tự đặt số Mind damage, trigger, threshold hoặc một status-effect system hoàn chỉnh; các cơ chế đó chưa được chốt.

Portrait người chơi phải hỗ trợ chủ đề này qua các Mind portrait stage đã xác định. Khi Mind suy giảm, portrait có thể ngày càng bất ổn và biến dạng.

### 9.3 Visual direction

**Các lựa chọn đã xác nhận:**
- Core: desire.
- Architecture: temple.
- Mood: decadent.
- Palette: black, deep red, gold.
- Monsters: human / humanoid.
- NPCs: devotees.
- Items: relics.
- Floor 2: flesh.

**Mô tả trực tiếp từ người dùng:**
- Kiến trúc là công trình tôn giáo suy đồi: xa hoa, hướng khoái lạc, phóng túng và mục ruỗng.
- Có tượng và biểu tượng tôn giáo mang ngôn ngữ gợi dục/erotic.
- Trang phục kết hợp nghi lễ, quyến rũ và táo bạo.
- Tạo hình cơ thể có thể được sexualize như một phần bản sắc giáo phái hư cấu.
- BABEL là game 18+. Hình ảnh tình dục trưởng thành, khỏa thân và máu me/gore được phép sử dụng theo đúng chủ đề dark fantasy; không cần né tránh chỉ vì mức độ trực diện.
- Mọi nhân vật xuất hiện trong hình ảnh hoặc ngữ cảnh tình dục phải được thể hiện rõ là người trưởng thành.
- Mức độ trực diện có thể thay đổi theo cảnh để phục vụ nhịp điệu và cảm xúc; đây là lựa chọn nghệ thuật, không phải giới hạn nội dung.

### 9.4 Vật liệu, motif và nội dung

- Đá đen, vàng/bronze cũ, vải crimson đậm và highlight ấm có kiểm soát.
- Temple interior, ritual hall, sanctuary, tượng, ceremonial object và không gian tôn giáo trang trí cầu kỳ.
- Cult motif kết hợp quyền uy tôn giáo với biểu tượng nhục cảm.
- NPC đọc được như tín đồ/người tham gia nghi lễ, không phải dân fantasy chung chung.
- Monster là người hoặc humanoid biến đổi theo giáo lý.
- Item rơi ra chủ yếu đọc như relic hoặc vật phẩm thiêng/nghi lễ, kể cả khi hình dạng bất an.

### 9.5 Floor 2 — Flesh Heresy

Quy tắc Floor 2 chung là Blasphemous + remix layout + extreme transformation. Region A thể hiện bằng **Flesh**.

Hướng triển khai:
- Kiến trúc thiêng biến thành dạng hữu cơ/thịt.
- Tượng và biểu tượng tôn giáo hòa trộn với cơ thể hoặc bị thay bằng hình thể sinh học.
- Sinh vật có nguồn gốc con người biến thành grotesque và biến dạng thể chất hơn.
- Nghi thức trở thành quá trình biến đổi cơ thể.
- Người chơi nhận ra motif temple của Floor 1 nhưng gặp một phiên bản bị biến đổi cực đoan, đáng sợ.
- Không biến thành lớp gore phủ lên background. Sự biến đổi phải tác động đến kiến trúc, bố cục, biểu tượng và silhouette creature.

## 10. Region B — Hỏa Ngục Giáo

### 10.1 Core concept

**CONFIRMED:** Hỏa Ngục Giáo tôn thờ bạo lực và sự trừng phạt.

Sự đảo ngược thần học cốt lõi:

**Địa Ngục không phải hình phạt cần trốn thoát. Địa Ngục là Thiên Đường, là đích đến cần đạt tới.**

Một phiên bản bóp méo của Dante's Inferno / phần Inferno trong Divine Comedy là nguồn cảm hứng. Giáo phái xem Địa Ngục là đích đến tối thượng và đau khổ là con đường thiêng liêng.

Đây không đơn thuần là cult lửa. Lửa là ngôn ngữ hình ảnh quan trọng, nhưng giáo lý còn bao gồm trừng phạt, bạo lực, đau khổ, hiến tế, kỷ luật và hủy diệt.

### 10.2 Thần học và chủ đề

Người dùng chọn **tất cả** các quan niệm sau về Địa Ngục:
- Paradise: Địa Ngục là thiên đường thật, nơi linh hồn đạt tới hoàn mỹ qua đau khổ.
- Trial: thử thách cuối cùng; chỉ kẻ chịu đựng được mới xứng đáng.
- Justice: công lý tuyệt đối; mọi sinh thể đều phải nhận hình phạt.
- Divinity: đau đớn là hình thức giao tiếp với thần linh.

Người dùng chọn **tất cả** hình thức bạo lực:
- Punishment: hành quyết, tra tấn và thi hành bản án.
- War: sức mạnh, chinh phạt và hủy diệt.
- Sacrifice: đau khổ tự nguyện hoặc bị ép buộc.
- Discipline: đau đớn như rèn luyện và thanh tẩy.

Xem đây là các giáo lý/thực hành cùng tồn tại, không phải các lựa chọn loại trừ nhau.

### 10.3 Visual direction

**Các lựa chọn đã xác nhận:**
- Architecture: infernal cathedral.
- Palette: black, crimson, fire orange.
- Monsters: executioners.
- NPCs: fanatics.
- Items: mixed.
- Floor 2: eternal Hell.

Hướng triển khai:
- Đại giáo đường Gothic địa ngục có quy mô đồ sộ.
- Đá đen, sắt, xiềng xích, kim loại cháy sém, tro và lửa.
- Tượng tôn giáo khổng lồ, quy mô áp bức, altar cháy và không gian thiêng địa ngục.
- Kiến trúc mang cảm giác đồ sộ, độc đoán và áp bức.
- Lửa và ánh đỏ/cam là ngôn ngữ môi trường mạnh, cân bằng bằng đen sâu và bóng tối.
- Monster là executioner/jailer/punisher, thường có tạo hình biến dạng.
- NPC là fanatics thực sự tin giáo lý và có thể tự nguyện chấp nhận trừng phạt.
- Drop có thể pha trộn vũ khí, relic, ritual tool, dụng cụ trừng phạt, vật phẩm liên quan linh hồn và artifact địa ngục. Tỷ lệ cụ thể còn mở.

### 10.4 Cảm hứng Dante

Có thể lấy cảm hứng từ Inferno của Dante ở:
- Cấu trúc Địa Ngục nhiều tầng/lớp.
- Phân loại tội lỗi, hình phạt và trật tự tâm linh.
- Những không gian có luật lệ và hình phạt riêng.
- Executioner/warden là người thi hành trật tự thiêng, không chỉ là quái vật ác generic.
- Sự đảo ngược thần học: trừng phạt là con đường tới thiên đường.

Không mặc định Babel phải sao chép chính xác chín tầng địa ngục của Dante. Cosmology và hierarchy riêng của Babel sẽ được phát triển sau.

### 10.5 Floor 2 — Eternal Hell

Người dùng chọn hướng **Eternal Hell**.

Hướng triển khai:
- Motif infernal cathedral từ Floor 1 vẫn nhận ra được.
- Layout được remix và biến đổi cực đoan.
- Không gian có cảm giác vô tận, đệ quy hoặc không thể thoát.
- Hành lang, đại sảnh, cổng và cầu thang có thể gợi ý rằng mọi lối thoát đều dẫn sâu hơn vào cùng một Địa Ngục.
- Thời gian, giải thoát, tha thứ và khái niệm kết thúc dường như biến mất.
- Trừng phạt không còn là sự kiện riêng lẻ; nó trở thành trạng thái vĩnh cửu.
- Không diễn giải đơn giản thành nhiều lửa hơn/nhiệt độ cao hơn. Cốt lõi là sự không có hồi kết.

## 11. Region C — Đà La Môn

### 11.1 Core concept

**CONFIRMED:** Đà La Môn tôn thờ lòng tham và khát vọng chiếm hữu mọi thứ.

Nguồn cảm hứng người dùng nêu:
- **Emperor's Children (Warhammer 40,000):** xa hoa suy đồi, excess, vẻ đẹp, nhục cảm và tha hóa.
- **Tzeentch (Warhammer):** ma thuật, mưu đồ, biến đổi, tri thức cấm và thao túng thực tại.

Đây chỉ là reference cảm hứng. Không sao chép tên, nhân vật, iconography, faction, armor design hay lore có bản quyền vào Babel.

Có thể diễn đạt tư tưởng cốt lõi của giáo phái:

**Mọi thứ tồn tại đều có thể bị chiếm hữu, hoàn thiện, biến đổi và biến thành của ta.**

Người dùng làm rõ Đà La Môn chịu ảnh hưởng một phần giáo lý Dục Đạo Giáo. Trang phục phải xa hoa, lộng lẫy và cũng gợi dục/táo bạo. Đây là ảnh hưởng một phần, không có nghĩa Region C trở thành bản sao Region A.

### 11.2 Cảm hứng văn hóa và kiến trúc

Người dùng mô tả vùng này dựa một phần trên Islam. Hãy xem đây là nguồn cảm hứng kiến trúc/nghệ thuật cho một tôn giáo hư cấu, không phải khẳng định rằng Islam ngoài đời thực tham lam, suy đồi hay tà ác.

Từ vựng hình ảnh có thể tham khảo:
- Dome và không gian vòm lớn.
- Arch, courtyard và quần thể cung điện.
- Hình học trang trí, đối xứng và hoa văn bề mặt phức tạp.
- Nội thất cung điện cầu kỳ, vật liệu quý và vải vóc tinh xảo.
- Hệ chữ viết/biểu tượng giả tưởng được sáng tạo riêng cho Babel.

Tránh dùng trực tiếp kinh văn thiêng, biểu tượng tôn giáo thật hoặc nghi thức thờ phụng ngoài đời làm ký hiệu cho cái ác. Hãy tạo thần học và iconography hư cấu riêng, đồng thời sử dụng cảm hứng kiến trúc/trang trí một cách tôn trọng.

### 11.3 Các lựa chọn đã xác nhận

- Đối tượng chiếm hữu: **everything** — của cải vật chất, tri thức, quyền lực, linh hồn, sự sống và mọi thứ khác.
- Giáo lý: **perfection** — thế giới chưa hoàn hảo và giáo phái tin rằng họ có quyền tái tạo nó.
- Thẩm mỹ: decadent.
- Kiến trúc: palace.
- Palette: gold, purple, black.
- Ma thuật: reality manipulation.
- Quái vật: hybrid forms.
- NPC: aristocrats.
- Vật phẩm: treasures.
- Floor 2: transformation.

### 11.4 Visual direction

- Kiến trúc cung điện xa hoa, không phải một desert level generic.
- Vàng, tím và đen là palette chủ đạo.
- Bề mặt lộng lẫy, vật liệu quý, ornament cầu kỳ và sự xa hoa thái quá.
- Mood decadent, áp đảo và uncanny.
- NPC chủ yếu đọc được là quý tộc: trang phục cầu kỳ, trang sức, biểu tượng địa vị và cách phô bày quyền lực có kiểm soát.
- Trang phục xa hoa và gợi dục, phản ánh ảnh hưởng một phần từ Dục Đạo Giáo.
- Monster là hybrid, kết hợp nhiều hình thái hoặc chủng loại theo cách phi tự nhiên nhưng có chủ đích.
- Reality manipulation phải tác động tới môi trường và logic thị giác, không chỉ là hiệu ứng phép tím.
- Drop chủ yếu đọc như treasure: vật quý, đồ hiếm, artifact trang trí và thứ đáng để chiếm hữu.

### 11.5 Ma thuật — Reality Manipulation

Hướng ma thuật đã xác nhận là **Reality Manipulation**.

Hướng triển khai:
- Bóp méo không gian, tỷ lệ, hình học, phối cảnh và quy luật vật lý.
- Dùng kiến trúc bất khả thi, không gian đứt đoạn, cấu trúc lơ lửng/lệch trục, motif đệ quy và surrealism có kiểm soát.
- Môi trường nên tạo cảm giác được thiết kế bởi một quyền lực tin rằng nó có thể viết lại thực tại.
- Không tự quyết định spell list, combat system hoặc shader implementation cụ thể; các phần này còn mở.

### 11.6 Floor 2 — Transformation

Người dùng chọn **Transformation**.

Hướng triển khai:
- Motif palace từ Floor 1 vẫn nhận ra được nhưng bị remix thành môi trường biến đổi cực đoan.
- Vật thể, kiến trúc và sinh vật dường như liên tục hoặc bị cưỡng ép biến thành hình thái khác.
- Giáo lý hoàn mỹ áp đặt bị đẩy đến cực hạn: mọi thứ bị sửa đổi để phù hợp với lý tưởng của giáo phái.
- Reality manipulation và transformation phải hỗ trợ lẫn nhau.
- Kết quả là một thế giới xa hoa nhưng trật tự trở nên bất ổn và xâm lấn, không chỉ là cung điện đổ nát.
- Giữ quy tắc Floor 2 chung: motif nguồn còn nhận ra được, layout remix, biến đổi cực độ.

## 12. Tương phản chủ đề giữa ba vùng

| Chủ đề | Region A — Dục Đạo Giáo | Region B — Hỏa Ngục Giáo | Region C — Đà La Môn |
|---|---|---|---|
| Động lực | Ham muốn và khoái lạc | Bạo lực và trừng phạt | Tham lam và chiếm hữu tất cả |
| Lời hứa | Khoái lạc cực độ / buông bỏ | Thiên đường qua đau khổ | Hoàn mỹ qua chiếm hữu và biến đổi |
| Visual language | Đền tôn giáo nhục cảm suy đồi | Infernal cathedral đồ sộ | Cung điện arcane xa hoa |
| Palette | Đen / đỏ thẫm / vàng | Đen / crimson / cam lửa | Vàng / tím / đen |
| Floor 2 | Flesh | Eternal Hell | Transformation |

Không làm phẳng ba vùng thành cùng một aesthetic corruption generic. Mỗi vùng giữ visual grammar riêng khi áp dụng quy tắc Blasphemous chung cho Floor 2.

## 13. Card và rarity

### 13.1 Card composition

**CONFIRMED:**
- Card art-dominant: minh họa là trọng tâm.
- Card back: none; không cần thiết kế mặt sau riêng.
- Card hình chữ nhật đứng.
- Khi đặt trong inventory slot, card thu gọn còn minh họa.
- Khi chọn, card expand và hiện đầy đủ thông tin.
- Selected state: expand.
- Disabled state: darkened.

Hướng dẫn:
- Không phủ quá nhiều text, badge hoặc ornament lên artwork.
- Expanded state phải dễ đọc và phân biệt rõ với compact slot state.
- Không tự tạo card reverse cầu kỳ.
- Card dùng chung global grammar; illustration/content art có thể truyền đạt nguồn gốc vùng.

### 13.2 Rarity

**CONFIRMED:**
- 5 rarity tiers.
- Rarity thể hiện bằng màu.
- Palette direction: Gothic.

**Chưa quy định:** Tên 5 tier, mã màu chính xác và việc có dùng thêm frame detail ngoài màu hay không. Không tự tạo tên rarity hoặc hex color rồi coi là quyết định chính thức. Nếu sau này cần accessibility signal bổ sung, có thể kết hợp hình dạng/ornament, nhưng màu vẫn là phương thức chính đã chọn.

## 14. Audio direction

Định hướng đã biết:
- Mỗi vùng có bản sắc audio/music riêng, tương tự khác biệt về kiến trúc, palette và creature.
- Footsteps hỗ trợ chuỗi movement.
- Môi trường gần như tĩnh; âm thanh có thể mang atmosphere tinh tế.
- **Chưa quy định:** Soundtrack, nhạc cụ, motif âm nhạc, combat sound và palette âm thanh cụ thể từng vùng.

Không tự suy diễn audio spec cuối cùng chỉ từ quyết định visual.

## 15. Hướng dẫn triển khai cho Codex

### 15.1 Thứ tự ưu tiên

1. Giữ full-screen illustrated room là lớp hình ảnh chính.
2. Một global HUD và panel system dùng chung cả ba vùng.
3. Bottom-left round character portrait với health pip rời.
4. Mind có thang trực quan giới hạn −5..+5; portrait stage tiếp tục bổ trợ trạng thái.
5. Nút action tròn lớn bottom-right, đổi icon/màu theo action và thực thi ngay.
6. Các chức năng phụ ở center-bottom và hidden panels.
7. Panel hai nửa ghép lại, background dim.
8. Dùng 4 ô túi đồ, 1 ô vũ khí riêng và panel nhân vật/trang bị hai bên.
9. Card có compact/expanded/selected/disabled states.
10. Không có enemy stats trong combat HUD; dùng enemy image khi combat, Dictionary cho discovery.
11. Dice sequence có roll nặng, impact và result glow.
12. Room transition, damage feedback và enemy flinch tiết chế.
13. Tổ chức art asset theo Region A/B/C và Floor 1/Floor 2 như content variation trong cùng UI framework.

### 15.2 Gợi ý tổ chức data/content

Đây là gợi ý triển khai, không phải mệnh lệnh phải tái cấu trúc toàn bộ project. Ưu tiên convention hiện có nếu hợp lý.

- Lưu region identity trong data/resource thay vì hardcode UI layout theo vùng.
- Mỗi region tham chiếu background set, monster set, NPC set, item/relic set, palette/motif metadata và audio.
- Floor 2 là content set/variant riêng gắn với cùng region, có background room, creature và item được remix.
- Global UI theme resources được dùng chung.
- Tách card definition khỏi card presentation state.
- Tách Dictionary unlock/discovery state khỏi static encyclopedia content.
- Tách Mind gameplay value khỏi portrait-stage presentation mapping.
- Các timing, color và threshold còn mở nên cấu hình được.

### 15.3 Những điều Codex không được tự ý làm

- Không thêm monster HP bar hoặc detailed monster stats vào combat HUD.
- Mind HUD hiển thị giá trị hiện tại trên thang −5..+5 theo quyết định UI mới.
- Không tạo global UI layout khác nhau theo vùng.
- Không coi Floor 2 là Floor 1 chỉ phủ màu tối.
- Không dùng demon art placeholder làm chuẩn creature design cuối.
- Không sao chép trực tiếp asset/artwork của Darkest Dungeon, Blasphemous, Fear & Hunger, Baldur's Gate 3, Warhammer 40,000 hoặc artwork của Dante. Chỉ dùng làm high-level reference.
- Không tự đặt Mind effect cho Region B hoặc C.
- Không tự tạo Babel emblem, cult symbol, rarity name hoặc stat value rồi trình bày như quyết định đã chốt.

## 16. Nguyên tắc bảo toàn thiết kế

- Giữ chung một hệ thống UI cho cả ba vùng; vùng khác nhau qua thế giới và nội dung.
- Không hiển thị HP/chỉ số quái trên HUD chiến đấu; Mind có thang giới hạn trực quan theo quyết định mới.
- Không dùng nội dung placeholder làm chuẩn mỹ thuật cuối cùng.
- Không tự tạo biểu tượng Babel, biểu tượng giáo phái, tên/màu rarity hay cơ chế Mind chưa có trong thiết kế gameplay.
- Các tham chiếu đến tác phẩm khác chỉ dùng để mô tả cảm giác và ngôn ngữ hình ảnh; không sao chép thiết kế, artwork hay tài sản.
- BABEL là game 18+: hình ảnh tình dục trưởng thành và gore được phép; mọi nhân vật trong ngữ cảnh tình dục phải là người trưởng thành.

## 17. Tóm tắt chuẩn hình ảnh

1. Room là tranh minh họa 2D toàn màn hình, góc nhìn thứ nhất, tĩnh và có bố cục rõ.
2. UI tiết chế, dễ đọc, cùng một cấu trúc ở mọi vùng; panel lớn chỉ mở khi được yêu cầu.
3. HUD dùng thanh HP có số hiện tại/tối đa, thang Mind −5..+5 và biến đổi portrait.
4. Dice, panel, chuyển cảnh và đòn đánh có trọng lượng; animation môi trường rất nhẹ.
5. Floor 2 giữ motif nhận diện của Floor 1 nhưng biến đổi cực đoan theo giáo lý riêng của từng vùng.
6. A tập trung vào ham muốn/khoái lạc; B vào bạo lực/trừng phạt; C vào tham lam/chiếm hữu và hoàn mỹ áp đặt.
