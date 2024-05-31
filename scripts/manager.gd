class_name Manager
extends Node

@export var flower: HexFlower
@export var navigation: Navigation
@export var kebab: MenuButton
@export var flower_name: Label
@export var dice_line_edit: LineEdit
@export var history_text_edit: TextEdit
@export var import_menu: Control
@export var paste_json_menu: Control
@export var file_dialog: FileDialog
@export var json_text_edit: TextEdit
@export var hex_edit: HexEdit
@export var global_back_button: Button
@export var global_back_button_anim: AnimationPlayer

var dice: String
var _global_back_button_callback: Callable

@onready var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _on_open_import_pressed():
	import_menu_show()


func _on_load_file_pressed():
	file_dialog.popup_centered(Vector2(300, 720))


func _on_open_paste_pressed():
	paste_json_menu_show()


func _on_load_paste_pressed():
	import_menu_hide()
	setup(Import.import_json(json_text_edit.text))


func _on_roll_pressed():
	var roll: int = dice_syntax.roll(dice, _rng)['result']
	print(roll)
	var dir_name = navigation.get_dir(roll)
	var dir = HexUtils.DIRECTIONS[dir_name]

	var new_hex: String = flower.traverse(dir)
	history_text_edit.insert_line_at(history_text_edit.get_line_count() - 1, new_hex)


func _on_dice_text_submitted(new_text:String):
	dice = new_text


func _on_dice_focus_exited():
	dice = dice_line_edit.text


func _ready():
	file_dialog.file_selected.connect(file_selected)
	var kebab_popup = kebab.get_popup()
	kebab_popup.add_item("Import", 0, KEY_I)
	kebab_popup.add_separator()
	kebab_popup.add_item("Export", 1, KEY_E)
	kebab_popup.id_pressed.connect(kebab_handler)

	hex_edit.finished.connect(finish_edit_hex)

	setup(Import.import_json(FileAccess.get_file_as_string("res://examples/empty.json")))


func kebab_handler(id: int):
	match id:
		0:
			import_menu_show()
		1:
			pass


func file_selected(path):
	import_menu_hide()
	setup(Import.import_json(FileAccess.get_file_as_string(path)))


func setup(data: Import.Data):
	flower.setup(self, data.hexes)
	navigation.setup(self, data.navigation)
	dice = data.dice
	dice_line_edit.text = dice


func set_current_hex(hex: Hex):
	flower.set_current_hex(hex);


func reset_current_hex(hex: Hex):
	history_text_edit.clear()
	history_text_edit.insert_line_at(0, hex.get_text())
	set_current_hex(hex)


func edit_hex(hex: Hex):
	global_back_button_show(finish_edit_hex)
	hex_edit.open(hex)


func finish_edit_hex():
	var anim_len = hex_edit.close_anim() * 0.5

	await get_tree().create_timer(anim_len).timeout

	global_back_button_hide(anim_len)
	hex_edit.close(anim_len)

	await get_tree().create_timer(anim_len).timeout

	flower.show_current_hex()


func import_menu_show():
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
	global_back_button.show()
	if !global_back_button.visible:
		global_back_button_anim.play_backwards("fade")
	for dict in global_back_button.pressed.get_connections():
		global_back_button.pressed.disconnect(dict["callable"])
	global_back_button.pressed.connect(callback)


func global_back_button_hide(seconds: float = 0):
	global_back_button_anim.play("fade")

	if seconds > 0:
		await get_tree().create_timer(seconds).timeout

	global_back_button.hide()
	global_back_button_anim.stop()
