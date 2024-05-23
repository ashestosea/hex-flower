class_name Hex
extends Node2D

var _manager
var _hex_flower: HexFlower
var _hex_grid: HexGrid
var _hex_cell: HexCell

@onready var label: Label = $Label

signal hex_selected

func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event.is_action("ui_touch"):
		_hex_flower.set_current_hex(self)

func setup(manager: Manager, hex_flower: HexFlower, hex_grid: HexGrid, hex_pos: Vector2, text: String):
	_manager = manager
	_hex_flower = hex_flower
	_hex_grid = hex_grid
	_hex_cell = HexCell.new(hex_pos)
	position = _hex_grid.get_hex_center(_hex_cell)
	$Label.text = text

func highlight():
	$Polygon2D.color = Color.CORAL
	hex_selected.emit()
	
func unhighlight():
	$Polygon2D.color = Color.WHITE
