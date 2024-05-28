class_name Import
#extends Object

class Data:
	var flower_name: String
	var dice: String
	var navigation: Dictionary
	var start_coords: Array
	var hexes: Array[HexData]

# Data format v1
#	(Direction: String)
#	(Axial Coords: Vector2)
#	Flower Name: String
#	Dice: String
#	Navigation: Dictionary[Direction, Dice numbers(Array[int])]
#	Start Coords: Array[Axial Coords]
#	Hexes: Array[HexData]

class HexData:
	var label: String
	var axial_coords: Vector2
	var color: Color
	var barriers: Array[String]


static func import_json(json_str: String) -> Data:
	var json = JSON.parse_string(json_str)
	if json == null:
		return null
		
	if "format_version" not in json:
		return null
	
	match floori(json.format_version):
		1:
			return load_v1(json)
		_:
			return null
	
	
static func load_v1(json) -> Data:
	var data: Data = Data.new()
	if "name" in json:
		data.flower_name = json.name
	if "dice" in json:
		data.dice = json.dice
	if "navigation" in json:
		if typeof(json.navigation) == TYPE_DICTIONARY:
			for key in json.navigation:
				if typeof(json.navigation[key]) == TYPE_ARRAY:
					data.navigation[key] = []
					for val in json.navigation[key]:
						if typeof(val) == TYPE_FLOAT:
							data.navigation[key].append(floori(val))
	if "start_coords" in json:
		if typeof(json.start_coords) == TYPE_ARRAY:
			for arr in json.start_coords:
				if typeof(arr) == TYPE_ARRAY:
					var vec2 = _axial_array_to_vec2(arr)
					if vec2 != Vector2.INF:
						data.start_coords.append(vec2)
	if "hexes" in json:
		if typeof(json.hexes) == TYPE_ARRAY:
			for jhex in json.hexes:
				var hex: HexData = HexData.new()
				if "label" in jhex:
					if typeof(jhex.label) == TYPE_STRING:
						hex.label = jhex.label
				if "axial_coords" in jhex:
					if typeof(jhex.axial_coords) == TYPE_ARRAY:
						hex.axial_coords = _axial_array_to_vec2(jhex.axial_coords)
				if "color" in jhex:
					if typeof(jhex.color) == TYPE_STRING:
						hex.color = Color.from_string(jhex.color, Color.GHOST_WHITE)
				if "barriers" in jhex:
					if typeof(jhex.barriers) == TYPE_ARRAY:
						for b in jhex.barriers:
							if typeof(b) == TYPE_STRING:
								var bnorm: String = b.to_lower()
								var dir: String
								if bnorm == "stay":
										dir = "Stay"
								elif bnorm == "n"\
									or bnorm == "ne"\
									or bnorm == "se"\
									or bnorm == "s"\
									or bnorm == "sw"\
									or bnorm == "nw":
										dir = bnorm
										
								hex.barriers.append(dir)
				
				if hex.axial_coords != Vector2.INF:
					data.hexes.append(hex)
	return data


static func _axial_array_to_vec2(arr: Array) -> Vector2:
	if arr.size() == 2 and arr.all(func(x): return typeof(x) == TYPE_FLOAT):
		return Vector2(floori(arr[0]), floori(arr[1]))
	return Vector2.INF
