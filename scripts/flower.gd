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

func wrap_axial(from_axial_coords: Vector2, to_axial_coords: Vector2) -> Vector2:
	var result: Vector2
	
	match from_axial_coords:
		Vector2(0, 2):
			match to_axial_coords:
				Vector2(1, 2):
					result = Vector2(-2, 2)
				Vector2(0, 3):
					result = Vector2(0, -2)
				Vector2(-1, 3):
					result = Vector2(2, 0)
			
	return result

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
			var r = offset - z
			var q
			if z <= offset:
				q = offset - r - x
			else:
				q = offset - x
			var hex_node = _hex_scene.instantiate() as Hex
			_hexes.append(hex_node)
			# hex_node.setup(_manager, self, _hex_grid, Vector2(q, r), rows[z][x])
			hex_node.setup(_manager, self, _hex_grid, Vector2(q, r), "%s, %s" % [q, r])
			add_child(hex_node)
	
	set_current_hex(get_hex(start_coords))


func set_current_hex(hex: Hex):
	_hexes.map(func (h: Hex): h.unhighlight());
	_current_hex = hex
	_current_hex.highlight()


func traverse(direction: Vector3):
	set_current_hex(get_adjacent(_current_hex, direction))


func get_adjacent(hex: Hex, dir: Vector3) -> Hex:
	var adjacent_hex_cell: HexCell = hex._hex_cell.get_adjacent(dir)
	return get_hex(adjacent_hex_cell.get_cube_coords())


func get_hex(coords) -> Hex:
	var cube_coords = HexGrid.obj_to_coords(coords)
	
	var hexes = _hexes.filter(func (x: Hex): return x._hex_cell.get_cube_coords() == cube_coords)
	if hexes == null:
		return null
	else:
		return hexes.front()
