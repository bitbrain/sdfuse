@tool
class_name SDFCanvas extends ColorRect


const SDFShader = preload("./shader/sdf.gdshader")



func _ready() -> void:
	self.material = ShaderMaterial.new()
	self.material.shader = SDFShader


func _enter_tree() -> void:
	SDFluxLightingManager.register_canvas(self)
	
	
func _exit_tree() -> void:
	SDFluxLightingManager.unregister_canvas(self)
