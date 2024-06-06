class_name HexFlower
extends Control

const DEBUG_COORDS: bool = false
const FLOWER_SIZE: int = 3
const FLOWER_DIAM: int = (FLOWER_SIZE * 2) - 1

static var hex_scale = 160
static var hex_spacing = 180

@export var hex_highlight: Node2D

var _current_hex: Hex
var _manager: Manager
var _hexes: Array[Hex]
var _hex_scene: PackedScene

func setup(manager: Manager, hexes: Array[Import.HexData], start_coords: Vector2 = Vector2.ZERO):
	_manager = manager;

	_hex_scene = load("res://scenes/hex.tscn")
	for hex in hexes:
		var hex_node = _hex_scene.instantiate() as Hex
		_hexes.append(hex_node)
		hex_node.setup(_manager, hex, hex_scale, hex_spacing)
		add_child(hex_node)

	hex_highlight.scale = Vector2.ONE * 0.5 * hex_scale * 1.05

	set_current_hex(get_hex(start_coords))


func dir_name(direction: Vector3) -> String:
	for i in HexUtils.DIRECTIONS:
		if HexUtils.DIRECTIONS[i] == direction:
			return i
	return "Unknown Direction"


func wrap_cube(start: Vector3, direction: Vector3) -> Vector3:
	var new_pos: Vector3 = start + direction
	var dir_mask: Vector3 = Vector3.ONE - abs(direction)
	var masked: Vector3 = start * dir_mask

	if HexUtils.distance(Vector3.ZERO, new_pos) >= FLOWER_SIZE:
		new_pos += -direction * (FLOWER_DIAM - masked.length())

	return new_pos


func set_current_hex(hex: Hex):
	_current_hex = hex
	hex_highlight.position = hex.position


func show_current_hex():
	if _current_hex:
		_current_hex.show()
		_current_hex._label.show()


func traverse(direction: Vector3) -> String:
	var new_hex = get_adjacent(_current_hex, direction)
	set_current_hex(new_hex)
	_manager.set_current_hex(new_hex)
	return new_hex.get_text()


func get_adjacent(hex: Hex, dir: Vector3) -> Hex:
	var next_hex = wrap_cube(hex.cube_coords, dir)
	return get_hex(next_hex)


func get_hex(coords) -> Hex:
	var cube_coords = HexUtils.obj_to_coords(coords)

	var hexes = _hexes.filter(func (hex: Hex): return hex.cube_coords == cube_coords)
	if hexes == null:
		return null
	else:
		return hexes.front()
