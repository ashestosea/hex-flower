class_name HexCoords
extends Object

var q: int
var s: int
var r: int

func _init(in_q: int, in_s: int, in_r: int):
	q = in_q
	s = in_s
	r = in_r


static func from_vec2i(vec: Vector2i):
	var cube_coords = HexUtils.obj_to_coords(vec)
	return HexCoords.new(cube_coords.q, cube_coords.s, cube_coords.r)

	
static func from_vec3i(vec: Vector3i):
	return HexCoords.new(vec.x, vec.y, vec.z)
	

func to_vec3():
	return Vector3(q, s, r)


func eq(other: HexCoords):
	if other == null:
		return false
		
	return q == other.q and s == other.s and r == other.r
