class_name Manager
extends Node2D

var hex_grid: HexGrid
var dice: String

@onready var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var flower: HexFlower = get_node("Flower")
@onready var navigation: Navigation = get_node("Navigation")

func _ready():
	hex_grid = HexGrid.new()
	hex_grid.set_hex_scale(Vector2(128, 128))
	
	await get_tree().create_timer(0.25).timeout
	
	var file_dialog: FileDialog = $FileDialog
	file_dialog.popup_centered(Vector2(300, 300))
	file_dialog.file_selected.connect(file_selected)


func file_selected(path):
	var data = JSON.parse_string(FileAccess.get_file_as_string(path))
	
	dice = data.dice
	flower.setup(self, data.rows)
	navigation.setup(self, data.navigation)


func _on_roll_button_pressed():
	var roll = dice_syntax.roll(dice, _rng)['result']
	var dir_name = navigation.get_dir(roll)
	var dir = HexFlower.DIRECTIONS[dir_name]
	
	flower.traverse(dir)
