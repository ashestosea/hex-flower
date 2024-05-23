class_name HexFlower
extends Node2D

const DIRECTIONS = {
	"stay": Vector3.ZERO,
	"n": Vector3(0, 1, -1),
	"ne": Vector3(1, 0, -1),
	"se": Vector3(1, -1, 0),
	"s": Vector3(0, -1, 1),
	"sw": Vector3(-1, 0, 1),
	"nw": Vector3(-1, 1, 0),
}

const FLOWER_SIZE = 3
const FLOWER_DIAM = (FLOWER_SIZE * 2) - 1

var _current_hex: Hex
var _manager: Manager
var _hex_grid: HexGrid
var _hexes: Array[Hex]

@onready var _hex_scene = load("res://scenes/hexagon.tscn")

func setup(manager: Manager, rows, start_coords: Vector2 = Vector2.ZERO):
	_manager = manager;
	
	_hex_grid = HexGrid.new()
	_hex_grid.set_hex_scale(Vector2(128, 128))
	
	var offset = 2
	for z in rows.size():
		for x in rows[z].size():
			var s = offset - z
			var q
			if z <= offset:
				q = offset - s - x
			else:
				q = offset - x
			var hex_node = _hex_scene.instantiate() as Hex
			_hexes.append(hex_node)
			hex_node.setup(_manager, self, _hex_grid, Vector2(q, s), rows[z][x])
			# hex_node.setup(_manager, self, _hex_grid, Vector2(q, s), "%s, %s" % [q, s])
			# var coords = HexGrid.axial_to_cube_coords(Vector2(q, s))
			# hex_node.setup(_manager, self, _hex_grid, Vector2(q, s), "%s, %s, %s" % [coords.x, coords.y, coords.z])
			add_child(hex_node)
	
	set_current_hex(get_hex(start_coords))


func dir_name(direction: Vector3) -> String:
	for i in DIRECTIONS:
		if DIRECTIONS[i] == direction:
			return i
	return "Unknown Direction"


func wrap_cube(start: Vector3, direction: Vector3) -> Vector3:
	var new_pos = start + direction
	var dir_mask = Vector3.ONE - abs(direction)
	var masked = start * dir_mask
		
	if HexGrid.distance(Vector3.ZERO, new_pos) >= FLOWER_SIZE:
		new_pos += -direction * (FLOWER_DIAM - masked.length())
	
	return new_pos


func set_current_hex(hex: Hex):
	_hexes.map(func (h: Hex): h.unhighlight());
	_current_hex = hex
	_current_hex.highlight()


func traverse(direction: Vector3):
	set_current_hex(get_adjacent(_current_hex, direction))


func get_adjacent(hex: Hex, dir: Vector3) -> Hex:
	var next_hex = wrap_cube(hex._hex_cell.get_cube_coords(), dir)
	return get_hex(next_hex)


func get_hex(coords) -> Hex:
	var cube_coords = HexGrid.obj_to_coords(coords)
	
	var hexes = _hexes.filter(func (x: Hex): return x._hex_cell.get_cube_coords() == cube_coords)
	if hexes == null:
		return null
	else:
		return hexes.front()
