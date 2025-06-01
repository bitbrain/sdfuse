@tool
extends EditorPlugin


func _init():
	name = "SDFusePlugin"
	add_autoload_singleton("SDFuseLightingManager", "lighting_manager.gd")
