@tool
extends EditorPlugin


const BehaviourManagerAutoload: Dictionary = {
	"name": "BehaviourManager",
	"path": "res://addons/godot_behaviours_framework/core/behaviour_manager.gd",
}


func _enter_tree():
	add_autoload_singleton(
		BehaviourManagerAutoload.name,
		BehaviourManagerAutoload.path)


func _exit_tree():
	remove_autoload_singleton(BehaviourManagerAutoload.name)
