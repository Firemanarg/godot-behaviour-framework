@tool
extends Node
class_name Behaviour


enum BehaviourProcessCallback {
	BEHAVIOUR_PROCESS_NONE = 0,
	BEHAVIOUR_PROCESS_PHYSICS = 1,
	BEHAVIOUR_PROCESS_IDLE = 2,
	BEHAVIOUR_PROCESS_BOTH = 3,
}

@export_category("Behaviour")
@export var is_enabled: bool = true:	## Indicates if the behaviour is enabled or not
	set = _set_enabled
@export var enable_in_editor: bool = false:	## Enable or disable behaviour script running in editor
	set = _set_enable_in_editor
@export var behaviour_callback: BehaviourProcessCallback = (
	BehaviourProcessCallback.BEHAVIOUR_PROCESS_BOTH):
		set = _set_callback_state

var behaviour_type: int = Type.BEHAVIOUR ## Type based on enum from <member Type>
var required_parent_class: String = "Node"
var allow_duplicated_behaviour: bool = false
var max_duplicated_count: int = 0
var _properties: Array = []
var properties: SimplePropertyList


func _ready() -> void:
	_update_callback_state()
	pass


func _get_property_list() -> Array[Dictionary]:
	var prop_list: Array[Dictionary] = []
	for prop in _properties:
		prop_list.append(prop.as_property_dict())
	return prop_list


## Add a property group or subgroup, depending on path provided as paramenter
func add_property_group(group_name: String) -> void:
	var group: PropertyGroup = PropertyGroup.new(group_name)
	_properties.append(group)


func add_property(property: Property) -> void:
	_properties.append(property)


func _update_callback_state() -> void:
	if Engine.is_editor_hint() and not enable_in_editor:
		return
	var has_idle_callback: bool = is_enabled and bool(
		behaviour_callback
		& BehaviourProcessCallback.BEHAVIOUR_PROCESS_IDLE
	)
	var has_physics_callback: bool = is_enabled and bool(
		behaviour_callback
		& BehaviourProcessCallback.BEHAVIOUR_PROCESS_PHYSICS
	)
	set_process(has_idle_callback)
	set_physics_process(has_physics_callback)


func _set_callback_state(state: BehaviourProcessCallback) -> void:
	behaviour_callback = state
	_update_callback_state()


func _set_enabled(is_enabled: bool) -> void:
	self.is_enabled = is_enabled
	_update_callback_state()


func _set_enable_in_editor(enable: bool) -> void:
	enable_in_editor = enable
	_update_callback_state()


class Type \
	extends "res://addons/godot_behaviours_framework/core/behaviour_type.gd":
	pass


class Property \
	extends "res://addons/godot_behaviours_framework/core/behaviour_property.gd":
	pass


class PropertyGroup \
	extends "res://addons/godot_behaviours_framework/core/behaviour_property_group.gd":
	pass
