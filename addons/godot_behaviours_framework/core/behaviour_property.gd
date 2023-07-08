extends Node


# Editor settings

var property_name: String = ""
var type: int = TYPE_NIL
var usage: int = PROPERTY_USAGE_DEFAULT
var hint: int = PROPERTY_HINT_NONE
var hint_string: String = ""

# Value settings

var value = null
var can_revert: bool = false
var default_value = null


func _init(
		property_name: String = "",
		type: int = TYPE_NIL,
		value = null,
		usage: int = PROPERTY_USAGE_DEFAULT,
		hint: int = PROPERTY_HINT_NONE,
		hint_string: String = "",
		can_revert: bool = false,
		default_value = null
		):
	self.property_name = property_name
	self.type = type
	self.value = value
	self.usage = usage
	self.hint = hint
	self.hint_string = hint_string
	self.can_revert = can_revert
	self.default_value = default_value


func as_property_dict(prefix: String = "") -> Dictionary:
	var dict: Dictionary = {
		"name": prefix + property_name,
		"type": type,
		"usage": usage,
		"hint": hint,
		"hint_string": hint_string
	}
	return (dict)
