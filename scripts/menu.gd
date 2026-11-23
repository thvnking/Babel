extends Control

const GAME_SCENE := "res://Game.tscn"
const MENU_ART := "res://image/ui/menu/menu_background.png"
const MENU_PANEL_FRAME := "res://image/ui/menu/menu_panel_frame.png"
const MENU_BUTTON_FRAME := "res://image/ui/menu/menu_button_frame.png"
const TEMP_BACKGROUND := "res://image/rooms/room_event.jpg"
const SAVE_PATH := "user://babel_save.json"
const SETTINGS_PATH := "user://babel_settings.cfg"

const SIDEBAR_WIDTH_RATIO := 0.27
const COLOR_INK := Color("#100d12")
const COLOR_STONE := Color("#19151a")
const COLOR_STONE_LIGHT := Color("#241d22")
const COLOR_BRONZE := Color("#9a7444")
const COLOR_BRONZE_BRIGHT := Color("#c4a16a")
const COLOR_PARCHMENT := Color("#e8dcc3")
const COLOR_MUTED := Color("#a99b88")

var sidebar_content: VBoxContainer
var page_content: VBoxContainer
var sidebar_width_ratio := SIDEBAR_WIDTH_RATIO
var volume_slider: HSlider
var fullscreen_button: CheckButton
var volume_value_label: Label
var menu_buttons: Array[Button] = []
var menu_button_frames: Array[TextureRect] = []
var menu_button_labels: Array[Label] = []
var selected_index := 0
var current_page := "main"
var popup_layer: Control
var popup_confirm_action: Callable


func _ready() -> void:
	var viewport_width := maxf(size.x, 1.0)
	sidebar_width_ratio = clampf(maxf(viewport_width * SIDEBAR_WIDTH_RATIO, 380.0) / viewport_width, SIDEBAR_WIDTH_RATIO, 0.42)
	_build_menu()
	_load_settings()
	_show_main_page()


func _build_menu() -> void:
	var background := TextureRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.texture = load(MENU_ART) if ResourceLoader.exists(MENU_ART) else load(TEMP_BACKGROUND)
	background.modulate = Color(0.62, 0.58, 0.56, 1.0)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var image_shade := ColorRect.new()
	image_shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	image_shade.color = Color(0.025, 0.02, 0.03, 0.39)
	image_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(image_shade)

	var sidebar := ColorRect.new()
	sidebar.anchor_right = sidebar_width_ratio
	sidebar.anchor_bottom = 1.0
	sidebar.color = Color(COLOR_INK, 0.94)
	sidebar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sidebar)

	var sidebar_edge := ColorRect.new()
	sidebar_edge.anchor_left = sidebar_width_ratio
	sidebar_edge.anchor_right = sidebar_width_ratio
	sidebar_edge.anchor_bottom = 1.0
	sidebar_edge.offset_left = -1
	sidebar_edge.offset_right = 1
	sidebar_edge.color = Color(COLOR_BRONZE, 0.76)
	sidebar_edge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sidebar_edge)

	var margins := MarginContainer.new()
	margins.anchor_right = sidebar_width_ratio
	margins.anchor_bottom = 1.0
	var sidebar_width := size.x * sidebar_width_ratio
	var content_inset := clampi(roundi(sidebar_width * 0.10), 24, 54)
	margins.add_theme_constant_override("margin_left", content_inset)
	margins.add_theme_constant_override("margin_top", 48)
	margins.add_theme_constant_override("margin_right", content_inset)
	margins.add_theme_constant_override("margin_bottom", 42)
	add_child(margins)

	sidebar_content = VBoxContainer.new()
	sidebar_content.add_theme_constant_override("separation", 0)
	margins.add_child(sidebar_content)
	_build_sidebar_header()

	page_content = VBoxContainer.new()
	page_content.add_theme_constant_override("separation", 5)
	sidebar_content.add_child(page_content)

	var bottom_spacer := Control.new()
	bottom_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sidebar_content.add_child(bottom_spacer)

	var footer_rule := ColorRect.new()
	footer_rule.color = Color(COLOR_BRONZE, 0.5)
	footer_rule.custom_minimum_size = Vector2(0, 1)
	sidebar_content.add_child(footer_rule)

	var version := _label("BẢN THỬ NGHIỆM  ·  18+", 12, COLOR_MUTED)
	version.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	version.custom_minimum_size.y = 34
	sidebar_content.add_child(version)

	var controls_hint := _label("ENTER  ·  CHỌN          ESC  ·  QUAY LẠI", 13, Color(COLOR_PARCHMENT, 0.72))
	controls_hint.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	controls_hint.anchor_left = sidebar_width_ratio
	controls_hint.offset_top = -42
	controls_hint.offset_bottom = -14
	controls_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	controls_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(controls_hint)
	popup_layer = Control.new()
	popup_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	popup_layer.visible = false
	popup_layer.z_index = 20
	add_child(popup_layer)


func _build_sidebar_header() -> void:
	var title := _label("B A B E L", 42, COLOR_PARCHMENT)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_constant_override("outline_size", 4)
	title.add_theme_color_override("font_outline_color", Color(0.02, 0.015, 0.02, 0.9))
	sidebar_content.add_child(title)

	var overline := _label("DESCENT INTO THE ABYSS", 10, COLOR_BRONZE_BRIGHT)
	overline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sidebar_content.add_child(overline)

	var subtitle := _label("Càng lên cao, càng chìm sâu.", 12, COLOR_MUTED)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.custom_minimum_size.y = 25
	sidebar_content.add_child(subtitle)

	var top_space := Control.new()
	top_space.custom_minimum_size.y = 32
	sidebar_content.add_child(top_space)

	var section_title := _label("HÀNH TRÌNH", 13, COLOR_BRONZE_BRIGHT)
	sidebar_content.add_child(section_title)

	var divider := ColorRect.new()
	divider.color = Color(COLOR_BRONZE, 0.62)
	divider.custom_minimum_size = Vector2(0, 1)
	sidebar_content.add_child(divider)

	var section_space := Control.new()
	section_space.custom_minimum_size.y = 12
	sidebar_content.add_child(section_space)


func _show_main_page() -> void:
	current_page = "main"
	_clear_page()
	menu_buttons.clear()
	var has_save := FileAccess.file_exists(SAVE_PATH)
	_add_menu_item("Tiếp tục", "Tiếp tục hành trình đã lưu" if has_save else "Chưa có hành trình đã lưu", _load_saved_game, not has_save)
	_add_menu_item("Bắt đầu mới", "", _request_new_game)
	_add_menu_item("Tải hành trình", "Chọn dữ liệu đã lưu" if has_save else "Chưa có dữ liệu lưu", _show_load_popup, not has_save)
	_add_menu_item("Cài đặt", "", _show_settings_page)
	_add_menu_item("Credits", "", _show_credits_page)
	_add_menu_item("Thoát", "", _request_quit)
	selected_index = 1
	_update_menu_item_styles()
	menu_buttons[selected_index].call_deferred("grab_focus")


func _show_settings_page() -> void:
	current_page = "settings"
	_clear_page()
	_add_page_heading("CÀI ĐẶT")
	_add_small_gap(18)
	page_content.add_child(_label("ÂM LƯỢNG", 12, COLOR_MUTED))
	volume_slider = HSlider.new()
	volume_slider.min_value = 0.0
	volume_slider.max_value = 1.0
	volume_slider.step = 0.01
	volume_slider.value = _get_master_volume()
	volume_slider.custom_minimum_size = Vector2(0, 30)
	volume_slider.value_changed.connect(_set_master_volume)
	page_content.add_child(volume_slider)
	volume_value_label = _label("%d%%" % roundi(volume_slider.value * 100.0), 12, COLOR_PARCHMENT)
	page_content.add_child(volume_value_label)
	fullscreen_button = CheckButton.new()
	fullscreen_button.text = "Toàn màn hình"
	fullscreen_button.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	fullscreen_button.add_theme_color_override("font_color", COLOR_PARCHMENT)
	fullscreen_button.add_theme_color_override("font_hover_color", Color.WHITE)
	fullscreen_button.toggled.connect(_set_fullscreen)
	page_content.add_child(fullscreen_button)
	_add_small_gap(14)
	_add_menu_item("Khôi phục mặc định", "Âm lượng 100% · Cửa sổ", _reset_settings)
	_add_small_gap(20)
	_add_menu_item("Quay lại", "", _show_main_page)
	menu_buttons[0].call_deferred("grab_focus")


func _show_credits_page() -> void:
	current_page = "credits"
	_clear_page()
	_add_page_heading("CREDITS")
	_add_small_gap(20)
	page_content.add_child(_label("BABEL", 26, COLOR_PARCHMENT))
	page_content.add_child(_label("DESCENT INTO THE ABYSS", 11, COLOR_BRONZE_BRIGHT))
	_add_small_gap(12)
	page_content.add_child(_label("Phát triển", 12, COLOR_BRONZE_BRIGHT))
	page_content.add_child(_label("Dự án độc lập Babel", 14, COLOR_PARCHMENT))
	_add_small_gap(8)
	page_content.add_child(_label("Công cụ", 12, COLOR_BRONZE_BRIGHT))
	page_content.add_child(_label("Godot Engine · Prototype 2D", 14, COLOR_PARCHMENT))
	_add_small_gap(8)
	page_content.add_child(_label("Cảm ơn bạn đã chơi bản thử nghiệm.", 13, COLOR_MUTED))
	_add_small_gap(26)
	_add_menu_item("Quay lại", "", _show_main_page)
	menu_buttons[0].call_deferred("grab_focus")


func _add_page_heading(text: String) -> void:
	var heading := _label(text, 13, COLOR_BRONZE_BRIGHT)
	page_content.add_child(heading)
	var divider := ColorRect.new()
	divider.color = Color(COLOR_BRONZE, 0.62)
	divider.custom_minimum_size = Vector2(0, 1)
	page_content.add_child(divider)


func _add_small_gap(height: float) -> void:
	var gap := Control.new()
	gap.custom_minimum_size.y = height
	page_content.add_child(gap)


func _add_menu_item(title: String, description: String, action: Callable, disabled := false) -> void:
	var button := Button.new()
	var frame_texture := load(MENU_BUTTON_FRAME) as Texture2D
	var sidebar_width := size.x * sidebar_width_ratio
	var inset := clampf(sidebar_width * 0.10, 24.0, 54.0)
	var max_frame_width := maxf(1.0, sidebar_width - inset * 2.0)
	var item_height := clampf((size.y - 290.0) / 6.0, 58.0, 88.0)
	var frame_ratio := frame_texture.get_width() / float(frame_texture.get_height()) if frame_texture else 3.8
	var frame_width := minf(max_frame_width, item_height * frame_ratio)
	button.custom_minimum_size = Vector2(frame_width, frame_width / frame_ratio)
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.disabled = disabled
	button.focus_mode = Control.FOCUS_ALL
	button.text = ""
	button.tooltip_text = description
	for state in ["normal", "hover", "focus", "pressed", "disabled"]:
		button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	var frame := TextureRect.new()
	frame.texture = frame_texture
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(frame)
	var text_label := Label.new()
	text_label.text = title
	text_label.anchor_left = 0.15
	text_label.anchor_top = 0.24
	text_label.anchor_right = 0.85
	text_label.anchor_bottom = 0.76
	text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text_label.add_theme_font_size_override("font_size", 16)
	text_label.add_theme_color_override("font_color", COLOR_PARCHMENT)
	text_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(text_label)
	var item_index := menu_buttons.size()
	menu_buttons.append(button)
	menu_button_frames.append(frame)
	menu_button_labels.append(text_label)
	button.mouse_entered.connect(_on_item_hovered.bind(item_index))
	button.focus_entered.connect(_on_item_hovered.bind(item_index))
	button.pressed.connect(_on_menu_item_pressed.bind(item_index, action))
	page_content.add_child(button)


func _on_item_hovered(index: int) -> void:
	if index < 0 or index >= menu_buttons.size():
		return
	selected_index = index
	_update_menu_item_styles()


func _on_menu_item_pressed(index: int, action: Callable) -> void:
	selected_index = index
	if action.is_valid():
		action.call()


func _update_menu_item_styles() -> void:
	for index in range(menu_buttons.size()):
		var selected := index == selected_index
		var button := menu_buttons[index]
		menu_button_frames[index].modulate = Color("#79736a") if button.disabled else Color("#d1b987") if selected else Color.WHITE
		menu_button_labels[index].add_theme_color_override("font_color", Color("#8a8075") if button.disabled else Color.WHITE if selected else COLOR_PARCHMENT)


func _item_style(selected: bool, pressed := false, disabled := false) -> StyleBox:
	if ResourceLoader.exists(MENU_BUTTON_FRAME):
		var image_style := StyleBoxTexture.new()
		image_style.texture = load(MENU_BUTTON_FRAME)
		image_style.texture_margin_left = 150
		image_style.texture_margin_right = 150
		image_style.texture_margin_top = 115
		image_style.texture_margin_bottom = 115
		image_style.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
		image_style.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
		image_style.content_margin_left = 22
		image_style.content_margin_right = 22
		image_style.content_margin_top = 6
		image_style.content_margin_bottom = 6
		image_style.modulate_color = Color("#79736a") if disabled else Color("#d1b987") if selected else Color("#a59b8a")
		if pressed:
			image_style.modulate_color = Color("#77684e")
		return image_style

	var style := StyleBoxFlat.new()
	style.bg_color = Color(COLOR_STONE_LIGHT, 0.9) if selected else Color(0, 0, 0, 0)
	if pressed:
		style.bg_color = Color(COLOR_INK, 0.96)
	if disabled:
		style.bg_color = Color(0, 0, 0, 0)
	style.border_color = COLOR_BRONZE_BRIGHT if selected else Color(COLOR_BRONZE, 0.22)
	style.border_width_left = 3 if selected else 0
	style.border_width_bottom = 1 if selected else 0
	style.content_margin_left = 14
	style.content_margin_right = 8
	style.content_margin_top = 4
	style.content_margin_bottom = 4
	return style

func _clear_page() -> void:
	menu_buttons.clear()
	menu_button_frames.clear()
	menu_button_labels.clear()
	selected_index = 0
	for child in page_content.get_children():
		page_content.remove_child(child)
		child.queue_free()


func _label(text: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label


func _request_new_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		_show_popup("Bắt đầu hành trình mới?", "Hành trình hiện đang lưu sẽ bị xóa khi bạn bắt đầu mới.", "BẮT ĐẦU", _start_new_game, "QUAY LẠI")
	else:
		_start_new_game()


func _start_new_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
	get_tree().set_meta("load_saved_run", false)
	get_tree().change_scene_to_file(GAME_SCENE)


func _load_saved_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_show_popup("Chưa có hành trình", "Bắt đầu một hành trình mới để tạo dữ liệu lưu.", "ĐÃ HIỂU", Callable(), "")
		return
	get_tree().set_meta("load_saved_run", true)
	get_tree().change_scene_to_file(GAME_SCENE)


func _show_load_popup() -> void:
	var saved_data := _read_save_file()
	if saved_data.is_empty():
		_show_popup("Không đọc được dữ liệu lưu", "Tệp lưu không hợp lệ. Bạn có thể bắt đầu hành trình mới.", "ĐÓNG", Callable(), "")
		return
	var saved_mind := int(saved_data.get("mind", 0))
	var mind_label := "+%d" % saved_mind if saved_mind > 0 else str(saved_mind)
	var details := "Máu %d · Mind %s\n%s" % [int(saved_data.get("player_hp", 0)), mind_label, "Đang chiến đấu" if bool(saved_data.get("combat_active", false)) else "Đang khám phá"]
	_show_popup("HÀNH TRÌNH ĐÃ LƯU", details, "TẢI HÀNH TRÌNH", _load_saved_game, "HỦY")


func _read_save_file() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}


func _show_popup(title: String, body: String, confirm_text: String, confirm_action: Callable, cancel_text := "") -> void:
	for child in popup_layer.get_children():
		child.queue_free()
	popup_confirm_action = confirm_action
	popup_layer.visible = true
	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.02, 0.015, 0.025, 0.82)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	popup_layer.add_child(shade)
	var panel := Control.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	var popup_size := maxf(1.0, minf(580.0, minf(size.x, size.y) * 0.84))
	panel.position = Vector2(-popup_size * 0.5, -popup_size * 0.5)
	panel.size = Vector2(popup_size, popup_size)
	popup_layer.add_child(panel)
	var panel_fill := ColorRect.new()
	panel_fill.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel_fill.color = Color(COLOR_STONE, 0.98)
	panel_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(panel_fill)
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
	var safe_inset := roundi(popup_size * 0.18)
	for margin in ["margin_left", "margin_top", "margin_right", "margin_bottom"]:
		margins.add_theme_constant_override(margin, safe_inset)
	panel.add_child(margins)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 12)
	margins.add_child(column)
	var heading := _label(title, 20, COLOR_PARCHMENT)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(heading)
	var divider := ColorRect.new()
	divider.color = Color(COLOR_BRONZE, 0.8)
	divider.custom_minimum_size.y = 1
	column.add_child(divider)
	var message := _label(body, 14, COLOR_MUTED)
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.size_flags_vertical = Control.SIZE_EXPAND_FILL
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	column.add_child(message)
	var actions := HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_CENTER
	actions.add_theme_constant_override("separation", 12)
	column.add_child(actions)
	var button_ratio := 2115.0 / 556.0
	var button_count := 2.0 if not cancel_text.is_empty() else 1.0
	var button_spacing := 12.0 if button_count == 2.0 else 0.0
	var button_width := minf(160.0, maxf(1.0, (popup_size - safe_inset * 2.0 - button_spacing) / button_count))
	if not cancel_text.is_empty():
		var cancel := Button.new()
		cancel.text = cancel_text
		cancel.custom_minimum_size = Vector2(button_width, button_width / button_ratio)
		_apply_button_frame(cancel)
		cancel.pressed.connect(_hide_popup)
		actions.add_child(cancel)
	var confirm := Button.new()
	confirm.text = confirm_text
	confirm.custom_minimum_size = Vector2(button_width, button_width / button_ratio)
	_apply_button_frame(confirm, true)
	confirm.pressed.connect(_confirm_popup)
	actions.add_child(confirm)
	confirm.grab_focus()


func _confirm_popup() -> void:
	var action := popup_confirm_action
	_hide_popup()
	if action.is_valid():
		action.call()


func _hide_popup() -> void:
	popup_layer.visible = false


func _apply_button_frame(button: Button, selected := false) -> void:
	var caption_text := button.text
	button.text = ""
	for state in ["normal", "hover", "focus", "pressed", "disabled"]:
		button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
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
	caption.set_anchors_preset(Control.PRESET_FULL_RECT)
	caption.anchor_left = 0.15
	caption.anchor_right = 0.85
	caption.anchor_top = 0.20
	caption.anchor_bottom = 0.80
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	caption.add_theme_font_size_override("font_size", 14)
	caption.add_theme_color_override("font_color", COLOR_PARCHMENT)
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(caption)


func _request_quit() -> void:
	_show_popup("Thoát Babel?", "Bạn có muốn đóng game không?", "THOÁT GAME", _quit_game, "Ở LẠI")


func _quit_game() -> void:
	get_tree().quit()


func _get_master_volume() -> float:
	var bus_index := AudioServer.get_bus_index("Master")
	if bus_index < 0:
		return 1.0
	return db_to_linear(AudioServer.get_bus_volume_db(bus_index))


func _set_master_volume(value: float) -> void:
	var bus_index := AudioServer.get_bus_index("Master")
	if bus_index >= 0:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(maxf(value, 0.001)))
	if is_instance_valid(volume_value_label):
		volume_value_label.text = "%d%%" % roundi(value * 100.0)
	_save_settings()


func _set_fullscreen(enabled: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED)
	_save_settings()


func _load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return
	var volume := float(config.get_value("audio", "master_volume", _get_master_volume()))
	_set_master_volume(volume)
	var fullscreen := bool(config.get_value("display", "fullscreen", false))
	_set_fullscreen(fullscreen)


func _save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "master_volume", _get_master_volume())
	config.set_value("display", "fullscreen", DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	config.save(SETTINGS_PATH)


func _reset_settings() -> void:
	_set_master_volume(1.0)
	_set_fullscreen(false)
	if is_instance_valid(volume_slider):
		volume_slider.value = 1.0
	if is_instance_valid(fullscreen_button):
		fullscreen_button.button_pressed = false


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and popup_layer.visible:
		_hide_popup()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel") and current_page != "main":
		_show_main_page()
		get_viewport().set_input_as_handled()
