@tool
class_name SDFCanvas extends ColorRect


const SDFShader = preload("./shader/sdf.gdshader")



func _ready() -> void:
	self.material = ShaderMaterial.new()
	self.material.shader = SDFShader


func _enter_tree() -> void:
	SDFuseLightingManager.register_canvas(self)
	
	
func _exit_tree() -> void:
	SDFuseLightingManager.unregister_canvas(self)
