class_name Manager
extends Node

@export var flower: HexFlower
@export var navigation: Navigation
@export var flower_name: Label
@export var dice_line_edit: LineEdit
@export var history_text_edit: TextEdit
@export var load_modal: Control
@export var file_dialog: FileDialog
@export var json_text_edit: TextEdit

var dice: String

@onready var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _on_button_open_pressed():
	load_modal.show()
	

func _on_button_import_json_pressed():
	load_modal.hide()
	Import.import_json(json_text_edit.text)


func _on_button_load_file_pressed():
	file_dialog.popup_centered(Vector2(300, 720))


func _on_button_roll_pressed():
	var roll: int = dice_syntax.roll(dice, _rng)['result']
	print(roll)
	var dir_name = navigation.get_dir(roll)
	var dir = HexFlower.DIRECTIONS[dir_name]
	
	var new_life_path: String = flower.traverse(dir)
	history_text_edit.insert_line_at(history_text_edit.get_line_count() - 1, new_life_path)


func _on_line_edit_dice_text_submitted(new_text:String):
	dice = new_text


func _on_line_edit_dice_focus_exited():
	dice = dice_line_edit.text


func _ready():
	file_dialog.file_selected.connect(file_selected)


func file_selected(path):
	load_modal.hide()
	var data: Import.Data = Import.import_json(FileAccess.get_file_as_string(path))
	flower.setup(self, data.hexes)
	navigation.setup(self, data.navigation)
	dice = data.dice
	dice_line_edit.text = dice


#func json_pasted():
	#var data = Data.import_json(json_text_edit.text)
	
	


func set_current_hex(hex: Hex):
	history_text_edit.clear()
	history_text_edit.insert_line_at(0, hex.get_text())
	flower.set_current_hex(hex);
	
