class_name Hex
extends Node2D

@export var _hexagon: Polygon2D
@export var _collider: CollisionPolygon2D
@export var _anim: AnimationPlayer
@export var _label: Label
@export var _highlight: Node2D

var cube_coords: Vector3
var _manager
var _barriers: Array[String]


func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).double_click:
			_manager.edit_hex(self)
		elif (event as InputEventMouseButton).pressed:
			if _manager != null:
				_manager.reset_current_hex(self)


func setup(manager: Manager, hex_data: Import.HexData, hex_scale, hex_spacing: float):
	_manager = manager

	cube_coords = HexUtils.axial_to_cube_coords(hex_data.axial_coords)
	position = HexUtils.get_hex_center(cube_coords, hex_spacing)

	set_barriers(hex_data.barriers)

	_hexagon.scale = Vector2(hex_scale / 2, hex_scale / 2)
	_collider.scale = Vector2(hex_scale / 2, hex_scale / 2)

	var text_size = Vector2(hex_scale, hex_scale * HexUtils.BASE_HEX_SIZE.y * 1.9)
	var text_pos = -text_size / 2
	_label.size = text_size
	_label.position = text_pos
	set_text(hex_data.label)


func set_text(text: String):
	_label.text = text
	var font = _label.get_theme_default_font()
	var font_size = _label.get_theme_default_font_size()
	var text_size = font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, _label.size.x, font_size)
	if text_size.x > _label.size.x:
		_label.add_theme_font_size_override("font_size", (_label.size.x / text_size.x) * font_size)


func get_text() -> String:
	return _label.text


func set_color(color: Color):
	_hexagon.color = color


func get_color() -> Color:
	return _hexagon.color


func set_start_hex(is_start: bool):
	pass


func get_start_hex():
	pass


func set_barrier(direction: String, on: bool):
	if on:
		if !_barriers.has(direction):
			_barriers.append(direction)
	else:
		_barriers.erase(direction)


func set_barriers(directions: Array[String]):
	_barriers.clear()
	for b in directions:
		_barriers.append(b)


func get_barriers() -> Array[String]:
	return _barriers
