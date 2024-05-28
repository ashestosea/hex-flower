class_name Manager
extends Node

@export var flower: HexFlower
@export var background_flower: Control
@export var navigation: Navigation
@export var kebab: MenuButton
@export var flower_name: Label
@export var dice_line_edit: LineEdit
@export var history_text_edit: TextEdit
@export var import_menu: Control
@export var file_dialog: FileDialog
@export var json_text_edit: TextEdit

var dice: String

@onready var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _on_button_open_pressed():
	import_menu.show()
	

func _on_button_import_json_pressed():
	import_menu.hide()
	setup(Import.import_json(json_text_edit.text))


func _on_button_load_file_pressed():
	file_dialog.popup_centered(Vector2(300, 720))


func _on_button_roll_pressed():
	var roll: int = dice_syntax.roll(dice, _rng)['result']
	print(roll)
	var dir_name = navigation.get_dir(roll)
	var dir = HexUtils.DIRECTIONS[dir_name]
	
	var new_hex: String = flower.traverse(dir)
	history_text_edit.insert_line_at(history_text_edit.get_line_count() - 1, new_hex)


func _on_line_edit_dice_text_submitted(new_text:String):
	dice = new_text


func _on_line_edit_dice_focus_exited():
	dice = dice_line_edit.text


func _ready():
	file_dialog.file_selected.connect(file_selected)
	var kebab_popup = kebab.get_popup()
	kebab_popup.add_item("Import", 0, KEY_I)
	kebab_popup.add_separator()
	kebab_popup.add_item("Export", 1, KEY_E)
	kebab_popup.id_pressed.connect(kebab_handler)
	
	var hexes = Import.import_json(FileAccess.get_file_as_string("res://examples/simple-fantasy.json")).hexes
	var _hex_scene = load("res://scenes/hexagon.tscn")
	for hex in hexes:
		var hex_node = _hex_scene.instantiate() as Node2D
		var coords = HexUtils.axial_to_cube_coords(hex.axial_coords)
		hex_node.position = HexUtils.get_hex_center(coords, hex_node.scale.x * 2)
		hex_node.color = Color.DIM_GRAY
		background_flower.add_child(hex_node)
	

func kebab_handler(id: int):
	match id:
		0:
			import_menu.show()
		1:
			pass


func file_selected(path):
	import_menu.hide()
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
	
