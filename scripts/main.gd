class_name Manager
extends Control

@export var file_dialog: FileDialog
@export var flower: HexFlower
@export var navigation: Navigation
@export var dice_line_edit: LineEdit
@export var history_text_edit: TextEdit

var hex_grid: HexGrid
var dice: String

@onready var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	hex_grid = HexGrid.new()
	hex_grid.set_hex_scale(Vector2(128, 128))
	
	await get_tree().create_timer(0.25).timeout
	
	file_dialog.popup_centered(Vector2(300, 720))
	file_dialog.file_selected.connect(file_selected)


func file_selected(path):
	var data = JSON.parse_string(FileAccess.get_file_as_string(path))
	
	flower.setup(self, data.rows)
	navigation.setup(self, data.navigation)
	dice = data.dice
	dice_line_edit.text = dice


func _on_roll_button_pressed():
	var roll = dice_syntax.roll(dice, _rng)['result']
	var dir_name = navigation.get_dir(roll)
	var dir = HexFlower.DIRECTIONS[dir_name]
	
	var new_life_path: String = flower.traverse(dir)
	history_text_edit.insert_line_at(history_text_edit.get_line_count() - 1, new_life_path)


func _on_line_edit_dice_text_submitted(new_text:String):
	dice = new_text


func _on_line_edit_dice_focus_exited():
	dice = dice_line_edit.text
