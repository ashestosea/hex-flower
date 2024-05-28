class_name HexFlower
extends Control

const DIRECTIONS = {
	"stay": Vector3.ZERO,
	"n": Vector3(0, -1, 1),
	"ne": Vector3(1, -1, 0),
	"se": Vector3(1, 0, -1),
	"s": Vector3(0, 1, -1),
	"sw": Vector3(-1, 1, 0),
	"nw": Vector3(-1, 0, 1),
}

const DEBUG_COORDS: bool = false
const FLOWER_SIZE: int = 3
const FLOWER_DIAM: int = (FLOWER_SIZE * 2) - 1
const HEX_SCALE: float = 128

var _current_hex: Hex
var _manager: Manager
var _hexes: Array[Hex]

@onready var _hex_scene = load("res://scenes/hex.tscn")

func setup(manager: Manager, hexes: Array[Import.HexData], start_coords: Vector2 = Vector2.ZERO):
	_manager = manager;
	
	for hex in hexes:
		var hex_node = _hex_scene.instantiate() as Hex
		_hexes.append(hex_node)
		var coords = HexUtils.axial_to_cube_coords(hex.axial_coords)
		var label: String = hex.label if !DEBUG_COORDS else "%s, %s, %s" % [coords.x, coords.y, coords.z]
		hex_node.setup(_manager, hex, HEX_SCALE)
		add_child(hex_node)
	
	set_current_hex(get_hex(start_coords))


func dir_name(direction: Vector3) -> String:
	for i in DIRECTIONS:
		if DIRECTIONS[i] == direction:
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
	_hexes.map(func (h: Hex): h.unhighlight());
	_current_hex = hex
	_current_hex.move_to_front()
	_current_hex.highlight()


func traverse(direction: Vector3) -> String:
	var new_hex = get_adjacent(_current_hex, direction)
	set_current_hex(new_hex)
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
