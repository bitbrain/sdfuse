@tool
extends EditorPlugin


func _init():
	name = "SDFluxPlugin"
	add_autoload_singleton("SDFluxLightingManager", "lighting_manager.gd")
