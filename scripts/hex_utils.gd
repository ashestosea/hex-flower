class_name HexUtils
extends Object

const BASE_HEX_SIZE = Vector2(1, sqrt(3)/2)
const DIRECTIONS = {
	"stay": Vector3.ZERO,
	"n": Vector3(0, -1, 1),
	"ne": Vector3(1, -1, 0),
	"se": Vector3(1, 0, -1),
	"s": Vector3(0, 1, -1),
	"sw": Vector3(-1, 1, 0),
	"nw": Vector3(-1, 0, 1),
}

static func obj_to_coords(val) -> Vector3:
	if typeof(val) == TYPE_VECTOR3:
		return val
	elif typeof(val) == TYPE_VECTOR2:
		return axial_to_cube_coords(val)

	return Vector3.INF


static func axial_to_cube_coords(vec: Vector2) -> Vector3:
	return Vector3(vec.x, vec.y, -vec.x - vec.y)


static func distance(start, end):
	start = HexUtils.obj_to_coords(start)
	end = HexUtils.obj_to_coords(end)
	return int((
			abs(start.x - end.x)
			+ abs(start.y - end.y)
			+ abs(start.z - end.z)
			) / 2)


static func get_hex_center(coords: Vector3, hex_scale: float) -> Vector2:
	var hex_size = BASE_HEX_SIZE * hex_scale
	var hex_transform = Transform2D(
		Vector2(hex_size.x * 0.75, hex_size.y / 2),
		Vector2(0, hex_size.y),
		Vector2(0, 0)
	)
	return hex_transform * Vector2(coords.x, coords.y)
