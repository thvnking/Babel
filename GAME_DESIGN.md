# BABEL — Thiết kế trò chơi

**Mục đích:** Tài liệu chuẩn cho vòng chơi, luật hệ thống và nội dung cốt truyện. Hướng mỹ thuật, UI và trình bày thế giới nằm trong [BABEL_VISUAL_DESIGN_BIBLE.md](BABEL_VISUAL_DESIGN_BIBLE.md); trạng thái và thứ tự công việc nằm trong [ROADMAP.md](ROADMAP.md).

## 1. Bản sắc và trải nghiệm

BABEL là game hầm ngục 2D dark fantasy, chiến thuật theo lượt, kết hợp xúc xắc và thẻ bài. Người chơi tiến vào một hố sâu vô tận được gọi là tháp. Càng đi lên tầng, họ càng xuống sâu gần nguồn hỗn mang bên dưới. Mỗi nhân vật bước vào Babel vì hy vọng riêng; không giáo phái nào hứa hẹn cứu rỗi.

BABEL được định hướng là game 18+. Nội dung có thể khai thác hình ảnh tình dục trưởng thành, khỏa thân, bạo lực và gore để phục vụ chủ đề, cốt truyện và không khí của thế giới. Mọi nhân vật trong ngữ cảnh tình dục phải được thể hiện rõ là người trưởng thành.

Trải nghiệm cốt lõi:

- Cân nhắc rủi ro bằng thông tin về luật, HP, xúc xắc và trang bị.
- Chấp nhận bất định từ xúc xắc nhưng hiểu nguyên nhân của kết quả.
- Quản lý vũ khí, trang bị và vật phẩm dưới dạng thẻ có thể nhận, dùng, mất hoặc thay thế.
- Sống sót nhờ lựa chọn, dù thế giới tàn nhẫn và không công bằng.
- Khám phá cốt truyện qua phòng, NPC, quái vật, vật phẩm, thẻ và biến đổi Mind.

## 2. Thế giới

Ba thế lực tôn giáo hư cấu công khai đối đầu nhưng đều khai thác Babel để lấy năng lượng phục vụ nghi thức và phép màu. Họ là các tổ chức quyền lực, không phải phe thiện hay nguồn ban điều ước.

| Vùng | Giáo phái | Chủ đề |
|---|---|---|
| A | Dục Đạo Giáo | Ham muốn, dục vọng, cám dỗ và khoái lạc suy đồi. |
| B | Hỏa Ngục Giáo | Bạo lực, trừng phạt, đau khổ và Địa Ngục như Thiên Đường. |
| C | Đà La Môn | Tham lam, chiếm hữu mọi thứ, hoàn mỹ áp đặt và thao túng thực tại. |

Babel làm méo mó sinh vật, nghi lễ, ký ức và lý trí. Cốt truyện được truyền tải qua trải nghiệm; không cần một nhân vật giải thích toàn bộ bí mật. Ending phụ thuộc vào hành động, trạng thái và những gì nhân vật đã đánh đổi.

## 3. Bản đồ và tiến trình

Thế giới có ba vùng A/B/C, mỗi vùng có hai tầng. Tầng 2 nguy hiểm hơn và thể hiện sự biến đổi sâu hơn của Babel. Floor 2 là phiên bản dị giáo của Floor 1: giữ motif nhận diện, remix bố cục và biến đổi cực đoan theo bản sắc riêng của vùng.

Vị trí được viết là tầng cộng vùng, ví dụ `1A` hoặc `2C`. Kết nối hợp lệ:

- Tầng 1 cho phép di chuyển ngang giữa các vùng liền kề: `1A ↔ 1B ↔ 1C`.
- Có thể đi giữa hai tầng cùng vùng: `1A ↔ 2A`, `1B ↔ 2B`, `1C ↔ 2C`.
- Tầng 2 không có di chuyển ngang giữa các vùng.
- Không thể đi chéo tầng và vùng, ví dụ `1A → 2C`.

Phòng Teleport dùng đúng đồ thị này.

## 4. Vòng chơi và di chuyển

Vòng chơi: chuẩn bị nhân vật → tung xúc xắc di chuyển → xác định phòng → giải quyết chiến đấu/hiệu ứng/lựa chọn → nhận, dùng, bỏ hoặc thay thẻ → tiếp tục cho đến khi chết, thoát hoặc đạt ending.

Mỗi lượt, người chơi tung D6 di chuyển. Mỗi mặt ứng với một loại phòng cố định:

| Mặt | Phòng | Màu gợi ý | Vai trò |
|---:|---|---|---|
| 1 | Monster | Đỏ | Chiến đấu và nhận thưởng nếu thắng. |
| 2 | Trap | Vàng | Bẫy theo vùng/tầng. |
| 3 | Pray | Tím | Tác động đến Mind. |
| 4 | Teleport | Xanh dương | Di chuyển trên bản đồ. |
| 5 | Event | Xanh lá | NPC, thẻ, lựa chọn hoặc tình huống đặc biệt. |
| 6 | Bonfire | Cam | Dùng một kỹ năng hoặc một thẻ trong túi. |

Các màu là mã nhận diện hiện dùng; ngôn ngữ hình ảnh chi tiết theo [visual bible](BABEL_VISUAL_DESIGN_BIBLE.md). Nếu nội dung tương lai thay đổi xúc xắc di chuyển, bảng phòng phải tiếp tục cho phép người chơi hiểu và cân nhắc kết quả.

## 5. Chiến đấu

1. Trong phòng Monster, chiến đấu diễn ra theo các lượt xúc xắc.
2. Người chơi tung xúc xắc của vũ khí đang trang bị.
3. Quái tung xúc xắc theo dữ liệu riêng cộng `Attack`; Chuột Hang hiện dùng D2.
4. So sánh tổng: người chơi cao hơn thì quái mất 1 HP; quái cao hơn thì người chơi mất 1 HP; hòa thì không ai mất HP.
5. Lặp lại đến khi quái hoặc người chơi hết HP. Người chơi hết HP thì lượt chơi kết thúc.

Nhân vật demo bắt đầu khoảng 5 HP và dao găm D4. Đây là giá trị khởi đầu của prototype; khi có nhân vật chọn được, chỉ số và trang bị ban đầu thuộc dữ liệu nhân vật.

Mỗi quái có HP, Attack và hành vi riêng trong dữ liệu. Khung cân bằng hiện dùng: tầng 1 có HP 1–6, Attack +0 đến +3; tầng 2 có HP 5–12, Attack +2 đến +6. Đây là khoảng thiết kế, không phải chỉ số ngẫu nhiên bắt buộc.

Trong chiến đấu, UI không hiển thị bảng chỉ số hay HP quái. Quái được thể hiện bằng hình ảnh và phản hồi đòn đánh; kiến thức mở khóa được ghi trong Dictionary theo quy tắc của visual bible.

## 6. Thẻ, túi và trang bị

Vũ khí, trang bị và vật phẩm đều tồn tại dưới dạng thẻ.

- Túi có 4 ô; có thêm một ô vũ khí riêng và trang bị nhân vật hiển thị cạnh hình toàn thân.
- Thẻ đến từ quái, Event và các nguồn nội dung khác.
- Thẻ có thể bị dùng, bỏ, thay thế, cướp, phá hủy hoặc nguyền rủa theo hiệu ứng.
- Khi túi đầy, người chơi tự chọn thẻ giữ và thẻ bỏ; không tự động xóa thẻ.

| Nhóm | Chức năng |
|---|---|
| Vũ khí | Chọn xúc xắc tấn công và có thể thêm hiệu ứng đòn đánh. |
| Trang bị | Tạo hiệu ứng bền vững khi được gắn. |
| Vật phẩm | Dùng một lần hoặc theo điều kiện cụ thể. |
| Kỹ năng | Hành động riêng của nhân vật hoặc thẻ đặc biệt. |

Thưởng khi hạ quái:

| Tầng | Xúc xắc | Kết quả |
|---|---|---|
| 1 | D6 | 6: vũ khí; 1–5: vật phẩm. |
| 2 | D12 | 6 hoặc 12: vũ khí; 7–11: trang bị; 1–5: vật phẩm. |

## 7. Sáu loại phòng

| Phòng | Vai trò gameplay |
|---|---|
| Monster | Chiến đấu với quái đặc trưng theo vùng/tầng; thắng có thưởng. |
| Trap | Bẫy có thể ảnh hưởng HP, Mind, thẻ hoặc vị trí; nội dung thay đổi theo vùng. |
| Pray | Nghi lễ tác động Mind. |
| Teleport | Chọn một điểm đến có kết nối hợp lệ. |
| Event | Gặp NPC, nhận/đổi thẻ, dịch chuyển đặc biệt hoặc đưa ra lựa chọn cốt truyện. |
| Bonfire | Mỗi lần vào cho dùng một kỹ năng hoặc một thẻ. |

## 8. Mind

Mind biểu đạt cách Babel biến đổi nhận thức nhân vật và kết nối cơ chế với cốt truyện. Trong prototype hiện tại, Mind bắt đầu ở 0, giới hạn từ −5 đến +5 và được biểu diễn trực quan bằng thang 11 nấc quanh mốc 0, kèm giá trị hiện tại. HP được biểu diễn bằng thanh có số hiện tại/tối đa; mọi thay đổi bị giới hạn trong khoảng hợp lệ. Đây là quyết định UI/gameplay mới thay cho quy tắc HUD cũ trong visual bible.

Phòng Pray yêu cầu người chơi chủ động tung D6. Kết quả lần lượt là: 1: −1 HP, −1 Mind; 2: −1 Mind; 3: không đổi; 4: +1 Mind; 5: +1 HP; 6: +1 HP, +1 Mind. HP luôn nằm trong [0, HP tối đa], Mind trong [−5, +5]; HP về 0 kết thúc lượt chơi.

Region A chủ động tác động Mind; mục tiêu chủ đề của vùng là đưa Mind về 0 và cuốn người chơi vào khoái lạc cực độ. Cơ chế cụ thể để đạt điều đó phải được định nghĩa cùng nội dung gameplay. Mind của Region B và C không có hiệu ứng đặc thù được quy định ở tài liệu này.

## 9. Nhân vật, lore và ending

Người chơi có thể chọn nhân vật. Mỗi nhân vật xác định ít nhất HP/chỉ số nền, trang bị ban đầu, kỹ năng riêng và hy vọng cá nhân. Babel có thể thử thách, bóp méo hoặc nghiền nát hy vọng đó. Câu chuyện được kể qua Event, NPC, thẻ và quyết định trong hành trình.

Ending có thể xét tầng sâu nhất đã đến, trạng thái Mind, giáo phái/nghi thức đã gặp, các lựa chọn để lại hậu quả và những gì nhân vật đã đánh đổi. Bí mật trung tâm của Babel cùng danh sách nhân vật và ending hoàn chỉnh sẽ được phát triển thành nội dung.

## 10. Dữ liệu nội dung

Tách luật hệ thống khỏi dữ liệu cốt truyện và cân bằng. Trong Godot, có thể bắt đầu với `Resource` hoặc JSON, tùy cấu trúc phù hợp với project.

| Loại | Dữ liệu chính |
|---|---|
| Character | id, tên, HP, trang bị, kỹ năng, mục tiêu và portrait. |
| Enemy | id, vùng, tầng, HP, Attack, hành vi, hình ảnh và phần thưởng. |
| Card | id, nhóm, mô tả, điều kiện, hiệu ứng, hình ảnh và độ hiếm. |
| Room | loại, vùng, tầng, nền và nội dung/hiệu ứng. |
| Trap/Event | id, điều kiện, lựa chọn, hậu quả và cờ cốt truyện. |
| Ending | id, điều kiện và nội dung. |

## 11. Phạm vi prototype

Prototype hiện tại minh họa vòng chơi cơ bản với nền phòng, avatar, HP/Mind, nút hành động, D6 chọn một trong sáu phòng, chiến đấu bằng dao găm D4 so với xúc xắc riêng của quái cộng Attack (Chuột Hang: D2, 2 HP), thắng gây 1 sát thương, hòa không gây sát thương, Pray dùng D6 để đổi HP/Mind và Bonfire hồi 1 HP. Đây là hành vi demo, không thay cho luật hoàn chỉnh ở trên.

Menu prototype có trang Settings (âm lượng chung, toàn màn hình, khôi phục mặc định), Credits, popup xác nhận/thông báo và một ô lưu cục bộ. Trong game, ESC hoặc nút Tạm dừng mở menu lưu thủ công, cài đặt, tiếp tục, về menu và thoát; Ctrl+S lưu nhanh. Tiếp tục/Tải hành trình khôi phục các trạng thái chơi hiện có trong prototype.

Kế hoạch triển khai nằm trong [ROADMAP.md](ROADMAP.md).

## 12. Nguyên tắc thiết kế

- Mỗi rủi ro phải dễ hiểu và người chơi cần có cách tác động đến nó.
- Thẻ mạnh cần có điều kiện, giới hạn hoặc cái giá rõ ràng.
- Quái vật đáng nhớ cần có hành vi, hiệu ứng hoặc liên hệ với vùng ngoài chỉ số.
- Event cần để lại hậu quả hoặc thông tin có giá trị.
- Màn chơi hạn chế chữ; thông tin chi tiết và lore được xem khi người chơi yêu cầu.
- Khi luật thay đổi, cập nhật tài liệu này và mục công việc tương ứng trong roadmap.
