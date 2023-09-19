class_name SimplePropertyList
extends Node


var properties: Array = []	## All properties, including groups, subgroups and categories
var _valuables: Dictionary = {}	## Only properties with value


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	set_process(false)
	set_physics_process(false)
	pass


func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary] = []
	for prop in properties:
		props.append(prop.as_dict())
	return props


func add_property(
	property_name: String = "",
	type: int = TYPE_NIL,
	usage: int = PROPERTY_USAGE_DEFAULT,
	hint: int = PROPERTY_HINT_NONE,
	hint_string: String = "",
	prop_class_name: String = ""
) -> void:
	var prop: Property = Property.new(
		property_name, type, usage, hint, hint_string, prop_class_name
	)
	properties.append(prop)
	_valuables[prop.prop_name] = prop


func append_property(property: Property) -> void:
	properties.append(property)


func get_property(property_name: String):
	return _valuables.get(property_name)


func add_category(category_name: String) -> void:
	properties.append(PropertyGroup.new(category_name))


func append_category(category: Category) -> void:
	properties.append(category)


func add_group(group_name: String = "", prefix: String = "") -> void:
	properties.append(PropertyGroup.new(group_name, prefix))


func append_group(group: PropertyGroup) -> void:
	properties.append(group)


func add_subgroup(subgroup_name: String = "", prefix: String = "") -> void:
	properties.append(PropertySubgroup.new(subgroup_name, prefix))


func append_subgroup(subgroup: Category) -> void:
	properties.append(subgroup)


class Property:
	var property_name: String = ""
	var type: int = TYPE_NIL
	var usage: int = PROPERTY_USAGE_DEFAULT
	var hint: int = PROPERTY_HINT_NONE
	var hint_string: String = ""
	var prop_class_name: StringName = ""

	func _init(
		property_name: String = "",
		type: int = TYPE_NIL,
		usage: int = PROPERTY_USAGE_DEFAULT,
		hint: int = PROPERTY_HINT_NONE,
		hint_string: String = "",
		prop_class_name: String = ""
	) -> void:
		self.property_name = property_name
		self.type = type
		self.usage = usage
		self.hint = hint
		self.hint_string = hint_string
		self.prop_class_name = prop_class_name

	func as_dict() -> Dictionary:
		var dict: Dictionary = {
			"name": property_name,
			"class_name": prop_class_name,
			"type": type,
			"usage": usage,
			"hint": hint,
			"hint_string": hint_string,
		}
		return dict

	func is_valuable() -> bool:
		return true


class Category:
	var category_name: String = ""

	func _init(category_name: String = "") -> void:
		self.category_name = category_name

	func as_dict() -> Dictionary:
		var dict: Dictionary = {
			"name": category_name,
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_CATEGORY,
		}
		return dict

	func is_valuable() -> bool:
		return false


class PropertyGroup:
	var group_name: String = ""
	var prefix: String = ""

	func _init(group_name: String = "", prefix: String = "") -> void:
		self.group_name = group_name
		self.prefix = prefix

	func as_dict() -> Dictionary:
		var dict: Dictionary = {
			"name": group_name,
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP,
			"prefix": prefix,
		}
		return dict

	func is_valuable() -> bool:
		return false


class PropertySubgroup:
	var subgroup_name: String = ""
	var prefix: String = ""

	func _init(subgroup_name: String = "", prefix: String = "") -> void:
		self.subgroup_name = subgroup_name
		self.prefix = prefix

	func as_dict() -> Dictionary:
		var dict: Dictionary = {
			"name": subgroup_name,
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP,
			"prefix": prefix,
		}
		return dict

	func is_valuable() -> bool:
		return false
