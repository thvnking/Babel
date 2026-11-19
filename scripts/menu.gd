extends Control

const GAME_SCENE := "res://Game.tscn"
const MENU_ART := "res://image/menu_background.png"
const TEMP_BACKGROUND := "res://image/event.jpg"

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
var volume_slider: HSlider
var fullscreen_button: CheckButton
var menu_buttons: Array[Button] = []
var selected_index := 0
var current_page := "main"


func _ready() -> void:
	_build_menu()
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
	sidebar.anchor_right = SIDEBAR_WIDTH_RATIO
	sidebar.anchor_bottom = 1.0
	sidebar.color = Color(COLOR_INK, 0.96)
	sidebar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sidebar)

	var sidebar_edge := ColorRect.new()
	sidebar_edge.anchor_left = SIDEBAR_WIDTH_RATIO
	sidebar_edge.anchor_right = SIDEBAR_WIDTH_RATIO
	sidebar_edge.anchor_bottom = 1.0
	sidebar_edge.offset_left = -1
	sidebar_edge.offset_right = 1
	sidebar_edge.color = Color(COLOR_BRONZE, 0.76)
	sidebar_edge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sidebar_edge)

	var margins := MarginContainer.new()
	margins.anchor_right = SIDEBAR_WIDTH_RATIO
	margins.anchor_bottom = 1.0
	margins.add_theme_constant_override("margin_left", 32)
	margins.add_theme_constant_override("margin_top", 38)
	margins.add_theme_constant_override("margin_right", 30)
	margins.add_theme_constant_override("margin_bottom", 28)
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
	controls_hint.anchor_left = SIDEBAR_WIDTH_RATIO
	controls_hint.offset_top = -42
	controls_hint.offset_bottom = -14
	controls_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	controls_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(controls_hint)


func _build_sidebar_header() -> void:
	var title := _label("BABEL", 50, COLOR_PARCHMENT)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_constant_override("outline_size", 4)
	title.add_theme_color_override("font_outline_color", Color(0.02, 0.015, 0.02, 0.9))
	title.add_theme_constant_override("letter_spacing", 7)
	sidebar_content.add_child(title)

	var overline := _label("DESCENT INTO THE ABYSS", 10, COLOR_BRONZE_BRIGHT)
	overline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overline.add_theme_constant_override("letter_spacing", 2)
	sidebar_content.add_child(overline)

	var subtitle := _label("Càng lên cao, càng chìm sâu.", 12, COLOR_MUTED)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.custom_minimum_size.y = 25
	sidebar_content.add_child(subtitle)

	var top_space := Control.new()
	top_space.custom_minimum_size.y = 46
	sidebar_content.add_child(top_space)

	var section_title := _label("HÀNH TRÌNH", 13, COLOR_BRONZE_BRIGHT)
	section_title.add_theme_constant_override("letter_spacing", 2)
	sidebar_content.add_child(section_title)

	var divider := ColorRect.new()
	divider.color = Color(COLOR_BRONZE, 0.62)
	divider.custom_minimum_size = Vector2(0, 1)
	sidebar_content.add_child(divider)

	var section_space := Control.new()
	section_space.custom_minimum_size.y = 16
	sidebar_content.add_child(section_space)


func _show_main_page() -> void:
	current_page = "main"
	_clear_page()
	menu_buttons.clear()
	_add_menu_item("Tiếp tục", "Chưa có hành trình đã lưu", Callable(), true)
	_add_menu_item("Bắt đầu mới", "", _start_new_game)
	_add_menu_item("Tải hành trình", "Chưa có dữ liệu lưu", Callable(), true)
	_add_menu_item("Cài đặt", "", _show_settings_page)
	_add_menu_item("Credits", "", _show_credits_page)
	_add_menu_item("Thoát", "", _quit_game)
	selected_index = 1
	_update_menu_item_styles()
	menu_buttons[selected_index].grab_focus()


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
	fullscreen_button = CheckButton.new()
	fullscreen_button.text = "Toàn màn hình"
	fullscreen_button.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	fullscreen_button.add_theme_color_override("font_color", COLOR_PARCHMENT)
	fullscreen_button.add_theme_color_override("font_hover_color", Color.WHITE)
	fullscreen_button.toggled.connect(_set_fullscreen)
	page_content.add_child(fullscreen_button)
	_add_small_gap(20)
	_add_menu_item("Quay lại", "", _show_main_page)
	menu_buttons[0].grab_focus()


func _show_credits_page() -> void:
	current_page = "credits"
	_clear_page()
	_add_page_heading("CREDITS")
	_add_small_gap(20)
	page_content.add_child(_label("BABEL", 23, COLOR_PARCHMENT))
	page_content.add_child(_label("Một hành trình xuống vực sâu.", 13, COLOR_MUTED))
	_add_small_gap(26)
	_add_menu_item("Quay lại", "", _show_main_page)
	menu_buttons[0].grab_focus()


func _add_page_heading(text: String) -> void:
	var heading := _label(text, 13, COLOR_BRONZE_BRIGHT)
	heading.add_theme_constant_override("letter_spacing", 2)
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
	button.custom_minimum_size = Vector2(0, 42 if description.is_empty() else 54)
	button.disabled = disabled
	button.focus_mode = Control.FOCUS_ALL
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.add_theme_stylebox_override("normal", _item_style(false))
	button.add_theme_stylebox_override("hover", _item_style(true))
	button.add_theme_stylebox_override("focus", _item_style(true))
	button.add_theme_stylebox_override("pressed", _item_style(true, true))
	button.add_theme_stylebox_override("disabled", _item_style(false, false, true))
	button.add_theme_color_override("font_color", COLOR_PARCHMENT)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_focus_color", Color.WHITE)
	button.add_theme_color_override("font_disabled_color", Color("#756d65"))
	button.add_theme_font_size_override("font_size", 17)
	button.text = title if description.is_empty() else "%s\n  %s" % [title, description]
	var item_index := menu_buttons.size()
	menu_buttons.append(button)
	button.mouse_entered.connect(_on_item_hovered.bind(item_index))
	button.pressed.connect(_on_menu_item_pressed.bind(item_index, action))
	page_content.add_child(button)


func _on_item_hovered(index: int) -> void:
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
		button.add_theme_stylebox_override("normal", _item_style(selected))
		button.add_theme_stylebox_override("hover", _item_style(true))
		button.add_theme_stylebox_override("focus", _item_style(true))
		button.add_theme_stylebox_override("pressed", _item_style(true, true))
		button.add_theme_stylebox_override("disabled", _item_style(false, false, true))


func _item_style(selected: bool, pressed := false, disabled := false) -> StyleBoxFlat:
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
	for child in page_content.get_children():
		page_content.remove_child(child)
		child.queue_free()


func _label(text: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label


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


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and current_page != "main":
		_show_main_page()
		get_viewport().set_input_as_handled()
