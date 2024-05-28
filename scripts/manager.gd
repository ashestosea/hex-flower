class_name Manager
extends Node

@export var flower: HexFlower
@export var background_flower: Control
@export var navigation: Navigation
@export var io_menu: MenuButton
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
	setup(Import.import_json(json_text_edit.text))


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
	var menu_popup = io_menu.get_popup()
	menu_popup.add_item("Import", 0, KEY_I)
	menu_popup.add_separator()
	menu_popup.add_item("Export", 1, KEY_E)
	menu_popup.id_pressed.connect(io_menu_handle)
	

func io_menu_handle(id: int):
	match id:
		0:
			load_modal.show()
		1:
			pass


func file_selected(path):
	load_modal.hide()
	setup(Import.import_json(FileAccess.get_file_as_string(path)))
	

func setup(data: Import.Data):
	background_flower.hide()
	flower.setup(self, data.hexes)
	navigation.setup(self, data.navigation)
	dice = data.dice
	dice_line_edit.text = dice


func set_current_hex(hex: Hex):
	history_text_edit.clear()
	history_text_edit.insert_line_at(0, hex.get_text())
	flower.set_current_hex(hex);
	
