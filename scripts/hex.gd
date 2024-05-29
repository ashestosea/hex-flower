class_name Hex
extends Node2D

signal hex_selected

@export var _hexagon: Polygon2D
@export var _collider: CollisionPolygon2D
@export var _anim: AnimationPlayer
@export var _edit_parent: Control
@export var _label: Label
@export var _text_edit: TextEdit
@export var hex_scale: float = 180

var cube_coords: Vector3
var _manager


func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).double_click:
			show_edit()
		elif (event as InputEventMouseButton).pressed:
			if _manager != null:
				_manager.set_current_hex(self)


func _on_text_edit_gui_input(event:InputEvent):
	if event.is_action("ui_accept"):
		_text_edit.accept_event()
		submit_edit()
	elif event.is_action("ui_cancel"):
		hide_edit()


func setup(manager: Manager, hex_data: Import.HexData, scale: float):
	_manager = manager
	
	cube_coords = HexUtils.axial_to_cube_coords(hex_data.axial_coords)
	position = HexUtils.get_hex_center(cube_coords, scale)
	
	_hexagon.scale = Vector2(hex_scale / 2, hex_scale / 2)
	
	_collider.scale = Vector2(hex_scale / 2, hex_scale / 2)
	
	var text_size = Vector2(hex_scale * HexUtils.BASE_HEX_SIZE.x,
							hex_scale * HexUtils.BASE_HEX_SIZE.y * 1.9)
	var text_pos = -text_size / 2
	_label.size = text_size
	_label.position = text_pos
	set_label(hex_data.label)
	
	
func submit_edit():
	set_label(_text_edit.text)
	hide_edit()
	

func show_edit():
	_anim.play("hex_edit")
	var anim_len = _anim.current_animation_length * 0.5
	
	await get_tree().create_timer(anim_len).timeout
	
	_label.hide();
	_text_edit.text = _label.text
	_edit_parent.show()
	
	
func hide_edit():
	_anim.play_backwards("hex_edit")
	_text_edit.accept_event()
	_edit_parent.hide()
	_label.show()
	

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

