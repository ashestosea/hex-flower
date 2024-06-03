class_name HexEdit
extends Node2D

signal finished

@export var _hexagon: Hexagon
@export var _anim: AnimationPlayer
@export var _edit_parent: Control
@export var _start_hex_checkbox: CheckBox
@export var _hex_text_edit: TextEdit
@export var _hex_color_button: ColorPickerButton
@export var _barriers_parent: Control
@export var _barriers_stay: CheckButton
@export var _barriers_n: CheckButton
@export var _barriers_ne: CheckButton
@export var _barriers_se: CheckButton
@export var _barriers_s: CheckButton
@export var _barriers_sw: CheckButton
@export var _barriers_nw: CheckButton

var _current_hex: Hex
var _hex_text: String
var _color: Color
var _start_hex: bool
var _barriers: Array[String]
var _do_snap_pos: bool
var _snap_target_pos: Vector2
var _speed = 25

func _on_hex_text_edit_gui_input(event:InputEvent):
	if event.is_action("ui_accept"):
		_hex_text_edit.accept_event()
		_hex_text = _hex_text_edit.text
		if Input.is_key_pressed(KEY_SHIFT):
			submit_edit()
	elif event.is_action("ui_cancel"):
		finished.emit()


func _on_color_picker_button_color_changed(color):
	_color = color


func _on_start_hex_check_box_toggled(toggled_on):
	_start_hex = toggled_on


func _on_barrier_stay_toggled(toggled_on):
	set_barrier("stay", toggled_on)


func _on_barrier_n_toggled(toggled_on):
	set_barrier("n", toggled_on)


func _on_barrier_ne_toggled(toggled_on):
	set_barrier("ne", toggled_on)


func _on_barrier_se_toggled(toggled_on):
	set_barrier("se", toggled_on)


func _on_barrier_s_toggled(toggled_on):
	set_barrier("s", toggled_on)


func _on_barrier_sw_toggled(toggled_on):
	set_barrier("sw", toggled_on)


func _on_barrier_nw_toggled(toggled_on):
	set_barrier("nw", toggled_on)


func _on_cancel_button_pressed():
	finished.emit()


func _on_ok_button_pressed():
	submit_edit()

func _process(delta):
	if _do_snap_pos:
		if global_position.is_equal_approx(_snap_target_pos):
			_do_snap_pos = false
			global_position = _snap_target_pos
		else:
			global_position += (_snap_target_pos - global_position) * (1 - exp(-_speed * delta));


func open(hex: Hex, flower: HexFlower):
	_current_hex = hex

	position = hex.global_position
	var hex_scale = HexFlower.hex_scale

	_hexagon.draw_scale = hex_scale / 2

	set_barriers(hex.get_barriers())

	_hex_text_edit.text = hex.get_text()

	_hex_color_button.color = hex.get_color()

	var size = Vector2(hex_scale * 2, hex_scale * 2 * HexUtils.BASE_HEX_SIZE.y)
	_edit_parent.size = size * 0.9
	_edit_parent.position = -_edit_parent.size / 2
	_barriers_parent.size = size
	_barriers_parent.position = -_barriers_parent.size / 2

	show()

	_anim.play("hex_edit_open")
	_do_snap_pos = true
	_snap_target_pos = flower.global_position
	var anim_len = _anim.current_animation_length * 0.5

	await get_tree().create_timer(anim_len).timeout

	_edit_parent.show()
	_barriers_parent.show()



func start_close(hex: Hex) -> float:
	_anim.play("hex_edit_close")
	_do_snap_pos = true
	_snap_target_pos = hex.global_position
	_edit_parent.hide()
	_barriers_parent.hide()
	return _anim.current_animation_length


func submit_edit():
	_current_hex.set_text(_hex_text)
	_current_hex.set_color(_color)
	_current_hex.set_start_hex(_start_hex)
	_current_hex.set_barriers(_barriers)
	finished.emit()


func set_barrier(direction: String, on: bool):
	if on:
		if !_barriers.has(direction):
			_barriers.append(direction)
	else:
		_barriers.erase(direction)

	match direction.to_lower():
		"stay":
			_barriers_stay.button_pressed = on
		"n":
			_barriers_n.button_pressed = on
		"ne":
			_barriers_ne.button_pressed = on
		"se":
			_barriers_se.button_pressed = on
		"s":
			_barriers_s.button_pressed = on
		"sw":
			_barriers_sw.button_pressed = on
		"nw":
			_barriers_nw.button_pressed = on


func set_barriers(directions: Array[String]):
	_barriers_stay.button_pressed = false
	_barriers_n.button_pressed = false
	_barriers_ne.button_pressed = false
	_barriers_se.button_pressed = false
	_barriers_s.button_pressed = false
	_barriers_sw.button_pressed = false
	_barriers_nw.button_pressed = false
	for b in directions:
		set_barrier(b, true)


func get_barriers() -> Array[String]:
	return _barriers
