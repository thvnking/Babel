extends Control

# Giao diện prototype tối giản: thông tin chỉ hiện khi cần trong chiến đấu.
const ROOM_NAMES := ["Quái vật", "Bẫy", "Cầu nguyện", "Dịch chuyển", "Sự kiện", "Lửa trại"]
const ROOM_COLORS := [Color("#b6313b"), Color("#d59a25"), Color("#8752b7"), Color("#2879a5"), Color("#4d9871"), Color("#d36a32")]
const ROOM_BACKGROUNDS := ["res://image/rooms/room_monster.jpg", "res://image/rooms/room_trap.jpg", "res://image/rooms/room_pray.jpg", "res://image/rooms/room_teleport.jpg", "res://image/rooms/room_event.jpg", "res://image/rooms/room_bonfire.jpg"]
const SAVE_PATH := "user://babel_save.json"
const SETTINGS_PATH := "user://babel_settings.cfg"
const MENU_SCENE := "res://Main.tscn"
const MENU_PANEL_FRAME := "res://image/ui/menu/menu_panel_frame.png"
const MENU_BUTTON_FRAME := "res://image/ui/menu/menu_button_frame.png"
const ENEMIES := [{"name": "Chuột Hang", "hp": 2, "attack": 0, "die": 2}, {"name": "Nhện Đá", "hp": 3, "attack": 1, "die": 6}, {"name": "Kẻ Đào Mộ", "hp": 4, "attack": 1, "die": 6}, {"name": "Quỷ Lùn", "hp": 5, "attack": 2, "die": 6}, {"name": "Hiệp Sĩ Rỗng", "hp": 6, "attack": 3, "die": 6}, {"name": "Quái Vật Tổ", "hp": 6, "attack": 3, "die": 6}]

var rng := RandomNumberGenerator.new()
var player_hp := 5
var max_player_hp := 5
var mind := 0
const MAX_MIND := 5
var weapon_die := 4
var current_room := -1
var current_enemy: Dictionary = {}
var enemy_hp := 0
var combat_active := false
var bonfire_used := false
var prayer_pending := false
var run_over := false

var background: TextureRect
var enemy_sprite: TextureRect
var avatar: TextureRect
var hp_fill: ProgressBar
var mind_ring: Label
var move_button: Button
var move_label: Label
var room_hint: Label
var combat_panel: PanelContainer
var combat_text: Label
var roll_text: Label
var hp_text: Label
var mind_text: Label
var mind_markers: Array[Label] = []
var inventory_layer: Control
var inventory_button: Button
var pause_button: Button
var pause_layer: Control
var pause_status: Label
var pause_panel_column: VBoxContainer
var pause_subpage := "menu"


func _ready() -> void:
	rng.randomize()
	_build_ui()
	if get_tree().has_meta("load_saved_run") and bool(get_tree().get_meta("load_saved_run")):
		_restore_run()
	else:
		_show_idle_state()
	if get_tree().has_meta("load_saved_run"):
		get_tree().remove_meta("load_saved_run")


func _build_ui() -> void:
	background = TextureRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.modulate = Color(0.62, 0.62, 0.68, 1.0)
	add_child(background)
	var veil := ColorRect.new()
	veil.color = Color(0.02, 0.03, 0.06, 0.34)
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(veil)

	enemy_sprite = TextureRect.new()
	enemy_sprite.texture = load("res://image/enemies/monster_d1.png")
	enemy_sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	enemy_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	enemy_sprite.set_anchors_preset(Control.PRESET_CENTER)
	enemy_sprite.position = Vector2(-220, -210)
	enemy_sprite.size = Vector2(440, 440)
	enemy_sprite.visible = false
	enemy_sprite.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(enemy_sprite)

	combat_panel = PanelContainer.new()
	combat_panel.set_anchors_preset(Control.PRESET_CENTER_TOP)
	combat_panel.position = Vector2(-170, 26)
	combat_panel.size = Vector2(340, 94)
	combat_panel.add_theme_stylebox_override("panel", _stylebox(Color("#111521d9"), Color("#9d2934"), 2, 16))
	combat_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(combat_panel)
	var combat_column := VBoxContainer.new()
	combat_column.alignment = BoxContainer.ALIGNMENT_CENTER
	combat_column.add_theme_constant_override("separation", 3)
	combat_panel.add_child(combat_column)
	combat_text = _label("", 19, "#fff3d7")
	combat_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	combat_column.add_child(combat_text)
	roll_text = _label("", 14, "#d6ddec")
	roll_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	combat_column.add_child(roll_text)

	room_hint = _label("", 14, "#f1e4c8")
	room_hint.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	room_hint.position = Vector2(-240, -66)
	room_hint.size = Vector2(480, 28)
	room_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	room_hint.add_theme_stylebox_override("normal", _stylebox(Color("#10141bbe"), Color("#00000000"), 0, 12))
	add_child(room_hint)
	_build_player_portrait()
	_build_move_button()
	_build_inventory()
	_build_pause_layer()


func _build_player_portrait() -> void:
	var portrait_shell := PanelContainer.new()
	portrait_shell.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	portrait_shell.position = Vector2(26, -170)
	portrait_shell.size = Vector2(126, 126)
	portrait_shell.add_theme_stylebox_override("panel", _stylebox(Color("#141925f0"), Color("#e7d2a5"), 3, 80))
	add_child(portrait_shell)
	avatar = TextureRect.new()
	avatar.texture = load("res://image/characters/player_avatar.jpg")
	avatar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	avatar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	avatar.custom_minimum_size = Vector2(108, 108)
	avatar.material = _round_mask_material()
	portrait_shell.add_child(avatar)
	var stats_panel := PanelContainer.new()
	stats_panel.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	stats_panel.position = Vector2(164, -94)
	stats_panel.size = Vector2(270, 76)
	stats_panel.add_theme_stylebox_override("panel", _stylebox(Color("#141925e8"), Color("#e7d2a566"), 1, 10))
	add_child(stats_panel)
	var stats_column := VBoxContainer.new()
	stats_column.add_theme_constant_override("separation", 2)
	stats_panel.add_child(stats_column)
	var hp_row := HBoxContainer.new()
	hp_row.add_theme_constant_override("separation", 8)
	stats_column.add_child(hp_row)
	hp_text = _label("MÁU  5 / 5", 12, "#ffd9d7")
	hp_text.custom_minimum_size.x = 75
	hp_row.add_child(hp_text)
	hp_fill = ProgressBar.new()
	hp_fill.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hp_fill.custom_minimum_size.y = 14
	hp_fill.max_value = max_player_hp
	hp_fill.show_percentage = false
	hp_fill.add_theme_stylebox_override("background", _stylebox(Color("#241821e8"), Color("#6d3138"), 1, 6))
	hp_fill.add_theme_stylebox_override("fill", _stylebox(Color("#cf3945"), Color("#ff8389"), 1, 6))
	hp_row.add_child(hp_fill)
	var mind_row := HBoxContainer.new()
	mind_row.add_theme_constant_override("separation", 5)
	stats_column.add_child(mind_row)
	mind_text = _label("MIND", 12, "#e6d9ff")
	mind_text.custom_minimum_size.x = 48
	mind_row.add_child(mind_text)
	for index in range(MAX_MIND * 2 + 1):
		var marker := _label("●", 12, "#45404d")
		marker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		marker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		mind_markers.append(marker)
		mind_row.add_child(marker)


func _build_move_button() -> void:
	move_button = Button.new()
	move_button.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	move_button.position = Vector2(26, -64)
	move_button.size = Vector2(128, 128)
	move_button.tooltip_text = "Tung xúc xắc di chuyển"
	move_button.pressed.connect(_on_move_pressed)
	add_child(move_button)
	move_label = _label("DI\nCHUYỂN", 14, "#fff6e8")
	move_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	move_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	move_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	move_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 26)
	move_button.add_child(move_label)
	_set_move_button(Color("#315c76"))


func _build_inventory() -> void:
	inventory_button = Button.new()
	inventory_button.text = "INVENTORY"
	inventory_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	inventory_button.position = Vector2(-174, 24)
	inventory_button.size = Vector2(150, 44)
	inventory_button.add_theme_font_size_override("font_size", 15)
	inventory_button.pressed.connect(_toggle_inventory)
	add_child(inventory_button)
	inventory_layer = Control.new()
	inventory_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	inventory_layer.visible = false
	inventory_layer.z_index = 10
	add_child(inventory_layer)
	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.025, 0.02, 0.035, 0.88)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	inventory_layer.add_child(shade)
	var left := _inventory_panel(Control.PRESET_LEFT_WIDE, Vector2(28, 30), Vector2(350, -30), "TÚI ĐỒ")
	var left_column := left.get_child(0) as VBoxContainer
	_add_inventory_slot(left_column, "VŨ KHÍ", "Dao găm · D4", true)
	for index in range(4):
		_add_inventory_slot(left_column, "TÚI %d" % (index + 1), "Trống", false)
	var right := _inventory_panel(Control.PRESET_RIGHT_WIDE, Vector2(-390, 30), Vector2(-28, -30), "NHÂN VẬT")
	var right_column := right.get_child(0) as VBoxContainer
	var figure := Control.new()
	figure.custom_minimum_size = Vector2(0, 245)
	figure.size_flags_vertical = Control.SIZE_EXPAND_FILL
	figure.draw.connect(_draw_character_figure.bind(figure))
	right_column.add_child(figure)
	var equipment_caption := _label("TRANG BỊ HIỆN TẠI", 11, "#c4a16a")
	equipment_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	right_column.add_child(equipment_caption)
	for slot_name in ["ĐẦU", "THÂN", "DI VẬT"]:
		_add_inventory_slot(right_column, slot_name, "Chưa trang bị", false)
	var close_button := Button.new()
	close_button.text = "ĐÓNG  ·  I / ESC"
	close_button.custom_minimum_size.y = 40
	close_button.pressed.connect(_toggle_inventory)
	right_column.add_child(close_button)


func _inventory_panel(preset: int, position: Vector2, end_offset: Vector2, heading: String) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.set_anchors_and_offsets_preset(preset)
	panel.offset_left = position.x
	panel.offset_top = position.y
	panel.offset_right = end_offset.x
	panel.offset_bottom = end_offset.y
	panel.add_theme_stylebox_override("panel", _stylebox(Color("#17151bf5"), Color("#9a7444"), 2, 12))
	inventory_layer.add_child(panel)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 9)
	panel.add_child(column)
	var title := _label(heading, 18, "#e8dcc3")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(title)
	return panel


func _add_inventory_slot(parent: VBoxContainer, heading: String, contents: String, equipped: bool) -> void:
	var slot := PanelContainer.new()
	slot.custom_minimum_size.y = 62
	slot.add_theme_stylebox_override("panel", _stylebox(Color("#262128"), Color("#c4a16a") if equipped else Color("#5c5050"), 1, 7))
	parent.add_child(slot)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	slot.add_child(row)
	var icon := _label("⚔" if equipped else "◇", 22, "#c4a16a")
	icon.custom_minimum_size.x = 36
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.add_child(icon)
	var copy := VBoxContainer.new()
	copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(copy)
	copy.add_child(_label(heading, 11, "#c4a16a"))
	copy.add_child(_label(contents, 14, "#e8dcc3"))


func _draw_character_figure(figure: Control) -> void:
	var center := figure.size.x * 0.5
	var armor := Color("#514348") if weapon_die == 4 else Color("#675143")
	var metal := Color("#b18b58")
	figure.draw_colored_polygon(PackedVector2Array([Vector2(center - 24, 72), Vector2(center - 53, 85), Vector2(center - 67, 151), Vector2(center - 48, 158), Vector2(center - 34, 115), Vector2(center - 29, 176), Vector2(center + 29, 176), Vector2(center + 34, 115), Vector2(center + 48, 158), Vector2(center + 67, 151), Vector2(center + 53, 85), Vector2(center + 24, 72)]), armor)
	figure.draw_colored_polygon(PackedVector2Array([Vector2(center - 24, 72), Vector2(center, 89), Vector2(center + 24, 72), Vector2(center + 20, 139), Vector2(center, 153), Vector2(center - 20, 139)]), Color("#30282d"))
	figure.draw_colored_polygon(PackedVector2Array([Vector2(center - 26, 176), Vector2(center - 3, 176), Vector2(center - 8, 225), Vector2(center - 31, 225)]), armor)
	figure.draw_colored_polygon(PackedVector2Array([Vector2(center + 3, 176), Vector2(center + 26, 176), Vector2(center + 31, 225), Vector2(center + 8, 225)]), armor)
	figure.draw_rect(Rect2(center - 17, 138, 34, 7), metal)
	figure.draw_circle(Vector2(center, 38), 23, Color("#d3b9ac"))
	figure.draw_colored_polygon(PackedVector2Array([Vector2(center - 25, 39), Vector2(center - 21, 17), Vector2(center, 7), Vector2(center + 21, 19), Vector2(center + 25, 41), Vector2(center + 10, 28), Vector2(center - 9, 27)]), Color("#e2ded9"))
	figure.draw_line(Vector2(center - 35, 232), Vector2(center + 35, 232), metal, 2)
func _toggle_inventory() -> void:
	if pause_layer != null and pause_layer.visible:
		return
	inventory_layer.visible = not inventory_layer.visible
	inventory_button.text = "ĐÓNG TÚI ĐỒ" if inventory_layer.visible else "INVENTORY"
	if inventory_layer.visible:
		get_viewport().set_input_as_handled()


func _build_pause_layer() -> void:
	pause_button = Button.new()
	pause_button.text = "TẠM DỪNG  ·  ESC"
	pause_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	pause_button.position = Vector2(-326, 24)
	pause_button.size = Vector2(136, 44)
	pause_button.pressed.connect(_open_pause_menu)
	add_child(pause_button)
	pause_layer = Control.new()
	pause_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_layer.visible = false
	pause_layer.z_index = 20
	add_child(pause_layer)


func _open_pause_menu() -> void:
	if inventory_layer.visible:
		inventory_layer.visible = false
		inventory_button.text = "INVENTORY"
	for child in pause_layer.get_children():
		child.queue_free()
	pause_layer.visible = true
	pause_subpage = "menu"
	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.02, 0.015, 0.025, 0.84)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	pause_layer.add_child(shade)
	pause_panel_column = _create_pause_popup_panel(Vector2(580, 580), 0.10)
	pause_panel_column.add_theme_constant_override("separation", 8)
	var heading := _label("TẠM DỪNG", 22, "#e8dcc3")
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pause_panel_column.add_child(heading)
	pause_status = _label("Hành trình chưa được lưu", 12, "#a99b88")
	pause_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pause_panel_column.add_child(pause_status)
	_add_pause_button("TIẾP TỤC", _close_pause_menu)
	_add_pause_button("LƯU HÀNH TRÌNH", _save_run_from_pause)
	_add_pause_button("CÀI ĐẶT", _open_game_settings)
	_add_pause_button("LƯU VÀ VỀ MENU", _save_and_return_menu)
	_add_pause_button("VỀ MENU KHÔNG LƯU", _confirm_leave_unsaved)
	_add_pause_button("THOÁT GAME", _confirm_quit_game)


func _add_pause_button(text: String, action: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(220, 58)
	_apply_pause_button_frame(button)
	button.pressed.connect(action)
	pause_panel_column.add_child(button)


func _open_game_settings() -> void:
	pause_subpage = "settings"
	for child in pause_layer.get_children():
		child.queue_free()
	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.02, 0.015, 0.025, 0.84)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	pause_layer.add_child(shade)
	var column := _create_pause_popup_panel(Vector2(460, 460), 0.18)
	column.add_theme_constant_override("separation", 14)
	var heading := _label("CÀI ĐẶT", 20, "#e8dcc3")
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(heading)
	var current_volume := 1.0
	var bus_index := AudioServer.get_bus_index("Master")
	if bus_index >= 0:
		current_volume = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	var volume_label := _label("ÂM LƯỢNG CHUNG  ·  %d%%" % roundi(current_volume * 100.0), 13, "#e8dcc3")
	column.add_child(volume_label)
	var volume_slider := HSlider.new()
	volume_slider.min_value = 0.0
	volume_slider.max_value = 1.0
	volume_slider.step = 0.01
	volume_slider.value = current_volume
	volume_slider.value_changed.connect(_apply_game_volume.bind(volume_label))
	column.add_child(volume_slider)
	var fullscreen := CheckButton.new()
	fullscreen.text = "Toàn màn hình"
	fullscreen.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	fullscreen.toggled.connect(_apply_game_fullscreen)
	column.add_child(fullscreen)
	var back := Button.new()
	back.text = "QUAY LẠI"
	back.custom_minimum_size = Vector2(250, 66)
	_apply_pause_button_frame(back)
	back.pressed.connect(_open_pause_menu)
	column.add_child(back)


func _apply_game_volume(value: float, label: Label) -> void:
	var bus_index := AudioServer.get_bus_index("Master")
	if bus_index >= 0:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(maxf(value, 0.001)))
	label.text = "ÂM LƯỢNG CHUNG  ·  %d%%" % roundi(value * 100.0)
	_save_game_settings(value, DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)


func _apply_game_fullscreen(enabled: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED)
	var bus_index := AudioServer.get_bus_index("Master")
	var volume := db_to_linear(AudioServer.get_bus_volume_db(bus_index)) if bus_index >= 0 else 1.0
	_save_game_settings(volume, enabled)


func _save_game_settings(volume: float, fullscreen: bool) -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "master_volume", volume)
	config.set_value("display", "fullscreen", fullscreen)
	config.save(SETTINGS_PATH)


func _close_pause_menu() -> void:
	pause_layer.visible = false


func _save_run_from_pause() -> void:
	if _write_run_save():
		pause_status.text = "Đã lưu hành trình · %s" % Time.get_time_string_from_system()
	else:
		pause_status.text = "Không thể lưu hành trình"


func _save_and_return_menu() -> void:
	if _write_run_save():
		get_tree().change_scene_to_file(MENU_SCENE)
	else:
		pause_status.text = "Không thể lưu · hãy thử lại"


func _confirm_leave_unsaved() -> void:
	_show_game_confirmation("Rời hành trình?", "Tiến trình hiện tại sẽ không được lưu.", "RỜI GAME", _return_to_menu)


func _confirm_quit_game() -> void:
	_show_game_confirmation("Thoát game?", "Tiến trình hiện tại sẽ không được lưu tự động.", "THOÁT", _quit_game)


func _return_to_menu() -> void:
	get_tree().change_scene_to_file(MENU_SCENE)


func _quit_game() -> void:
	get_tree().quit()


func _show_game_confirmation(title: String, body: String, confirm_text: String, action: Callable) -> void:
	pause_subpage = "confirmation"
	for child in pause_layer.get_children():
		child.queue_free()
	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.02, 0.015, 0.025, 0.9)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	pause_layer.add_child(shade)
	var column := _create_pause_popup_panel(Vector2(440, 440), 0.18)
	column.add_theme_constant_override("separation", 16)
	var heading := _label(title, 20, "#e8dcc3")
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(heading)
	var message := _label(body, 14, "#a99b88")
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(message)
	var confirm := Button.new()
	confirm.text = confirm_text
	confirm.custom_minimum_size = Vector2(280, 74)
	_apply_pause_button_frame(confirm, true)
	confirm.pressed.connect(action)
	column.add_child(confirm)
	var cancel := Button.new()
	cancel.text = "QUAY LẠI"
	cancel.custom_minimum_size = Vector2(250, 66)
	_apply_pause_button_frame(cancel)
	cancel.pressed.connect(_open_pause_menu)
	column.add_child(cancel)


func _create_pause_popup_panel(panel_size: Vector2, inset_ratio: float) -> VBoxContainer:
	var panel := Control.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.position = -panel_size * 0.5
	panel.size = panel_size
	pause_layer.add_child(panel)
	var fill := ColorRect.new()
	fill.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fill.color = Color("#100d12f5")
	fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(fill)
	if ResourceLoader.exists(MENU_PANEL_FRAME):
		var frame := TextureRect.new()
		frame.texture = load(MENU_PANEL_FRAME)
		frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.add_child(frame)
	var margins := MarginContainer.new()
	margins.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var inset_x := roundi(panel_size.x * inset_ratio)
	var inset_y := roundi(panel_size.y * inset_ratio)
	for margin in ["margin_left", "margin_right"]:
		margins.add_theme_constant_override(margin, inset_x)
	for margin in ["margin_top", "margin_bottom"]:
		margins.add_theme_constant_override(margin, inset_y)
	panel.add_child(margins)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 12)
	margins.add_child(column)
	return column


func _apply_pause_button_frame(button: Button, selected := false) -> void:
	var caption_text := button.text
	button.text = ""
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	for state in ["normal", "hover", "focus", "pressed", "disabled"]:
		button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	if ResourceLoader.exists(MENU_BUTTON_FRAME):
		var frame := TextureRect.new()
		frame.texture = load(MENU_BUTTON_FRAME)
		frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		frame.modulate = Color("#d1b987") if selected else Color.WHITE
		frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(frame)
	var caption := Label.new()
	caption.text = caption_text
	caption.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	caption.anchor_left = 0.15
	caption.anchor_right = 0.85
	caption.anchor_top = 0.20
	caption.anchor_bottom = 0.80
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	caption.add_theme_font_size_override("font_size", 14)
	caption.add_theme_color_override("font_color", Color("#e8dcc3"))
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(caption)


func _write_run_save() -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return false
	var save_data := {
		"version": 1,
		"saved_at": Time.get_datetime_string_from_system(),
		"player_hp": player_hp,
		"max_player_hp": max_player_hp,
		"mind": mind,
		"current_room": current_room,
		"combat_active": combat_active,
		"current_enemy": current_enemy,
		"enemy_hp": enemy_hp,
		"bonfire_used": bonfire_used,
		"prayer_pending": prayer_pending,
		"run_over": run_over
	}
	file.store_string(JSON.stringify(save_data))
	return file.get_error() == OK


func _restore_run() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return
	var data: Dictionary = parsed
	max_player_hp = maxi(1, int(data.get("max_player_hp", max_player_hp)))
	player_hp = clampi(int(data.get("player_hp", max_player_hp)), 0, max_player_hp)
	mind = clampi(int(data.get("mind", 0)), -MAX_MIND, MAX_MIND)
	current_room = clampi(int(data.get("current_room", -1)), -1, ROOM_BACKGROUNDS.size() - 1)
	combat_active = bool(data.get("combat_active", false))
	current_enemy = data.get("current_enemy", {}) if data.get("current_enemy", {}) is Dictionary else {}
	enemy_hp = maxi(0, int(data.get("enemy_hp", 0)))
	bonfire_used = bool(data.get("bonfire_used", false))
	prayer_pending = bool(data.get("prayer_pending", false))
	run_over = bool(data.get("run_over", false))
	if current_room < 0:
		_show_idle_state()
	else:
		background.texture = load(ROOM_BACKGROUNDS[current_room])
		background.modulate = Color.WHITE
		_set_move_button(ROOM_COLORS[current_room])
		room_hint.text = "Tiếp tục hành trình"
		move_label.text = "DI\nCHUYỂN"
		if prayer_pending:
			room_hint.text = "CẦU NGUYỆN · Bấm nút để tung D6"
			move_label.text = "TUNG D6\nCẦU NGUYỆN"
		if current_room == 5 and not bonfire_used:
			room_hint.text = "LỬA TRẠI · Bấm nút để hồi 1 máu"
			move_label.text = "NGHỈ\nNGƠI"
	if combat_active and not current_enemy.is_empty():
		enemy_sprite.visible = true
		combat_panel.visible = true
		combat_text.text = "%s  ·  %d HP" % [current_enemy.get("name", "Quái vật"), enemy_hp]
		roll_text.text = "Quái D%d +%d  ·  Dao găm D%d" % [int(current_enemy.get("die", 6)), int(current_enemy.get("attack", 0)), weapon_die]
		room_hint.text = "Tiếp tục chiến đấu"
		move_label.text = "TẤN\nCÔNG"
	if run_over:
		_end_run()
	_update_portrait()


func _on_move_pressed() -> void:
	if inventory_layer.visible or pause_layer.visible:
		return
	if run_over:
		_reset_run()
	elif combat_active:
		_combat_turn()
	elif prayer_pending:
		_pray()
	elif current_room == 5 and not bonfire_used:
		_use_bonfire()
	else:
		_roll_movement()


func _roll_movement() -> void:
	var roll := rng.randi_range(1, 6)
	current_room = roll - 1
	bonfire_used = false
	prayer_pending = false
	combat_panel.visible = false
	enemy_sprite.visible = false
	background.texture = load(ROOM_BACKGROUNDS[current_room])
	background.modulate = Color.WHITE
	_set_move_button(ROOM_COLORS[current_room])
	match current_room:
		0: _enter_monster_room()
		1:
			room_hint.text = "BẪY · D6: %d" % roll
			move_label.text = "BẪY\nTUNG TIẾP"
		2:
			prayer_pending = true
			room_hint.text = "CẦU NGUYỆN · Tung D6 để nhận phước lành hoặc mất mát"
			move_label.text = "TUNG D6\nCẦU NGUYỆN"
		3:
			room_hint.text = "DỊCH CHUYỂN · Điểm đến sẽ được bổ sung"
			move_label.text = "DỊCH\nCHUYỂN"
		4:
			room_hint.text = "SỰ KIỆN · Nội dung sẽ được bổ sung"
			move_label.text = "SỰ\nKIỆN"
		5:
			room_hint.text = "LỬA TRẠI · Bấm nút để hồi 1 máu"
			move_label.text = "NGHỈ\nNGƠI"


func _enter_monster_room() -> void:
	current_enemy = ENEMIES[rng.randi_range(0, ENEMIES.size() - 1)].duplicate(true)
	if current_enemy["name"] != "Chuột Hang":
		current_enemy["hp"] = rng.randi_range(1, 6)
		current_enemy["attack"] = rng.randi_range(0, 3)
	enemy_hp = int(current_enemy["hp"])
	combat_active = true
	enemy_sprite.visible = true
	combat_panel.visible = true
	combat_text.text = "%s  ·  %d HP" % [current_enemy["name"], enemy_hp]
	roll_text.text = "Quái D%d +%d  ·  Dao găm D%d" % [current_enemy["die"], current_enemy["attack"], weapon_die]
	room_hint.text = "Gặp quái · Bấm nút đỏ để tấn công"
	move_label.text = "TẤN\nCÔNG"


func _combat_turn() -> void:
	var player_roll := rng.randi_range(1, weapon_die)
	var enemy_roll: int = rng.randi_range(1, int(current_enemy["die"])) + int(current_enemy["attack"])
	if player_roll > enemy_roll:
		enemy_hp -= 1
		roll_text.text = "Bạn %d  ×  Quái %d  ·  Đòn trúng!" % [player_roll, enemy_roll]
		if enemy_hp <= 0:
			combat_active = false
			enemy_sprite.visible = false
			combat_text.text = "Quái vật đã bị hạ"
			room_hint.text = "Bấm nút để tiếp tục di chuyển"
			move_label.text = "DI\nCHUYỂN"
			return
	elif player_roll < enemy_roll:
		player_hp = maxi(0, player_hp - 1)
		_update_portrait()
		roll_text.text = "Bạn %d  ×  Quái %d  ·  Bạn mất 1 HP" % [player_roll, enemy_roll]
	else:
		roll_text.text = "Bạn %d  ×  Quái %d  ·  Hòa" % [player_roll, enemy_roll]
	combat_text.text = "%s  ·  %d HP" % [current_enemy["name"], enemy_hp]
	if player_hp <= 0:
		_end_run()


func _use_bonfire() -> void:
	bonfire_used = true
	player_hp = mini(max_player_hp, player_hp + 1)
	_update_portrait()
	room_hint.text = "Bạn đã nghỉ ngơi · hồi 1 HP"
	move_label.text = "DI\nCHUYỂN"


func _pray() -> void:
	prayer_pending = false
	var roll := rng.randi_range(1, 6)
	var effects := [Vector2i(-1, -1), Vector2i(0, -1), Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)]
	var effect: Vector2i = effects[roll - 1]
	var old_hp := player_hp
	var old_mind := mind
	player_hp = clampi(player_hp + effect.x, 0, max_player_hp)
	mind = clampi(mind + effect.y, -MAX_MIND, MAX_MIND)
	_update_portrait()
	var result_parts: Array[String] = []
	if effect.x != 0:
		var hp_change := player_hp - old_hp
		result_parts.append(("+1 máu" if hp_change > 0 else "−1 máu") if hp_change != 0 else "Máu đã chạm giới hạn")
	if effect.y != 0:
		var mind_change := mind - old_mind
		result_parts.append(("+1 Mind" if mind_change > 0 else "−1 Mind") if mind_change != 0 else "Mind đã chạm giới hạn")
	if result_parts.is_empty():
		result_parts.append("Không đổi")
	room_hint.text = "CẦU NGUYỆN · D6 ra %d · %s" % [roll, " · ".join(result_parts)]
	move_label.text = "DI\nCHUYỂN"
	if player_hp <= 0:
		_end_run()


func _show_idle_state() -> void:
	background.texture = load("res://image/rooms/room_event.jpg")
	background.modulate = Color(0.55, 0.55, 0.62, 1.0)
	room_hint.text = "Bấm vòng tròn để tung D6 di chuyển"
	combat_panel.visible = false
	move_label.text = "DI\nCHUYỂN"
	_update_portrait()


func _update_portrait() -> void:
	hp_fill.max_value = max_player_hp
	hp_fill.value = player_hp
	hp_text.text = "MÁU  %d / %d" % [player_hp, max_player_hp]
	mind_text.text = "MIND %s%d" % ["+" if mind > 0 else "", mind]
	for index in range(mind_markers.size()):
		var marker_mind := index - MAX_MIND
		if marker_mind == mind:
			mind_markers[index].add_theme_color_override("font_color", Color("#e2b66c") if mind >= 0 else Color("#b78bd2"))
		else:
			mind_markers[index].add_theme_color_override("font_color", Color("#45404d"))
	if mind < 0:
		avatar.modulate = Color("#a8799e")
	elif mind > 0:
		avatar.modulate = Color("#a787d9")
	else:
		avatar.modulate = Color.WHITE


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_I:
			_toggle_inventory()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_S and event.ctrl_pressed:
			_open_pause_menu()
			_save_run_from_pause()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("ui_cancel"):
			if inventory_layer.visible:
				_toggle_inventory()
			elif pause_layer.visible:
				if pause_subpage == "menu":
					_close_pause_menu()
				else:
					_open_pause_menu()
			else:
				_open_pause_menu()
			get_viewport().set_input_as_handled()


func _end_run() -> void:
	run_over = true
	combat_active = false
	enemy_sprite.visible = false
	combat_panel.visible = true
	combat_text.text = "Bạn đã gục ngã"
	roll_text.text = "Bấm vòng tròn để chơi lại"
	room_hint.text = ""
	move_label.text = "CHƠI\nLẠI"
	_set_move_button(Color("#5a3445"))


func _reset_run() -> void:
	player_hp = max_player_hp
	mind = 0
	current_room = -1
	combat_active = false
	run_over = false
	bonfire_used = false
	prayer_pending = false
	_show_idle_state()
	_set_move_button(Color("#315c76"))


func _set_move_button(color: Color) -> void:
	move_button.add_theme_stylebox_override("normal", _stylebox(color.darkened(0.13), color.lightened(0.25), 3, 80))
	move_button.add_theme_stylebox_override("hover", _stylebox(color.lightened(0.08), Color("#fff3dc"), 3, 80))
	move_button.add_theme_stylebox_override("pressed", _stylebox(color.darkened(0.3), color.lightened(0.12), 3, 80))


func _stylebox(fill: Color, border: Color, width: int, radius: int) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(width)
	box.set_corner_radius_all(radius)
	return box


func _label(text: String, font_size: int, color: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(color))
	return label


func _round_mask_material() -> ShaderMaterial:
	var shader := Shader.new()
	shader.code = "shader_type canvas_item; void fragment() { vec2 uv = UV - vec2(0.5); if (length(uv) > 0.5) { COLOR = vec4(0.0); } else { COLOR = texture(TEXTURE, UV) * COLOR; } }"
	var material := ShaderMaterial.new()
	material.shader = shader
	return material
