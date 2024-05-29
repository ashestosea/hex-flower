class_name HexEdit
extends Node2D

@export var _hexagon: Polygon2D
@export var _collider: CollisionPolygon2D
@export var _anim: AnimationPlayer
@export var _edit_parent: Control
@export var _start_hex_checkbox: CheckBox
@export var _hex_text_edit: TextEdit
@export var _hex_color_edit: LineEdit

var _manager: Manager
var _current_hex: Hex
var _hex_text: String
var _color: Color
var _start_hex: bool

func _on_hex_text_edit_gui_input(event:InputEvent):
	if event.is_action("ui_accept"):
		_hex_text_edit.accept_event()
		_hex_text = _hex_text_edit.text
		if Input.is_key_pressed(KEY_SHIFT):
			submit_edit()
	elif event.is_action("ui_cancel"):
		close()


func _on_color_picker_button_color_changed(color):
	_color = color


func _on_start_hex_check_box_toggled(toggled_on):
	_start_hex = toggled_on


func _on_cancel_button_pressed():
	close()


func _on_ok_button_pressed():
	submit_edit()


func open(manager: Manager, hex: Hex):
	_manager = manager
	_current_hex = hex
	
	position = hex.global_position
	var hex_scale = hex.hex_scale
	
	_hexagon.scale = Vector2(hex_scale / 2, hex_scale / 2)
	_collider.scale = Vector2(hex_scale / 2, hex_scale / 2)
	
	_edit_parent.size.x = hex_scale * 2 * 0.9
	_edit_parent.size.y = hex_scale * 2 * HexUtils.BASE_HEX_SIZE.y * 0.9
	_edit_parent.position = -_edit_parent.size / 2
	_hex_text_edit.text = hex.get_text()
	
	show()
	
	_anim.play("hex_edit")
	var anim_len = _anim.current_animation_length * 0.5
	
	await get_tree().create_timer(anim_len).timeout
	
	_edit_parent.show()
	

func close():
	_anim.play_backwards("hex_edit")
	var anim_len = _anim.current_animation_length
	
	await get_tree().create_timer(anim_len * 0.5).timeout
	
	_edit_parent.hide()
	
	await get_tree().create_timer(anim_len * 0.5).timeout
	
	hide()
	_manager.finish_edit_hex()
	
	
	
func submit_edit():
	_current_hex.set_text(_hex_text)
	_current_hex.set_color(_color)
	_current_hex.set_start_hex(_start_hex)
	close()
