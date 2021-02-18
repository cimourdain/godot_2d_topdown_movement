tool
extends EditorPlugin


func _enter_tree():
	add_custom_type(
		"TopDownMovementManager", 
		"Node2D", 
		preload("lib/movement_manager.gd"),
		null
	)


func _exit_tree():
	remove_custom_type("TopDownMovementManager")
