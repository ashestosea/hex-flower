class_name Navigation
extends Control

var stay: Array[int]
var n: Array[int]
var ne: Array[int]
var se: Array[int]
var s: Array[int]
var sw: Array[int]
var nw: Array[int]

var directions: Dictionary

var le_stay: LineEdit
var le_n: LineEdit
var le_ne: LineEdit
var le_se: LineEdit
var le_s: LineEdit
var le_sw: LineEdit
var le_nw: LineEdit

var _manager: Manager


func _on_line_edit_stay_text_changed(new_text:String):
	directions["stay"] = parse_nav_text(new_text)


func _on_line_edit_n_text_changed(new_text:String):
	directions["n"] = parse_nav_text(new_text)


func _on_line_edit_ne_text_changed(new_text:String):
	directions["ne"] = parse_nav_text(new_text)


func _on_line_edit_se_text_changed(new_text:String):
	directions["se"] = parse_nav_text(new_text)


func _on_line_edit_s_text_changed(new_text:String):
	directions["s"] = parse_nav_text(new_text)


func _on_line_edit_sw_text_changed(new_text:String):
	directions["sw"] = parse_nav_text(new_text)


func _on_line_edit_nw_text_changed(new_text:String):
	directions["nw"] = parse_nav_text(new_text)


func setup(manager: Manager, nav_dict: Dictionary):
	_manager = manager

	le_stay = get_node("LineEdits/LineEdit_Stay")
	le_n = get_node("LineEdits/LineEdit_N")
	le_ne = get_node("LineEdits/LineEdit_NE")
	le_se = get_node("LineEdits/LineEdit_SE")
	le_s = get_node("LineEdits/LineEdit_S")
	le_sw = get_node("LineEdits/LineEdit_SW")
	le_nw = get_node("LineEdits/LineEdit_NW")

	directions = nav_dict

	stay.assign(nav_dict["stay"])
	n.assign(nav_dict["n"])
	ne.assign(nav_dict["ne"])
	se.assign(nav_dict["se"])
	s.assign(nav_dict["s"])
	sw.assign(nav_dict["sw"])
	nw.assign(nav_dict["nw"])

	set_le_text(le_stay, stay)
	set_le_text(le_n, n)
	set_le_text(le_ne, ne)
	set_le_text(le_se, se)
	set_le_text(le_s, s)
	set_le_text(le_sw, sw)
	set_le_text(le_nw, nw)


func set_le_text(le: LineEdit, arr: Array[int]):
	le.clear()
	arr.map(func (x): le.text = le.text + "," + str(x))
	le.text = le.text.trim_prefix(",")


func parse_nav_text(text: String) -> Array[int]:
	var arr: Array[int] = []
	arr.assign(JSON.parse_string("[%s]" % [text]))
	return arr


func get_dir(num: int):
	for d in directions:
		if directions[d].has(num):
			return d
