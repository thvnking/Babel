# Chỗ nhận ảnh mới

Đặt ảnh ComfyUI mới vào thư mục này. Dùng đúng tên asset bên dưới để mình nhận diện và tích hợp mà không cần mở từng ảnh. Nếu asset chưa có tên trong danh sách, ghi tên loại asset vào tên file hoặc nhắn kèm mô tả.

## Asset menu

| Tên file cần đặt | Dùng cho | Kích thước / định dạng gợi ý |
|---|---|---|
| `menu_background.png` | Nền menu chính | 16:9, 1344×768 hoặc 1920×1080, PNG/JPG |
| `menu_panel_frame.png` | Khung panel menu | Vuông, 1024×1024, PNG nền trong suốt nếu tạo được |
| `menu_button_frame.png` | Khung nút menu | Ngang 4:1, 1024×256, PNG nền trong suốt nếu tạo được |

## Quy ước đặt tên cho ảnh gameplay

- Phòng: `room_monster.png`, `room_trap.png`, `room_pray.png`, `room_teleport.png`, `room_event.png`, `room_bonfire.png` → `image/rooms/`.
- Nhân vật: `player_avatar.png`, `player_portrait_mind_01.png`… → `image/characters/`.
- Quái: `monster_<ten>.png` → `image/enemies/`.
- UI dùng chung: `ui_<ten>.png`; ảnh menu dùng các tên `menu_*` ở trên → `image/ui/`.
- Card/item: `card_<ten>.png` hoặc `item_<ten>.png` → `image/cards/`.

Giữ phần tên sau tiền tố ổn định giữa prompt và file ảnh. Nên xuất PNG; dùng PNG trong suốt cho khung/viền cần alpha.
