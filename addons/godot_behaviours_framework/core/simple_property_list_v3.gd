@tool
extends Node


var _properties: Dictionary = {}
var _props_tree: Dictionary = {
	"groups": Dictionary(),
	"properties": Dictionary()
}


func _ready() -> void:
	# Tests
	add_property("Testing", TYPE_BOOL)
	add_property("dir1.dir2.dir3.dir4.name0", TYPE_FLOAT)
	add_property("dir1.dir2.dir3.name1", TYPE_FLOAT)
	add_property("dir1.dir2.dir33.name2", TYPE_FLOAT)
	print("\t\tPRINTING PROPERTY LIST")
	for prop in get_property_list():
		print(prop["name"], "(", prop["usage"], ")", " - ", prop["hint_string"])
	print("\t\tPRINTED PROPERTY LIST")
#	print(_properties)
#	print(_props_tree)
##	var prop_list: Array[Dictionary]
##	_rec_get_property_list(prop_list, _props_tree, "")
#	print("Property: ", get_property("dir1.dir2.dir3.dir4.name0").as_dict())
#	add_property("dir1.name1", TYPE_INT)
#	print("Property: ", get_property("dir1.name1").as_dict())
#	add_property("name2", TYPE_BOOL)
#	print("Property: ", get_property("name2").as_dict())
#	print("Properties: ", _properties)
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func append_property(path: String, property: Property) -> void:
	pass


func _get_property_list() -> Array[Dictionary]:
	var prop_list: Array[Dictionary] = []

	_rec_get_property_list(prop_list, _props_tree, "")

	return prop_list

# Parei aqui! Estou tentando corrigir a parte de subgrupos no Inspector.
# Parece que está dando algo de errado no prefixo dos subgrupos, mas não tenho
# certeza. Tenho que verificar pra descobrir se realmente é isso
func _rec_get_property_list(
	prop_list: Array[Dictionary], curr_group: Dictionary, curr_path: String
) -> void:
	for prop in curr_group.get("properties", {}).values():
		prop_list.append(prop.as_dict())
#		print(prop, " - ", curr_path + prop.name)
	var is_subgroup: bool = not prop_list.is_empty()
	for group in curr_group["groups"]:
		prop_list.append({
			"name": group.capitalize(),
			"type": TYPE_NIL,
			"usage": (
				PROPERTY_USAGE_SUBGROUP if is_subgroup
				else PROPERTY_USAGE_GROUP
			),
			"hint_string": curr_path + group
		})
#		print(group, " - ", curr_path + group)
		_rec_get_property_list(
			prop_list, curr_group["groups"][group], curr_path + group)


func add_property(
	path: String, type: int, usage: int = PROPERTY_USAGE_DEFAULT,
	hint: int = PROPERTY_HINT_NONE, hint_string: String = "",
	prop_class_name: String = ""
) -> void:

	var new_path: String = path.replace('.', '_')
	var property: Property = Property.new(
		new_path, type, usage, hint, hint_string, prop_class_name
	)
	_properties[new_path] = property
	var dir_parts: PackedStringArray = _split_path(path)
	var prop_name: String = dir_parts[-1]
	dir_parts.remove_at(len(dir_parts) - 1)
	var dir_usage: int = PROPERTY_USAGE_GROUP
	var curr_dict: Dictionary = _props_tree
	for dir in dir_parts:
		if not curr_dict["groups"].has(dir):
			curr_dict["groups"][dir] = {
				"groups": Dictionary(),
				"properties": Dictionary()
			}
		curr_dict = curr_dict["groups"][dir]
	curr_dict["properties"][prop_name] = property

#	for part :
#		if not _props_tree.has(part):


func _split_path(path: String) -> PackedStringArray:
	var parts: PackedStringArray = path.split('.')
	for i in range(len(parts) - 1):
		parts[i] += '_'
	return parts

#func add_property(
#	path: String, type: int,
#	usage: int = PROPERTY_USAGE_DEFAULT,
#	hint: int = PROPERTY_HINT_NONE,
#	hint_string: String = "",
#	prop_class_name: String = ""
#	) -> void:
#	var prop_name: String = Property.get_name_by_path(path)
#	var prop_dir: String = Property.get_dir_by_path(path, prop_name)
#	var property: Property = Property.new(
#		path, type, usage, hint, hint_string, prop_class_name)
#	_properties[path] = property
#	var curr_group: Dictionary = _props_tree
#	for group in prop_dir.split('.'):
#		if not curr_group["groups"].has(group):
#			curr_group["groups"][group] = {
#				"groups": Dictionary(),
#				"properties": Dictionary()
#			}
#		curr_group = curr_group["groups"][group]
#	curr_group["properties"][prop_name] = property

#	var dict_path: Dictionary = _locate_path(path.substr(0, len(path) - len(prop_name)), true)
#	if not dict_path.is_empty():
#		dict_path[prop_name] = property


#func remove_property(path: String) -> void:
#	var prop_name: String = Property.get_name_by_path(path)
#	var prop_dir: String = Property.get_dir_by_path(path, prop_name)
#	var properties: Array = _locate_path(prop_dir)
#	var property: Property = null
#	for tmp in properties:
#		if tmp.name == prop_name:
#			property = tmp



#func get_property(path: String) -> Property:
#	var prop_name: String = Property.get_name_by_path(path)
#	var prop_dir: String = Property.get_dir_by_path(path, prop_name)
#	var properties: Dictionary = _locate_path(prop_dir)
#	for property in properties:
#		if property.name == prop_name:
#			return property
#	return null


func _group_as_dict(group_path: String, is_subgroup: bool = false) -> Dictionary:
	var group_usage: int = (
		PROPERTY_USAGE_GROUP if is_subgroup
		else PROPERTY_USAGE_SUBGROUP
	)
	var dict: Dictionary = {
		"name": group_path,
		"type": TYPE_NIL,
		"usage": (
			PROPERTY_USAGE_GROUP if is_subgroup
			else PROPERTY_USAGE_SUBGROUP
		)
	}
	return dict


#func _rec_get_property_list(
#	prop_list: Array[Dictionary], curr_group: Dictionary, curr_path: String
#) -> void:
#	for prop in curr_group.get("properties", {}):
#		print(prop)
#	var is_subgroup: bool = not prop_list.is_empty()
#	for group in curr_group["groups"]:
#		print(group)
##		var group_dict: Dictionary = curr_group["groups"][group]
##		for prop in group_dict.get("properties", {}).values:
##			prop_list.append(prop.as_dict())
#		var new_path: String = (
#			'_'.join([curr_path, group]) if not curr_path.is_empty()
#			else group
#		)
#		_rec_get_property_list(prop_list, curr_group["groups"][group], new_path)


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


	static func get_name_by_path(path: String) -> String:
		return path.split('.')[-1]


	static func get_dir_by_path(path: String, name: String = ""):
		if name.is_empty():
			var index: int = path.rfind('.')
			if index < 0:
				index = 0
			return path.substr(0, index).trim_suffix('.')
		return path.substr(0, len(path) - len(name)).trim_suffix('.')


	func as_dict() -> Dictionary:
		var dict: Dictionary = {
			"name": name,
			"class_name": prop_class_name,
			"type": type,
			"usage": usage,
			"hint": hint,
			"hint_string": hint_string,
		}
		return dict
