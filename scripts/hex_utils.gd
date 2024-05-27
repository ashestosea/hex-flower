class_name HexUtils
extends Object

const DIR_N = Vector3(0, 1, -1)
const DIR_NE = Vector3(1, 0, -1)
const DIR_SE = Vector3(1, -1, 0)
const DIR_S = Vector3(0, -1, 1)
const DIR_SW = Vector3(-1, 0, 1)
const DIR_NW = Vector3(-1, 1, 0)
const DIR_ALL = [DIR_N, DIR_NE, DIR_SE, DIR_S, DIR_SW, DIR_NW]

const BASE_HEX_SIZE = Vector2(1, sqrt(3)/2)

#var hex_scale: Vector2
#
#var base_hex_size = Vector2(1, sqrt(3)/2)
#var hex_size
#var hex_transform
#var hex_transform_inv


static func obj_to_coords(val) -> HexCoords:
	# Returns suitable cube coordinates for the given object
	# The given object can an be one of:
	# * Vector3 of standard cube coords;
	# * Vector2 of axial coords;
	# Any other type of value will return null
	#
	# NB that offset coords are NOT supported, as they are
	# indistinguishable from axial coords.
	
	if typeof(val) == TYPE_VECTOR3I:
		return HexCoords.new(val.x, val.y, val.z)
	elif typeof(val) == TYPE_VECTOR3:
		return HexCoords.new(int(round(val.x)), int(round(val.y)), int(round(val.z)))
	elif typeof(val) == TYPE_VECTOR2I or typeof(val) == TYPE_VECTOR2I:
		return axial_to_cube_coords(val)
	return


static func axial_to_cube_coords(vec) -> HexCoords:
	# Returns the Vector3 cube coordinates for an axial Vector2
	var x
	var y
	if (typeof(vec) == TYPE_VECTOR2):
		x = int(round(vec.x))
		y = int(round(vec.y))
	else:
		x = vec.x 
		y = vec.y
	return HexCoords.new(x, y, -x - y)


#static func round_coords(val):
	## Rounds floaty coordinate to the nearest whole number cube coords
	#if typeof(val) == TYPE_VECTOR2:
		#val = axial_to_cube_coords(val)
	#
	## Straight round them
	#var rounded = Vector3(round(val.x), round(val.y), round(val.z))
	#
	## But recalculate the one with the largest diff so that x+y+z=0
	#var diffs = (rounded - val).abs()
	#if diffs.x > diffs.y and diffs.x > diffs.z:
		#rounded.x = -rounded.y - rounded.z
	#elif diffs.y > diffs.z:
		#rounded.y = -rounded.x - rounded.z
	#else:
		#rounded.z = -rounded.x - rounded.y
	#
	#return rounded


#func set_hex_scale(scale):
	## We need to recalculate some stuff when projection scale changes
	#hex_scale = scale
	#hex_size = base_hex_size * hex_scale
	#hex_transform = Transform2D(
		#Vector2(hex_size.x * 3/4, -hex_size.y / 2),
		#Vector2(0, -hex_size.y),
		#Vector2(0, 0)
	#)
	#hex_transform_inv = hex_transform.affine_inverse()
	

"""
	Converting between hex-grid and 2D spatial coordinates
"""
static func get_hex_center(coords: HexCoords, hex_scale: Vector2) -> Vector2:
	# Returns hex's centre position on the projection plane
	var hex_size = BASE_HEX_SIZE * hex_scale
	var hex_transform = Transform2D(
		Vector2(hex_size.x * 3/4, -hex_size.y / 2),
		Vector2(0, -hex_size.y),
		Vector2(0, 0)
	)
	return hex_transform * Vector2(coords.q, coords.s)
