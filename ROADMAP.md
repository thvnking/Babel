# BABEL — Định hướng phát triển và danh sách công việc

Tài liệu này là roadmap thực hiện dự án. Dùng nó để biết game đang ở đâu, việc tiếp theo là gì và khi nào một phần có thể xem là hoàn thành.

Tài liệu thiết kế hệ thống và cốt truyện nằm ở [GAME_DESIGN.md](GAME_DESIGN.md).

## Quy ước trạng thái

- `[x]` Đã hoàn thành và có trong project.
- `[-]` Đã có nền tảng hoặc bản thử, chưa hoàn thiện.
- `[ ]` Chưa bắt đầu.
- `[?]` Cần chốt thiết kế trước khi code.

---

## Mục tiêu phiên bản đầu tiên

Một người chơi có thể chọn nhân vật, tiến qua một khu vực/tầng, tung xúc xắc để vào phòng, chiến đấu, quản lý thẻ, sống sót hoặc chết, rồi nhận một kết quả kết thúc ngắn có ý nghĩa.

Phiên bản đầu không cần đủ sáu tầng, toàn bộ cốt truyện hay nhiều nhân vật. Nó cần chứng minh rằng vòng **di chuyển → rủi ro → chiến đấu/lựa chọn → nhận thẻ → tiếp tục** có chiều sâu và muốn chơi lại.

---

## Giai đoạn 0 — Nền project và giao diện thử nghiệm

- [x] Tạo project Godot 4.
- [x] Tạo scene chính và script điều khiển prototype.
- [x] Nạp asset nền cho sáu loại phòng.
- [x] Nạp avatar người chơi và quái `monster-d1`.
- [x] Prototype có nền phòng, quái, portrait, HP/Mind và nút hành động.
- [x] Màu nút hành động thay đổi theo loại phòng.
- [x] Loại bỏ bảng nhật ký, túi thẻ và các thông tin thường trực khỏi màn hình chính.
- [-] Kiểm tra trực quan trên nhiều độ phân giải cửa sổ.
- [ ] Tạo cài đặt âm lượng, toàn màn hình và thoát game.

**Hoàn thành giai đoạn khi:** giao diện hiển thị ổn định ở độ phân giải mục tiêu và không che mất hành động quan trọng.

---

## Giai đoạn 1 — Vòng chơi cơ bản

- [x] Tung D6 di chuyển.
- [x] Sáu mặt D6 dẫn tới Monster, Trap, Pray, Teleport, Event, Bonfire.
- [x] Thay nền theo phòng được tung.
- [x] Monster mở trạng thái chiến đấu.
- [x] Bonfire bản thử hồi 1 HP.
- [-] Pray thay đổi Mind ở mức demo.
- [ ] Trap có hiệu ứng thật theo dữ liệu.
- [ ] Teleport cho người chơi chọn điểm đến hợp lệ.
- [ ] Event có ít nhất ba tình huống thật và hậu quả.
- [ ] Bonfire cho chọn đúng một kỹ năng hoặc một thẻ, thay vì chỉ hồi HP.
- [ ] Lượt chơi có trạng thái rõ ràng: đang di chuyển, giải quyết phòng, chiến đấu, chọn thẻ, kết thúc.

**Hoàn thành giai đoạn khi:** cả sáu loại phòng đều có tác động thật, người chơi không gặp ngõ cụt về luật hoặc giao diện.

---

## Giai đoạn 2 — Chiến đấu và quái vật

- [x] Người chơi bắt đầu bằng dao găm D4.
- [x] Quái tung D6 cộng Attack.
- [x] Thắng lượt gây 1 HP; thua lượt mất 1 HP; hòa không ai mất HP.
- [x] Người chơi chết khi HP về 0; có thể chơi lại.
- [-] Quái xuất hiện ngẫu nhiên trong khung chỉ số tầng 1.
- [ ] Chốt sáu quái đặc trưng tầng 1 với HP, Attack và hành vi riêng.
- [ ] Làm dữ liệu quái riêng thay cho chỉ số sinh ngẫu nhiên trong code giao diện.
- [ ] Thêm sáu quái đặc trưng tầng 2.
- [ ] Mỗi quái có ảnh hoặc biến thể hình ảnh riêng.
- [ ] Tạo hiệu ứng trực quan ngắn khi thắng, thua, hòa, mất HP và quái chết.
- [ ] Làm rõ tiến triển trận đấu bằng phản hồi hình ảnh; không thêm bảng chỉ số/HP quái lên HUD chiến đấu.
- [ ] Thêm ít nhất hai hiệu ứng quái: độc, cướp thẻ, giảm xúc xắc, giáp hoặc phản đòn.

**Hoàn thành giai đoạn khi:** sáu quái tầng 1 có bản sắc cơ chế, người chơi có thể học cách đối phó thay vì chỉ mong may mắn.

---

## Giai đoạn 3 — Thẻ bài, túi và trang bị

- [x] Đã chốt 9 ô túi thẻ và 5 ô trang bị trong thiết kế.
- [x] Đã chốt phần thưởng từ quái theo tầng trong thiết kế.
- [ ] Tạo dữ liệu Card dùng chung cho vũ khí, trang bị, vật phẩm và kỹ năng.
- [ ] Làm giao diện mở túi thẻ theo yêu cầu của người chơi.
- [ ] Làm 9 ô túi thẻ và 5 ô trang bị.
- [ ] Khi túi đầy, hiện màn hình chọn thẻ giữ lại hoặc bỏ đi.
- [ ] Làm bảng thưởng sau khi hạ quái.
- [ ] Thưởng tầng 1: D6, 6 là vũ khí; 1–5 là vật phẩm.
- [ ] Thưởng tầng 2: D12, 1–5 vật phẩm; 6/12 vũ khí; 7–11 trang bị.
- [ ] Làm ít nhất 3 vũ khí, 5 vật phẩm và 5 trang bị cho bản đầu.
- [ ] Làm ít nhất một hiệu ứng thay đổi xúc xắc, một hiệu ứng tung lại và một hiệu ứng sửa sát thương.
- [ ] Làm luật một tay/hai tay nếu hệ trang bị cần sử dụng.

**Hoàn thành giai đoạn khi:** người chơi thường xuyên có quyết định giữ, bỏ, trang bị hoặc dùng thẻ và các quyết định đó ảnh hưởng đáng kể tới chiến đấu.

---

## Giai đoạn 4 — Mind, bẫy và lựa chọn

- [x] Mind có phản hồi hình ảnh ở prototype; bản thiết kế cuối truyền đạt Mind qua portrait, không dùng số/thanh HUD.
- [x] Mind thay đổi tông màu chân dung ở mức demo.
- [?] Chốt thang Mind: giới hạn, giá trị khởi đầu và ý nghĩa cực dương/cực âm.
- [ ] Tạo các mốc Mind có buff/debuff rõ ràng.
- [ ] Thêm chân dung hoặc hiệu ứng chân dung cho từng trạng thái Mind.
- [ ] Tạo bộ bẫy khu vực A, tối thiểu 4 bẫy.
- [ ] Mỗi bẫy có cách nhận biết hoặc cách giảm rủi ro.
- [ ] Tạo bảng Pray D12 và hiệu ứng Mind tương ứng.
- [ ] Tạo Event có lựa chọn, điều kiện, hậu quả và cờ cốt truyện.
- [ ] Lưu các cờ quan trọng để dùng cho ending.

**Hoàn thành giai đoạn khi:** Mind, bẫy và Event tạo lựa chọn dài hạn, không chỉ tăng/giảm chỉ số ngẫu nhiên.

---

## Giai đoạn 5 — Bản đồ, khu vực và tiến trình

- [x] Chốt bản đồ gồm A/B/C, mỗi khu hai tầng.
- [x] Chốt quy tắc đi ngang cùng tầng và đi sâu theo cùng khu vực.
- [ ] Làm màn hình hoặc panel bản đồ.
- [ ] Làm Teleport sử dụng đúng đồ thị `1A–1B–1C`, `2A–2B–2C`, cùng các kết nối dọc.
- [ ] Tạo dữ liệu nội dung cho khu A tầng 1.
- [ ] Tạo dữ liệu nội dung cho khu B tầng 1.
- [ ] Tạo dữ liệu nội dung cho khu C tầng 1.
- [ ] Tạo phiên bản biến đổi của ba khu ở tầng 2.
- [ ] Tạo nền, quái, bẫy và Event riêng cho từng khu/tầng.
- [ ] Chốt điều kiện chuyển tầng và điều kiện thoát/chạm ending thử nghiệm.

**Hoàn thành giai đoạn khi:** người chơi có thể đi qua ít nhất ba khu liên kết và cảm nhận rõ mỗi khu có bản sắc riêng.

---

## Giai đoạn 6 — Nhân vật, cốt truyện và ending

- [x] Chốt tiền đề: Babel là hố sâu được gọi là tháp.
- [x] Chốt ba thế lực tôn giáo là thế lực khai thác Babel, không phải phe ban điều ước.
- [x] Chốt động cơ nhân vật là hy vọng cá nhân, có thể là hão huyền.
- [?] Chốt bí mật trung tâm dưới đáy Babel.
- [ ] Thiết kế nhân vật người chơi đầu tiên: chỉ số, trang bị, kỹ năng, mục tiêu và chân dung.
- [ ] Thiết kế hai nhân vật bổ sung với lối chơi khác nhau.
- [ ] Viết Event mở đầu và lý do từng nhân vật vào Babel.
- [ ] Viết NPC và Event cho từng khu vực.
- [ ] Định nghĩa các cờ cốt truyện phục vụ ending.
- [ ] Tạo ít nhất 3 ending thử nghiệm: thất bại, thỏa hiệp/biến đổi và khám phá sâu hơn.
- [ ] Viết màn hình kết thúc và khả năng xem lại những điều kiện đã đạt.

**Hoàn thành giai đoạn khi:** một lượt chơi hoàn chỉnh có mở đầu, lựa chọn mang hậu quả và ít nhất ba kết thúc khác nhau.

---

## Giai đoạn 7 — Cân bằng, âm thanh và hoàn thiện

- [ ] Tạo công cụ hoặc chế độ debug để kiểm tra tung xúc xắc, phần thưởng và Event.
- [ ] Chơi thử tối thiểu 20 lượt với dữ liệu ghi lại.
- [ ] Điều chỉnh HP, Attack, tỉ lệ thưởng và độ khó tầng theo dữ liệu chơi thử.
- [ ] Thêm âm thanh cho xúc xắc, trúng đòn, mất HP, UI và môi trường.
- [ ] Thêm nhạc nền hoặc ambient cho từng khu vực.
- [ ] Thêm chuyển cảnh, hiệu ứng hạt và rung nhẹ khi phù hợp.
- [ ] Kiểm tra đầy túi, chết giữa Event, đổi tầng, thoát game và chơi lại.
- [ ] Kiểm tra lưu/tải lượt chơi.
- [ ] Tạo bản build thử nghiệm cho Windows.

**Hoàn thành giai đoạn khi:** không có lỗi chặn lượt chơi; một người chưa biết dự án có thể chơi, hiểu vòng chính và gửi phản hồi.

---

## Thứ tự ưu tiên hiện tại

1. **Hoàn thiện sáu loại phòng cho khu A, tầng 1.**
2. **Làm dữ liệu quái, thẻ, bẫy và Event tách khỏi giao diện.**
3. **Làm túi thẻ, trang bị và lựa chọn khi túi đầy.**
4. **Thêm nhân vật đầu tiên cùng mục tiêu cá nhân.**
5. **Dựng một lượt chơi hoàn chỉnh có ending thử nghiệm.**

## Cách cập nhật roadmap

- Khi một mục đã xuất hiện trong game và có thể chơi được: đổi thành `[x]`.
- Khi mới có bản thử hoặc placeholder: dùng `[-]`.
- Khi một quyết định sẽ ảnh hưởng nhiều hệ thống: dùng `[?]` và chốt nó trong `GAME_DESIGN.md` trước.
- Không đánh dấu hoàn thành chỉ vì code đã tồn tại; mục chỉ hoàn thành khi người chơi có thể dùng và hiểu nó.
