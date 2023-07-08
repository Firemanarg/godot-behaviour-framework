@tool
extends Node
class_name Behaviour


enum ProcessCallback {
	BEHAVIOUR_PROCESS_PHYSICS,
	BEHAVIOUR_PROCESS_IDLE,
}

var behaviour_type: int = Type.BEHAVIOUR
var required_parent_class: String = "Node"
var allow_duplicated_behaviour: bool = false
var max_duplicated_count: int = 0


func _ready() -> void:
	pass


class Type \
	extends "res://addons/godot_behaviours_framework/core/behaviour_type.gd":
	func _init() -> void:
		pass


class Property \
	extends "res://addons/godot_behaviours_framework/core/behaviour_property.gd":
	func _init() -> void:
		pass


class PropertyGroup \
	extends "res://addons/godot_behaviours_framework/core/behaviour_property_group.gd":
	func _init() -> void:
		pass
