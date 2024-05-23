class_name Hex
extends Node2D

signal hex_selected

var _manager
var _hex_flower: HexFlower
var _hex_grid: HexGrid
var _hex_cell: HexCell
var _label: Label
@onready var _hexagon: Polygon2D = get_node("Hexagon")

func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event.is_action("ui_touch"):
		_hex_flower.set_current_hex(self)


func setup(manager: Manager, hex_flower: HexFlower, hex_grid: HexGrid, hex_pos: Vector2, text: String):
	_manager = manager
	_hex_flower = hex_flower
	_hex_grid = hex_grid
	_hex_cell = HexCell.new(hex_pos)
	position = _hex_grid.get_hex_center(_hex_cell)
	_label = get_node("Label")
	_label.text = text
	

func get_text() -> String:
	return _label.text


func highlight():
	_hexagon.color = Color.CORAL
	hex_selected.emit()


func unhighlight():
	_hexagon.color = Color.WHITE
