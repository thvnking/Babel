# BABEL — Khung thiết kế trò chơi

> Tài liệu này là nguồn tham chiếu chính cho dự án BABEL. Nó mô tả ý định thiết kế, luật cốt lõi và cấu trúc nội dung để một người mới có thể tiếp tục phát triển game mà không làm lệch hướng.  
> Tài liệu được phép sửa khi thiết kế thay đổi. Những mục ghi **Đã chốt** là luật hiện hành; mục ghi **Mở** cần được thảo luận trước khi triển khai sâu.

---

## 1. Bản sắc trò chơi

**BABEL** là game hầm ngục 2D, chiến thuật theo lượt, kết hợp xúc xắc và thẻ bài trong bối cảnh dark fantasy.

Người chơi tiến vào một “ngọn tháp” thực chất là hố sâu vô tận. Càng đi “lên tầng”, họ càng bị đưa xuống gần nguồn hỗn mang dưới đáy. Họ không vào đó vì được ai hứa hẹn cứu rỗi; họ tự mang theo một hy vọng cá nhân, có thể là hão huyền, và cố bám lấy nó.

### Trụ cột trải nghiệm

1. **Tính toán trước rủi ro.** Người chơi biết luật, máu, xúc xắc và trang bị; họ phải chọn thứ mang theo và thời điểm sử dụng.
2. **Bất ngờ có luật.** Xúc xắc tạo tình huống không chắc chắn, nhưng kết quả luôn có nguyên nhân rõ ràng.
3. **Mọi thứ đều là thẻ.** Vũ khí, trang bị và vật phẩm tồn tại dưới dạng thẻ có thể nhận, dùng, mất hoặc thay thế.
4. **Sự tuyệt vọng có chủ đích.** Thế giới không trao phần thưởng công bằng. Người chơi vẫn có thể sống sót nhờ quyết định tốt, không chỉ nhờ may mắn.
5. **Thông tin tối giản trên màn chơi.** Màn hình chính ưu tiên cảnh nền, quái vật và hành động; số liệu chỉ hiện khi cần.

---

## 2. Thế giới và tiền đề cốt truyện

Thế giới bị chi phối bởi ba thế lực tôn giáo hư cấu. Bề ngoài chúng thù địch và mưu hại lẫn nhau; bên trong, cả ba đều khai thác Babel vì năng lượng kỳ lạ từ nơi đó nuôi dưỡng nghi thức và phép màu của chúng.

Các giáo phái **không hứa hẹn điều gì với người chơi**. Chúng không phải phe thiện hay nguồn cứu rỗi. Chúng là tổ chức quyền lực dùng con người như công cụ cho giáo lý, nghi thức và lợi ích của mình.

### Ba thế lực

| Thế lực | Bản chất | Cảm hứng nội dung |
|---|---|---|
| **Dục Đạo Giáo** | Sùng bái dục vọng, cấm kỵ và sự phá vỡ luân thường. | Nghi lễ thân xác, sự lệ thuộc, biến đổi và thao túng. |
| **Hỏa Ngục Giáo** | Tôn thờ quỷ dữ, tra tấn, tự hoại và bạo lực nghi lễ. | Lò luyện, nhà nguyện đổ nát, hiến tế, cuồng tín. |
| **Đà La Môn** | Tôn sùng mưu mô, xảo trá và lòng tham tuyệt đối. | Giao kèo, thương nhân, mê cung, nợ nần và phản bội. |

> Khi viết nội dung, các thế lực cần giữ bản sắc hoàn toàn hư cấu: biểu tượng, thần thoại, nhân vật và kiến trúc riêng. Không sao chép trực tiếp giáo lý, nghi thức hay biểu tượng của tôn giáo có thật.

### Babel

Babel được gọi là tháp vì không ai muốn thừa nhận nó là một cái hố. Muốn đến “tầng” cao hơn, người lữ hành phải đi sâu hơn. Không ai biết đáy hố là gì. Hỗn mang từ dưới sâu làm méo mó sinh vật, nghi lễ, ký ức và cả lý trí.

Nhân vật người chơi là những kẻ tự bước vào hố vì mục đích riêng: cứu người, chữa lời nguyền, tìm sự thật, trả thù, tìm quyền lực, hoặc chỉ muốn chứng minh rằng mình có thể chạm tới nơi không ai từng đến.

### Hướng kể chuyện

- Câu chuyện được kể qua phòng sự kiện, NPC, vật phẩm, quái vật, mô tả thẻ và thay đổi của Mind.
- Không cần một nhân vật phản diện giải thích mọi thứ. Babel phải có cảm giác cổ xưa, vô tâm và không thể hiểu hết.
- Ending được mở bởi hành động, trạng thái và những gì nhân vật đã đánh đổi; không chỉ là lựa chọn ở màn cuối.

---

## 3. Cấu trúc thế giới và bản đồ

### Đã chốt

- Có **3 khu vực**: A, B, C.
- Mỗi khu vực có **2 tầng sâu**: tầng 1 và tầng 2.
- Mỗi tầng có 6 loại quái đặc trưng theo bảng nội dung riêng.
- Tầng 2 nhìn chung nguy hiểm hơn tầng 1.

### Đồ thị dịch chuyển

Mỗi vị trí có dạng `Tầng + Khu vực`, ví dụ `1A`, `2C`.

```text
1A ─── 1B ─── 1C
│      │      │
2A     2B    2C
```

- Di chuyển ngang trong cùng tầng là hợp lệ: `1A → 1B`, `1B → 1C`.
- Đi sâu theo cùng khu vực là hợp lệ: `1A → 2A`, `2A → 1A`.
- Đi chéo tầng và khu vực là không hợp lệ: `1A → 2C`, `2A → 1C`.
- Di chuyển ngang cùng tầng 2 là không hợp lệ: 2A → 2C, 2A → 2B
- Phòng Teleport sẽ sử dụng các kết nối hợp lệ này.

### Ý nghĩa nội dung

Mỗi khu vực đại diện cho ảnh hưởng mạnh hơn của một giáo phái. Tầng 2 không chỉ là phiên bản có chỉ số cao hơn; nó phải cho thấy khu vực đó đã bị Babel biến đổi sâu hơn.

---

## 4. Vòng chơi cốt lõi

```text
Chuẩn bị nhân vật
      ↓
Tung xúc xắc di chuyển
      ↓
Xác định loại phòng
      ↓
Giải quyết phòng (chiến đấu / hiệu ứng / lựa chọn)
      ↓
Nhận, dùng, bỏ hoặc thay thế thẻ
      ↓
Tiếp tục cho đến khi chết, thoát, hoặc đạt điều kiện ending
```

### Di chuyển — Đã chốt

Mỗi lượt, người chơi tung **D6 di chuyển**. Sáu mặt ứng với cố định một loại phòng:

| Mặt D6 | Phòng | Màu giao diện | Vai trò |
|---:|---|---|---|
| 1 | Monster | Đỏ | Chiến đấu với quái vật. |
| 2 | Trap | Vàng | Bẫy theo khu vực và tầng. |
| 3 | Pray | Tím | Tác động đến Mind. |
| 4 | Teleport | Xanh dương | Di chuyển theo đồ thị bản đồ. |
| 5 | Event | Xanh lá | NPC, thẻ, lựa chọn hoặc phòng đặc biệt. |
| 6 | Bonfire | Cam | Dùng một kỹ năng hoặc một thẻ trong túi. |

**Mở:** D6 là xúc xắc mặc định hiện tại. Trang bị, hiệu ứng quái và Mind có thể thay đổi loại hoặc cách tung xúc xắc di chuyển sau này. Nếu thay D6 bằng xúc xắc khác, phải định nghĩa lại rõ bảng phòng để người chơi vẫn tính toán được.

---

## 5. Chiến đấu

### Luật hiện hành — Đã chốt

1. Khi gặp Monster, trận chiến diễn ra theo các lượt tung xúc xắc.
2. Người chơi tung xúc xắc của vũ khí đang trang bị.
3. Quái tung `D6 + chỉ số tấn công`.
4. So sánh tổng kết quả:
   - Người chơi cao hơn: quái mất 1 HP.
   - Quái cao hơn: người chơi mất 1 HP.
   - Hòa: không ai mất HP.
5. Lặp lại đến khi quái hết HP hoặc người chơi hết HP.
6. Người chơi hết HP: lượt chơi kết thúc.

### Nhân vật ban đầu

- Máu cơ bản: khoảng **5 HP**.
- Vũ khí khởi đầu: **Dao găm D4**.
- Về sau, chọn nhân vật sẽ quyết định chỉ số và trang bị ban đầu.

### Quái vật

Mỗi quái có hai chỉ số cố định trong dữ liệu nội dung:

- `HP`: số lần thắng lượt cần thiết để hạ quái.
- `Attack`: giá trị cộng vào D6 của quái.

Khung chỉ số:

| Tầng | HP quái | Attack quái |
|---|---:|---:|
| 1 | 1–6 | +0 đến +3 |
| 2 | 5–12 | +2 đến +6 |

> Các con số trên là khung cân bằng, không phải bắt buộc mỗi quái phải ngẫu nhiên. Phiên bản hoàn chỉnh nên để từng loại quái có HP và Attack cụ thể, nhằm giúp người chơi học và dự đoán rủi ro.

### Vũ khí và hiệu ứng — Mở rộng sau

Vũ khí quyết định xúc xắc tấn công, ví dụ:

- Dao găm: D4, một tay.
- Kiếm ngắn: D4, một tay.
- Trường thương: D12, hai tay.

Trang bị và vật phẩm có thể sửa luật: tăng sát thương, tung lại, cộng/trừ kết quả, gây debuff hoặc đổi cách xử lý khi hòa. Mọi hiệu ứng cần mô tả ngắn, rõ và không mơ hồ.

---

## 6. Thẻ bài, túi và trang bị

### Đã chốt

- Mọi vũ khí, trang bị và vật phẩm là **thẻ bài**.
- Nhân vật có **5 ô trang bị**.
- Nhân vật có **9 ô túi thẻ**.
- Thẻ nhận được từ quái, Event và các nguồn nội dung khác.
- Thẻ có thể mất khi người chơi chủ động bỏ/thay, hoặc do quái/bẫy cướp, phá hủy hay nguyền rủa.
- Nếu túi đầy, người chơi tự chọn thẻ giữ lại và thẻ bỏ đi. Không tự động xóa thẻ của người chơi.

### Nhóm thẻ

| Nhóm | Chức năng | Ví dụ thiết kế |
|---|---|---|
| Vũ khí | Quy định xúc xắc tấn công và hiệu ứng đòn đánh. | D4, D6, D12; một tay/hai tay. |
| Trang bị | Hiệu ứng bền vững khi gắn vào ô trang bị. | Kháng bẫy, thêm HP, thay đổi tung xúc xắc. |
| Vật phẩm | Dùng một lần hoặc trong điều kiện cụ thể. | Hồi máu, tung lại, mở lựa chọn Event. |
| Kỹ năng | Hành động riêng của nhân vật hoặc thẻ đặc biệt. | Dùng tại Bonfire hoặc trong trận nếu luật cho phép. |

### Thưởng khi hạ quái — Đã chốt

| Tầng | Xúc xắc thưởng | Kết quả |
|---|---|---|
| 1 | D6 | 6: vũ khí; 1–5: vật phẩm. |
| 2 | D12 | 6 hoặc 12: vũ khí; 7–11: trang bị; 1–5: vật phẩm. |

---

## 7. Sáu loại phòng

| Phòng | Trạng thái hiện tại | Hướng thiết kế |
|---|---|---|
| Monster | Đã có luật cốt lõi. | Quái theo khu vực/tầng, phần thưởng sau khi hạ. |
| Trap | Mở. | Mỗi khu có bộ bẫy riêng; có thể mất HP, Mind, thẻ hoặc vị trí. |
| Pray | Có nền tảng Mind. | Tung D12 hoặc lựa chọn nghi lễ để tăng/giảm/chuyển dạng Mind. |
| Teleport | Mở. | Cho chọn một kết nối hợp lệ trên đồ thị bản đồ. |
| Event | Mở. | NPC, nhặt thẻ, đổi thẻ, dịch chuyển đặc biệt, lựa chọn cốt truyện. |
| Bonfire | Đã có ý tưởng. | Mỗi lần vào, người chơi được dùng **một** kỹ năng hoặc vật phẩm; nội dung cụ thể tùy thẻ. |

---

## 8. Mind

Mind là cầu nối giữa hệ thống và cốt truyện. Nó không chỉ là một thanh chỉ số tốt/xấu; nó đo cách Babel đang thay đổi nhận thức nhân vật.

### Đã có

- Pray ảnh hưởng Mind.
- Mind có thể tạo buff, debuff và điều kiện ending.
- Chân dung nhân vật thay đổi theo Mind.

### Hướng triển khai

| Khoảng Mind | Biểu hiện gợi ý | Tác động có thể có |
|---|---|---|
| Cân bằng | Chân dung bình thường. | Không sửa luật. |
| Lệch dương | Màu/ánh sáng chân dung thay đổi. | Nhìn thấy dấu hiệu, mở lựa chọn đặc biệt. |
| Lệch âm | Chân dung suy sụp hoặc méo mó. | Ảo giác, lựa chọn sai lệch, hiệu ứng nguy hiểm. |
| Cực hạn | Chân dung biến dạng hoàn toàn. | Mở ending, biến đổi nhân vật hoặc mất quyền kiểm soát. |

**Mở:** cần chốt thang điểm Mind, giới hạn, mốc hiệu ứng và ý nghĩa “dương/âm” trong thế giới. Tránh để Mind chỉ là một chỉ số may rủi; người chơi cần có cách chủ động quản lý nó.

---

## 9. Giao diện và mỹ thuật

### Mục tiêu

Màn chơi phải gần như trống thông tin. Cảnh nền, quái vật và cảm giác không gian quan trọng hơn bảng chỉ số. UI chỉ xuất hiện ở rìa và trong thời điểm cần ra quyết định.

### Bố cục hiện hành

```text
┌──────────────────────────────────────────────────────┐
│                 [Thông tin trận ngắn]                 │
│                                                      │
│              Cảnh nền / quái vật trung tâm           │
│                                                      │
│  [Nút D6]                                            │
│  Di chuyển / hành động                               │
│                                                      │
│  [Chân dung tròn]                                    │
│  Mind                                                 │
│  ███████████  HP                                     │
└──────────────────────────────────────────────────────┘
```

### Quy tắc UI

- Góc dưới trái: chân dung nhân vật hình tròn, Mind và thanh HP.
- Cạnh trái: nút tròn chính cho di chuyển/hành động; màu theo loại phòng hiện tại.
- Trung tâm: chỉ hiện quái khi ở Monster. Không để bảng túi, nhật ký hay danh sách phòng thường trực.
- Đầu màn hình: panel nhỏ chỉ hiện trong chiến đấu, chứa tên quái, HP và kết quả lượt gần nhất.
- Túi thẻ, trang bị, lựa chọn bỏ thẻ: mở thành panel riêng khi người chơi cần tương tác.

### Asset hiện có

| File | Mục đích |
|---|---|
| `image/avatar.jpg` | Chân dung người chơi. |
| `image/monster.jpg` | Nền phòng Monster. |
| `image/monster-d1.png` | Quái hiển thị trong phòng Monster. |
| `image/trap.jpg` | Nền phòng Trap. |
| `image/pray.jpg` | Nền phòng Pray. |
| `image/teleport.jpg` | Nền phòng Teleport. |
| `image/event.jpg` | Nền phòng Event. |
| `image/bonfire.jpg` | Nền phòng Bonfire. |

Asset bổ sung ưu tiên sau: biến thể chân dung theo Mind, quái riêng cho từng tầng/khu vực, nền riêng cho các khu vực sâu hơn, khung thẻ và biểu tượng trang bị.

---

## 10. Nhân vật người chơi và ending

### Nhân vật — Mở

Chọn nhân vật ban đầu sẽ quyết định ít nhất:

- Máu hoặc chỉ số nền.
- Vũ khí và trang bị khởi đầu.
- Kỹ năng riêng.
- Mục tiêu cá nhân khi tiến vào Babel.
- Các Event, NPC, thẻ hoặc ending có thể gặp.

Mỗi nhân vật phải có một hy vọng cụ thể nhưng không được bảo đảm sẽ thành hiện thực. Câu chuyện của họ nằm trong hành trình bị Babel thử thách, làm sai lệch hoặc nghiền nát hy vọng đó.

### Ending — Khung

Ending không cần quyết định ngay, nhưng mọi hệ thống nên lưu đủ trạng thái cho nó. Các điều kiện có thể gồm:

- Tầng/khu vực sâu nhất đã đến.
- Mind cuối lượt và các mốc Mind từng đạt.
- Những giáo phái, NPC hoặc nghi thức đã can thiệp.
- Thẻ, lời thề, vật hiến tế và quyết định Event quan trọng.
- Nhân vật đã giữ, từ bỏ hoặc bóp méo mục tiêu ban đầu như thế nào.

---

## 11. Kiến trúc nội dung đề xuất

Khi code mở rộng, tách **luật hệ thống** ra khỏi **dữ liệu nội dung**. Không ghi chỉ số quái, tên thẻ hay phần thưởng trực tiếp trong giao diện.

### Dữ liệu nên có

| Loại dữ liệu | Trường tối thiểu |
|---|---|
| Character | id, tên, max_hp, vũ khí ban đầu, trang bị, kỹ năng, mục tiêu, portrait variants. |
| Enemy | id, tên, khu vực, tầng, hp, attack, ảnh, reward pool, hành vi đặc biệt. |
| Card | id, tên, loại, mô tả, điều kiện dùng, hiệu ứng, ảnh, độ hiếm. |
| Room | loại phòng, khu vực, tầng, nền, bảng nội dung/hiệu ứng. |
| Trap | id, khu vực, tầng, mô tả, cách tránh, hậu quả. |
| Event | id, điều kiện xuất hiện, lựa chọn, kết quả, cờ cốt truyện. |
| Ending | id, điều kiện, nội dung, phần thưởng/mở khóa nếu có. |

Trong Godot, các dữ liệu này có thể bắt đầu bằng `Resource` hoặc JSON. Khi dữ liệu lớn dần, Resource có lợi thế chỉnh sửa trực tiếp trong Inspector.

---

## 12. Phạm vi phát triển

### Demo hiện tại

- UI tối giản với nền phòng, chân dung, HP, Mind và nút tròn đổi màu.
- Tung D6 để chọn một trong sáu loại phòng.
- Monster dùng nền `monster.jpg` và quái `monster-d1.png`.
- Chiến đấu: dao găm D4 so với D6 + Attack của quái.
- Thắng gây 1 HP; thua mất 1 HP; hòa không đổi HP.
- Pray thay đổi Mind ở mức demo.
- Bonfire hồi 1 HP ở mức demo.

### Mốc phát triển gần nhất

1. Chốt 6 quái tầng 1 và dữ liệu chỉ số riêng cho chúng.
2. Hoàn thiện Trap, Pray, Teleport, Event theo dữ liệu thay vì mô tả tạm.
3. Làm túi 9 thẻ, 5 ô trang bị và giao diện thay thế thẻ khi túi đầy.
4. Làm các loại vũ khí và hiệu ứng thẻ đầu tiên.
5. Thêm khu vực/tầng, quái tầng 2 và bảng phần thưởng hoàn chỉnh.
6. Chốt nhân vật đầu tiên, chuỗi Event cá nhân và ending thử nghiệm.

---

## 13. Nguyên tắc khi thêm nội dung

- Mọi cơ chế mới phải trả lời: người chơi biết rủi ro này bằng cách nào, và có công cụ nào để tác động vào nó?
- Một thẻ mạnh phải có giới hạn, điều kiện hoặc đánh đổi rõ ràng.
- Một quái đáng nhớ cần hơn chỉ số: ít nhất một hành vi, hiệu ứng hoặc liên hệ với khu vực.
- Event cần có hậu quả bền vững hoặc thông tin có giá trị; tránh lựa chọn chỉ khác văn bản.
- Không đưa quá nhiều chữ lên màn chơi. Lịch sử, mô tả đầy đủ và số liệu chi tiết chỉ mở khi người chơi yêu cầu.
- Nếu một luật mới mâu thuẫn tài liệu này, sửa tài liệu cùng lúc với code và ghi lý do trong phần dưới.

---

## 14. Nhật ký quyết định

| Ngày | Quyết định | Lý do |
|---|---|---|
| 2026-11-18 | D6 di chuyển có sáu mặt ứng với sáu loại phòng cố định. | Vòng chơi dễ đọc, vẫn giữ biến số xúc xắc. |
| 2026-11-18 | Người chơi bắt đầu bằng dao găm D4 và khoảng 5 HP. | Làm rõ bất lợi ban đầu và giá trị của trang bị. |
| 2026-11-18 | Hòa trong chiến đấu không gây sát thương. | Giữ luật so xúc xắc trực quan. |
| 2026-11-18 | Babel là hố sâu được gọi là tháp; “đi lên” nghĩa là đi sâu hơn. | Làm nghịch lý trung tâm cho bối cảnh và tiến trình. |
| 2026-11-18 | Ba giáo phái không hứa hẹn cứu rỗi. | Hy vọng là động cơ tự thân của nhân vật người chơi. |
