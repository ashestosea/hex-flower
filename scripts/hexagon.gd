@tool
class_name Hexagon
extends Control

@export var draw_scale: float = 120:
	get:
		return draw_scale
	set(value):
		draw_scale = value
		adjust()
		queue_redraw()

var coords_hex: Array = [
	[-1.0, 0.0],
	[-0.5, -0.866],
	[0.5, -0.866],
	[1.0, 0.0],
	[0.5, 0.866],
	[-0.5, 0.866]
]

var hex : PackedVector2Array

func _ready():
	adjust()


func _draw():
	draw_polygon(hex, [Color.WHITE])


func adjust():
	hex = float_array_to_Vector2Array(coords_hex)


func float_array_to_Vector2Array(coords : Array) -> PackedVector2Array:
	var array : PackedVector2Array = []
	for coord in coords:
		array.append(Vector2(coord[0] * draw_scale, coord[1] * draw_scale))
	return array
