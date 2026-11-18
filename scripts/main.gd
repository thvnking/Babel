extends Control

# Giao diện prototype tối giản: thông tin chỉ hiện khi cần trong chiến đấu.
const ROOM_NAMES := ["Quái vật", "Bẫy", "Cầu nguyện", "Dịch chuyển", "Sự kiện", "Lửa trại"]
const ROOM_COLORS := [Color("#b6313b"), Color("#d59a25"), Color("#8752b7"), Color("#2879a5"), Color("#4d9871"), Color("#d36a32")]
const ROOM_BACKGROUNDS := ["res://image/monster.jpg", "res://image/trap.jpg", "res://image/pray.jpg", "res://image/teleport.jpg", "res://image/event.jpg", "res://image/bonfire.jpg"]
const ENEMIES := [{"name": "Chuột Hang", "hp": 2, "attack": 0}, {"name": "Nhện Đá", "hp": 3, "attack": 1}, {"name": "Kẻ Đào Mộ", "hp": 4, "attack": 1}, {"name": "Quỷ Lùn", "hp": 5, "attack": 2}, {"name": "Hiệp Sĩ Rỗng", "hp": 6, "attack": 3}, {"name": "Quái Vật Tổ", "hp": 6, "attack": 3}]

var rng := RandomNumberGenerator.new()
var player_hp := 5
var max_player_hp := 5
var mind := 0
var weapon_die := 4
var current_room := -1
var current_enemy: Dictionary = {}
var enemy_hp := 0
var combat_active := false
var bonfire_used := false
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


func _ready() -> void:
	rng.randomize()
	_build_ui()
	_show_idle_state()


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
	enemy_sprite.texture = load("res://image/monster-d1.png")
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


func _build_player_portrait() -> void:
	var portrait_shell := PanelContainer.new()
	portrait_shell.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	portrait_shell.position = Vector2(26, -170)
	portrait_shell.size = Vector2(126, 126)
	portrait_shell.add_theme_stylebox_override("panel", _stylebox(Color("#141925f0"), Color("#e7d2a5"), 3, 80))
	add_child(portrait_shell)
	avatar = TextureRect.new()
	avatar.texture = load("res://image/avatar.jpg")
	avatar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	avatar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	avatar.custom_minimum_size = Vector2(108, 108)
	avatar.material = _round_mask_material()
	portrait_shell.add_child(avatar)
	mind_ring = _label("MIND 0", 11, "#e6d9ff")
	mind_ring.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	mind_ring.position = Vector2(48, -37)
	mind_ring.size = Vector2(84, 20)
	mind_ring.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(mind_ring)
	hp_fill = ProgressBar.new()
	hp_fill.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	hp_fill.position = Vector2(28, -22)
	hp_fill.size = Vector2(122, 10)
	hp_fill.max_value = max_player_hp
	hp_fill.show_percentage = false
	hp_fill.add_theme_stylebox_override("background", _stylebox(Color("#241821e8"), Color("#6d3138"), 1, 6))
	hp_fill.add_theme_stylebox_override("fill", _stylebox(Color("#cf3945"), Color("#ff8389"), 1, 6))
	add_child(hp_fill)


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


func _on_move_pressed() -> void:
	if run_over:
		_reset_run()
	elif combat_active:
		_combat_turn()
	elif current_room == 5 and not bonfire_used:
		_use_bonfire()
	else:
		_roll_movement()


func _roll_movement() -> void:
	var roll := rng.randi_range(1, 6)
	current_room = roll - 1
	bonfire_used = false
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
			mind += rng.randi_range(-1, 2)
			_update_portrait()
			room_hint.text = "CẦU NGUYỆN · Mind thay đổi"
			move_label.text = "CẦU\nNGUYỆN"
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
	current_enemy["hp"] = rng.randi_range(1, 6)
	current_enemy["attack"] = rng.randi_range(0, 3)
	enemy_hp = int(current_enemy["hp"])
	combat_active = true
	enemy_sprite.visible = true
	combat_panel.visible = true
	combat_text.text = "%s  ·  %d HP" % [current_enemy["name"], enemy_hp]
	roll_text.text = "Tấn công +%d  ·  Dao găm D%d" % [current_enemy["attack"], weapon_die]
	room_hint.text = "Gặp quái · Bấm nút đỏ để tấn công"
	move_label.text = "TẤN\nCÔNG"


func _combat_turn() -> void:
	var player_roll := rng.randi_range(1, weapon_die)
	var enemy_roll: int = rng.randi_range(1, 6) + int(current_enemy["attack"])
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
		player_hp -= 1
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


func _show_idle_state() -> void:
	background.texture = load("res://image/event.jpg")
	background.modulate = Color(0.55, 0.55, 0.62, 1.0)
	room_hint.text = "Bấm vòng tròn để tung D6 di chuyển"
	combat_panel.visible = false
	move_label.text = "DI\nCHUYỂN"
	_update_portrait()


func _update_portrait() -> void:
	hp_fill.value = player_hp
	mind_ring.text = "MIND %d" % mind
	if mind < 0:
		avatar.modulate = Color("#a8799e")
	elif mind > 0:
		avatar.modulate = Color("#a787d9")
	else:
		avatar.modulate = Color.WHITE


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
