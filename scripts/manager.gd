class_name Manager
extends Node

@export var flower: HexFlower
@export var navigation: Navigation
@export var kebab: MenuButton
@export var flower_name: LineEdit
@export var dice_line_edit: LineEdit
@export var history_text_edit: TextEdit
@export var import_menu: Control
@export var import_helper_button_parent: Control
@export var paste_json_menu: Control
@export var file_dialog: FileDialog
@export var json_text_edit: TextEdit
@export var hex_edit: HexEdit
@export var global_back_button: Button
@export var global_back_button_anim: AnimationPlayer

var dice: String

@onready var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _on_open_import_pressed():
	import_menu_show()


func _on_load_file_pressed():
	file_dialog.popup_centered(Vector2(300, 720))


func _on_open_paste_pressed():
	paste_json_menu_show()


func _on_load_paste_pressed():
	import_menu_hide()
	setup(Data.import_json(json_text_edit.text))


func _on_roll_pressed():
	var roll: int = dice_syntax.roll(dice, _rng)['result']
	print(roll)
	var dir_name = navigation.get_dir(roll)
	var dir = HexUtils.DIRECTIONS[dir_name]

	var new_hex_text: String = flower.traverse(dir)
	history_text_edit.insert_line_at(history_text_edit.get_line_count() - 1, new_hex_text)


func _on_dice_text_submitted(new_text:String):
	dice = new_text


func _on_dice_focus_exited():
	dice = dice_line_edit.text


func _ready():
	file_dialog.file_selected.connect(file_selected)
	var kebab_popup = kebab.get_popup()
	kebab_popup.add_item("Import", 0, KEY_MASK_CTRL | KEY_I)
	kebab_popup.add_item("Export", 1, KEY_MASK_CTRL | KEY_E)
	kebab_popup.add_item("Clear", 2)
	kebab_popup.id_pressed.connect(kebab_handler)

	hex_edit.color_picker_opened.connect(hex_edit_color_picker)
	hex_edit.finished.connect(finish_edit_hex)

	clear_flower()


func kebab_handler(id: int):
	match id:
		0:
			import_menu_show()
		1:
			export()
		2:
			clear_flower()


func clear_flower():
	setup(Data.import_json(FileAccess.get_file_as_string("res://examples/blank.json")))


func file_selected(path):
	import_menu_hide()
	setup(Data.import_json(FileAccess.get_file_as_string(path)))


func setup(data: Data.FlowerData):
	flower_name.text = data.flower_name
	flower.setup(self, data.hexes)
	navigation.setup(self, data.navigation)
	dice = data.dice
	dice_line_edit.text = dice


func export():
	var data: Data.FlowerData = Data.FlowerData.new()
	data.flower_name = flower_name.text
	data.dice = dice_line_edit.text
	data.navigation = navigation.directions
	for hex in flower._hexes:
		var hex_data = Data.HexData.new()
		hex_data.label = hex.get_text()
		hex_data.axial_coords = Vector2(hex.cube_coords.x, hex.cube_coords.y)
		hex_data.color = hex.get_color()
		data.hexes.append(hex_data)

	var data_string = Data.jsonify_v1(data)


func reset_current_hex(hex: Hex):
	history_text_edit.clear()
	history_text_edit.insert_line_at(0, hex.get_text())
	flower.set_current_hex(hex)


func edit_hex(hex: Hex):
	global_back_button_show(finish_edit_hex)
	hex.hide()
	hex_edit.open(hex, flower)


func hex_edit_color_picker():
	global_back_button_show(hex_edit_color_picker_hide)


func hex_edit_color_picker_hide():
	hex_edit.hide_color_picker()
	global_back_button_show(finish_edit_hex)


func finish_edit_hex():
	var anim_len = hex_edit.start_close(flower._current_hex) * 0.5

	await get_tree().create_timer(anim_len).timeout

	hex_edit.hide()
	global_back_button_hide(anim_len)
	flower.show_current_hex()


func import_menu_show():
	import_helper_button_parent.hide()
	import_menu.show()
	global_back_button_show(import_menu_hide)


func import_menu_hide():
	import_menu.hide()
	global_back_button_hide(0.25)


func paste_json_menu_show():
	paste_json_menu.show()
	global_back_button_show(paste_json_menu_hide)


func paste_json_menu_hide():
	paste_json_menu.hide()
	import_menu_show()


func global_back_button_show(callback: Callable):
	if !global_back_button.visible:
		global_back_button_anim.play_backwards("fade")

	global_back_button.show()

	await get_tree().create_timer(0.5).timeout

	global_back_button.pressed.connect(callback)
	global_back_button.disabled = false


func global_back_button_hide(seconds: float = 0):
	global_back_button.disabled = true
	for dict in global_back_button.pressed.get_connections():
		global_back_button.pressed.disconnect(dict["callable"])

	global_back_button_anim.play("fade")

	if seconds > 0:
		await get_tree().create_timer(seconds).timeout

	global_back_button.hide()
