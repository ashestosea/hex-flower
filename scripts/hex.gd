class_name Hex
extends Node2D

signal hex_selected

var _manager
var _hex_grid: HexGrid
var _hex_cell: HexCell
@onready var _label: Label = get_node("Control/Label")
@onready var _text_edit: TextEdit = get_node("Control/TextEdit")
@onready var _hexagon: Polygon2D = get_node("Hexagon")

func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).double_click:
			_label.visible = false;
			_text_edit.visible = true;
			_text_edit.select_all()
			_text_edit.grab_focus()
		elif (event as InputEventMouseButton).pressed:
			if _manager != null:
				_manager.set_current_hex(self)


func setup(manager: Manager, hex_grid: HexGrid, hex_pos: Vector2, text: String):
	_manager = manager
	_hex_grid = hex_grid
	_hex_cell = HexCell.new(hex_pos)
	position = _hex_grid.get_hex_center(_hex_cell)
	_label = get_node("Control/Label")
	set_label(text)
	_text_edit = get_node("Control/TextEdit") as TextEdit
	_text_edit.text = text
	

func set_label(text: String):
	_label.text = text
	var font = _label.get_theme_default_font()
	var font_size = _label.get_theme_default_font_size()
	var text_size = font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, _label.size.x, font_size)
	if text_size.x > _label.size.x:
		_label.add_theme_font_size_override("font_size", (_label.size.x / text_size.x) * font_size)
	

func get_text() -> String:
	return _label.text


func highlight():
	_hexagon.color = Color.CORAL
	hex_selected.emit()


func unhighlight():
	_hexagon.color = Color.WHITE


func _on_text_edit_gui_input(event:InputEvent):
	if event.is_action("ui_accept"):
		set_label(_text_edit.text)
		_text_edit.accept_event()
		_text_edit.visible = false
		_label.visible = true
	elif event.is_action("ui_cancel"):
		_text_edit.accept_event()
		_text_edit.visible = false
		_label.visible = true


func _on_text_edit_focus_exited():
	set_label(_text_edit.text)
	_text_edit.visible = false
	_label.visible = true
