extends Node


var _properties: Dictionary = {"": []}


func _ready() -> void:
	# Tests
	add_property("dir1.dir2.dir3.dir4.name0", TYPE_FLOAT)
	print("Property: ", get_property("dir1.dir2.dir3.dir4.name0").as_dict())
	add_property("dir1.name1", TYPE_INT)
	print("Property: ", get_property("dir1.name1").as_dict())
	add_property("name2", TYPE_BOOL)
	print("Property: ", get_property("name2").as_dict())
	print("Properties: ", _properties)
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func append_property(path: String, property: Property) -> void:
	pass


func add_property(
	path: String, type: int,
	usage: int = PROPERTY_USAGE_DEFAULT,
	hint: int = PROPERTY_HINT_NONE,
	hint_string: String = "",
	prop_class_name: String = ""
	) -> void:
	var prop_name: String = _get_name_by_path(path)
	var property: Property = Property.new(
		prop_name, type, usage, hint, hint_string, prop_class_name)
	var arr_path: Array = _locate_path(path.substr(0, len(path) - len(prop_name)), true)
	arr_path.append(property)


func get_property(path: String) -> Property:
	var prop_name: String = _get_name_by_path(path)
	var prop_dir: String = _get_dir_by_path(path, prop_name)
	var properties: Array = _locate_path(prop_dir)
	for property in properties:
		if property.name == prop_name:
			return property
	return null


func _get_name_by_path(path: String) -> String:
	return path.split('.')[-1]


func _get_dir_by_path(path: String, name: String = ""):
	if name.is_empty():
		var index: int = path.rfind('.')
		if index < 0:
			index = 0
		return path.substr(0, index).trim_suffix('.')
	return path.substr(0, len(path) - len(name)).trim_suffix('.')


func _locate_path(path: String, fill_missing: bool = false) -> Array:
	var dict_path: Dictionary = _properties

	for path_part in path.split("."):
		path_part = path_part
		if not dict_path.has(path_part):
			if fill_missing:
				dict_path[path_part] = {"": []}
			else:
				return []
		if not path_part.is_empty():
			dict_path = dict_path[path_part]
	return dict_path[""]


class Property extends Node:
	var type: int = TYPE_NIL
	var usage: int = PROPERTY_USAGE_DEFAULT
	var hint: int = PROPERTY_HINT_NONE
	var hint_string: String = ""
	var prop_class_name: StringName = ""
	var value = null

	func _init(
		name: String, type: int,
		usage: int = PROPERTY_USAGE_DEFAULT,
		hint: int = PROPERTY_HINT_NONE,
		hint_string: String = "",
		prop_class_name: String = ""
	) -> void:
		self.name = name
		self.type = type
		self.usage = usage
		self.hint = hint
		self.hint_string = hint_string
		self.prop_class_name = prop_class_name

	func as_dict() -> Dictionary:
		var dict: Dictionary = {
			"name": self.name,
			"class_name": prop_class_name,
			"type": type,
			"usage": usage,
			"hint": hint,
			"hint_string": hint_string,
		}
		return dict
