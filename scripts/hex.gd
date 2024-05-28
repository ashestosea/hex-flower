class_name Hex
extends Node2D

signal hex_selected

var _manager
var _hexagon: Polygon2D
var cube_coords: Vector3

@onready var _label: Label = get_node("Control/Label")
@onready var _text_edit: TextEdit = get_node("Control/TextEdit")

func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).double_click:
			_label.hide();
			_text_edit.show();
			_text_edit.select_all()
			_text_edit.grab_focus()
		elif (event as InputEventMouseButton).pressed:
			if _manager != null:
				_manager.set_current_hex(self)


func setup(manager: Manager, hex_data: Import.HexData, scale: float):
	_manager = manager
	_hexagon = get_node("Hexagon")
	$CollisionShape2D.scale = _hexagon.scale
	cube_coords = HexUtils.axial_to_cube_coords(hex_data.axial_coords)
	position = HexUtils.get_hex_center(cube_coords, scale)
	_label = get_node("Control/Label")
	set_label(hex_data.label)
	_text_edit = get_node("Control/TextEdit") as TextEdit
	_text_edit.text = hex_data.label
	

func set_label(text: String):
	_label.text = text
	var font = _label.get_theme_default_font()
	var font_size = _label.get_theme_default_font_size()
	var text_size = font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, _label.size.x, font_size)
	if text_size.x > _label.size.x:
		_label.add_theme_font_size_override("font_size", (_label.size.x / text_size.x) * font_size)
	

func get_text() -> String:
	return _label.text


func get_hex_scale() -> float:
	if _hexagon == null:
		_hexagon = get_node("Hexagon")
	return _hexagon.scale.x * 2
	

func highlight():
	_hexagon.color = Color.CORAL
	hex_selected.emit()


func unhighlight():
	_hexagon.color = Color.WHITE


func _on_text_edit_gui_input(event:InputEvent):
	if event.is_action("ui_accept"):
		set_label(_text_edit.text)
		_text_edit.accept_event()
		_text_edit.hide()
		_label.show()
	elif event.is_action("ui_cancel"):
		_text_edit.accept_event()
		_text_edit.hide()
		_label.show()


func _on_text_edit_focus_exited():
	set_label(_text_edit.text)
	_text_edit.hide()
	_label.show()
