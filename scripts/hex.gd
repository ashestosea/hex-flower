class_name Hex
extends Node2D

@export var _hexagon: Polygon2D
@export var _collider: CollisionPolygon2D
@export var _label: Label

var cube_coords: Vector3
var _manager: Manager
var _is_start: bool
var _barriers: Array[String]

func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event is InputEventMouseButton:
		if (OS.get_name() == "Android" or OS.get_name() == "iOS"):
			if (event as InputEventMouseButton).button_index == 2:
				_manager.edit_hex(self)
			elif (event as InputEventMouseButton).pressed:
				if _manager != null:
					_manager.reset_current_hex(self)
		else:
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

	var half_hex = hex_scale * 0.5
	_hexagon.scale = Vector2(half_hex, half_hex)
	_collider.scale = Vector2(half_hex, half_hex)

	var text_size = Vector2(hex_scale * 0.75, hex_scale * HexUtils.BASE_HEX_SIZE.y * 0.95)
	var text_pos = -text_size * 0.5
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
	var lum = (0.299 * color.r + 0.587 * color.g + 0.144 * color.b)
	var val = 0 if lum > 0.5 else 1
	_label.add_theme_color_override("font_color", Color(val, val, val))


func get_color() -> Color:
	return _hexagon.color


func set_start_hex(is_start: bool):
	_is_start = is_start


func get_start_hex():
	return _is_start


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
