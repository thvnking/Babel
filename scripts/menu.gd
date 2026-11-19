extends Control

const GAME_SCENE := "res://Game.tscn"
const MENU_ART := "res://image/menu_background.png"
const MENU_PANEL_FRAME := "res://image/menu_panel_frame.png"
const MENU_BUTTON_FRAME := "res://image/menu_button_frame.png"
const TEMP_BACKGROUND := "res://image/event.jpg"

const COLOR_INK := Color("#100d12")
const COLOR_STONE := Color("#19151a")
const COLOR_STONE_LIGHT := Color("#241d22")
const COLOR_BRONZE := Color("#9a7444")
const COLOR_BRONZE_BRIGHT := Color("#c4a16a")
const COLOR_PARCHMENT := Color("#e8dcc3")
const COLOR_MUTED := Color("#a99b88")

var menu_panel: PanelContainer
var settings_panel: PanelContainer
var volume_slider: HSlider
var fullscreen_button: CheckButton


func _ready() -> void:
	_build_menu()


func _build_menu() -> void:
	var background := TextureRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.texture = load(MENU_ART) if ResourceLoader.exists(MENU_ART) else load(TEMP_BACKGROUND)
	background.modulate = Color(0.55, 0.53, 0.54, 1.0)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.025, 0.02, 0.03, 0.58)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)

	var edge_vignette := ColorRect.new()
	edge_vignette.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	edge_vignette.color = Color(0.015, 0.012, 0.018, 0.2)
	edge_vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(edge_vignette)

	var margins := MarginContainer.new()
	margins.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margins.add_theme_constant_override("margin_left", 76)
	margins.add_theme_constant_override("margin_top", 54)
	margins.add_theme_constant_override("margin_right", 76)
	margins.add_theme_constant_override("margin_bottom", 38)
	add_child(margins)

	var columns := HBoxContainer.new()
	columns.add_theme_constant_override("separation", 50)
	margins.add_child(columns)
	columns.add_child(_build_title_column())
	columns.add_child(_build_menu_column())

	var footer := Label.new()
	footer.text = "BẢN THỬ NGHIỆM  ·  18+"
	footer.add_theme_font_size_override("font_size", 13)
	footer.add_theme_color_override("font_color", Color(0.82, 0.75, 0.63, 0.72))
	footer.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	footer.position = Vector2(-270, -28)
	footer.size = Vector2(240, 20)
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	footer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(footer)


func _build_title_column() -> Control:
	var column := VBoxContainer.new()
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 12)

	var overline := _label("HÀNH TRÌNH XUỐNG ĐÁY", 15, COLOR_BRONZE_BRIGHT)
	overline.add_theme_constant_override("outline_size", 2)
	column.add_child(overline)

	var title := _label("BABEL", 86, COLOR_PARCHMENT)
	title.add_theme_constant_override("outline_size", 6)
	title.add_theme_color_override("font_outline_color", Color(0.03, 0.02, 0.025, 0.9))
	title.add_theme_constant_override("letter_spacing", 12)
	column.add_child(title)

	var rule := ColorRect.new()
	rule.color = COLOR_BRONZE
	rule.custom_minimum_size = Vector2(230, 2)
	column.add_child(rule)

	var subtitle := _label("Càng lên cao, càng chìm sâu.", 20, COLOR_PARCHMENT)
	column.add_child(subtitle)

	var description := _label("Một hy vọng mong manh giữa những giáo phái\nvà vực thẳm không đáy.", 16, COLOR_MUTED)
	description.add_theme_constant_override("line_spacing", 5)
	column.add_child(description)

	return column


func _build_menu_column() -> Control:
	var stack := VBoxContainer.new()
	stack.custom_minimum_size = Vector2(410, 0)
	stack.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stack.alignment = BoxContainer.ALIGNMENT_CENTER

	var center := CenterContainer.new()
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stack.add_child(center)

	menu_panel = _new_panel()
	menu_panel.custom_minimum_size = Vector2(410, 432)
	center.add_child(menu_panel)
	_build_main_menu_contents()

	settings_panel = _new_panel()
	settings_panel.custom_minimum_size = Vector2(410, 432)
	settings_panel.visible = false
	center.add_child(settings_panel)
	_build_settings_contents()

	return stack


func _build_main_menu_contents() -> void:
	var body := _panel_body(menu_panel)
	_add_section_title(body, "BẮT ĐẦU HÀNH TRÌNH")
	_add_spacer(body, 18)
	_add_menu_button(body, "BẮT ĐẦU MỚI", "Bắt đầu một hành trình tại Babel", _start_new_game)
	_add_menu_button(body, "TIẾP TỤC", "Chưa có hành trình đã lưu", Callable(), true)
	_add_menu_button(body, "CÀI ĐẶT", "Âm lượng và hiển thị", _show_settings)
	_add_spacer(body, 10)
	_add_menu_button(body, "THOÁT", "Đóng trò chơi", _quit_game, false, true)


func _build_settings_contents() -> void:
	var body := _panel_body(settings_panel)
	_add_section_title(body, "CÀI ĐẶT")
	_add_spacer(body, 22)

	var volume_label := _label("ÂM LƯỢNG CHUNG", 14, COLOR_PARCHMENT)
	body.add_child(volume_label)
	volume_slider = HSlider.new()
	volume_slider.min_value = 0.0
	volume_slider.max_value = 1.0
	volume_slider.step = 0.01
	volume_slider.value = _get_master_volume()
	volume_slider.custom_minimum_size = Vector2(0, 28)
	volume_slider.value_changed.connect(_set_master_volume)
	body.add_child(volume_slider)

	fullscreen_button = CheckButton.new()
	fullscreen_button.text = "Toàn màn hình"
	fullscreen_button.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	fullscreen_button.add_theme_color_override("font_color", COLOR_PARCHMENT)
	fullscreen_button.toggled.connect(_set_fullscreen)
	body.add_child(fullscreen_button)

	_add_spacer(body, 30)
	_add_menu_button(body, "QUAY LẠI", "Trở về menu chính", _show_main_menu)


func _new_panel() -> PanelContainer:
	var panel := PanelContainer.new()
	var style: StyleBox = _panel_style()
	if ResourceLoader.exists(MENU_PANEL_FRAME):
		style = _nine_patch_style(MENU_PANEL_FRAME, 120, 120, 28)
	panel.add_theme_stylebox_override("panel", style)
	return panel


func _panel_body(panel: PanelContainer) -> VBoxContainer:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_top", 27)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_bottom", 27)
	panel.add_child(margin)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 10)
	margin.add_child(body)
	return body


func _add_section_title(parent: VBoxContainer, text: String) -> void:
	var title := _label(text, 19, COLOR_BRONZE_BRIGHT)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(title)
	var divider := ColorRect.new()
	divider.color = Color(COLOR_BRONZE, 0.72)
	divider.custom_minimum_size = Vector2(0, 1)
	parent.add_child(divider)


func _add_menu_button(parent: VBoxContainer, title: String, description: String, action: Callable, disabled := false, quiet := false) -> void:
	var button := Button.new()
	button.custom_minimum_size = Vector2(0, 62)
	button.disabled = disabled
	button.focus_mode = Control.FOCUS_ALL
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.add_theme_stylebox_override("normal", _button_style(quiet, false))
	button.add_theme_stylebox_override("hover", _button_style(quiet, true))
	button.add_theme_stylebox_override("pressed", _button_style(quiet, false, true))
	button.add_theme_stylebox_override("disabled", _button_style(quiet, false, false, true))
	button.add_theme_color_override("font_color", COLOR_PARCHMENT)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_disabled_color", Color("#786e65"))
	button.add_theme_font_size_override("font_size", 16)
	button.text = "  " + title + "\n  " + description
	parent.add_child(button)
	if action.is_valid():
		button.pressed.connect(action)


func _add_spacer(parent: VBoxContainer, height: float) -> void:
	var spacer := Control.new()
	spacer.custom_minimum_size.y = height
	parent.add_child(spacer)


func _label(text: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label


func _panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(COLOR_STONE, 0.94)
	style.border_color = COLOR_BRONZE
	style.set_border_width_all(2)
	style.set_corner_radius_all(4)
	style.content_margin_left = 2
	style.content_margin_top = 2
	style.content_margin_right = 2
	style.content_margin_bottom = 2
	style.shadow_color = Color(0, 0, 0, 0.48)
	style.shadow_size = 18
	style.shadow_offset = Vector2(0, 8)
	return style


func _button_style(quiet: bool, hovered: bool, pressed := false, disabled := false) -> StyleBox:
	if ResourceLoader.exists(MENU_BUTTON_FRAME):
		var image_style := _nine_patch_style(MENU_BUTTON_FRAME, 120, 64, 10)
		image_style.modulate_color = Color("#aaa49b") if disabled else Color("#d3bd95") if hovered else Color("#ffffff")
		return image_style

	var style := StyleBoxFlat.new()
	style.bg_color = Color(COLOR_STONE_LIGHT, 0.92) if hovered else Color(COLOR_INK, 0.68)
	if pressed:
		style.bg_color = Color("#100d10")
	if disabled:
		style.bg_color = Color("#171418")
	style.border_color = Color(COLOR_BRONZE_BRIGHT, 0.95) if hovered else Color(COLOR_BRONZE, 0.65)
	if quiet:
		style.border_color = Color(COLOR_BRONZE, 0.32)
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.content_margin_left = 14
	style.content_margin_top = 6
	style.content_margin_right = 12
	style.content_margin_bottom = 6
	return style


func _nine_patch_style(path: String, horizontal_margin: float, vertical_margin: float, inset: float) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = load(path)
	style.texture_margin_left = horizontal_margin
	style.texture_margin_right = horizontal_margin
	style.texture_margin_top = vertical_margin
	style.texture_margin_bottom = vertical_margin
	style.content_margin_left = inset
	style.content_margin_right = inset
	style.content_margin_top = inset
	style.content_margin_bottom = inset
	return style


func _show_settings() -> void:
	menu_panel.visible = false
	settings_panel.visible = true


func _show_main_menu() -> void:
	settings_panel.visible = false
	menu_panel.visible = true


func _start_new_game() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)


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


func _set_fullscreen(enabled: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED)
