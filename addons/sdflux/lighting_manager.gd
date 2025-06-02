@tool
extends Node2D


const IdGenerator = preload("./util/nano_id_gen.gd")
const Canvas = preload("./sdf_canvas.gd")
const SDFShader = preload("./shader/sdf.gdshader")


# The shader is set to a maximum of 100 lights
const LIGHT_N: int = 100

var ID_GEN = IdGenerator.new()

# The parameters of the light sources are each passed to the shader as an array
var light_pos: Array[Vector2]
var light_col: Array[Color]
var light_range: Array[float]
var light_ang: Array[float]
var light_fan_ang: Array[float]
var light_energy: Array[float]
var light_blend_mode: Array[int]
var canvas:ColorRect
var light_data:Dictionary[String, Dictionary] = {}


func _ready() -> void:
	light_pos.resize(LIGHT_N)
	light_range.resize(LIGHT_N)
	light_col.resize(LIGHT_N)
	light_ang.resize(LIGHT_N)
	light_fan_ang.resize(LIGHT_N)
	light_energy.resize(LIGHT_N)
	light_blend_mode.resize(LIGHT_N)
	
	
func register_canvas(canvas:SDFCanvas) -> void:
	self.canvas = canvas
	
	
func unregister_canvas(canvas:SDFCanvas) -> void:
	if self.canvas == canvas:
		self.canvas = null
	
	
func register_light(dict:Dictionary) -> String:
	var light_id = ID_GEN.generate()
	light_data[light_id] = dict
	return light_id
	
	
func unregister_light(id:String) -> void:
	light_data.erase(id)


func _physics_process(delta: float) -> void:
	if not canvas:
		return
		
	if light_data.is_empty():
		return
		
	var lights = light_data.values()
	
	if light_pos.is_empty():
		return
		
	# The current states of the lights are entered into the parameter arrays
	for i in range(lights.size()):
		light_pos[i] = lights[i]["pos"]
		light_col[i] = lights[i]["col"]
		light_range[i] = lights[i]["range"]
		light_ang[i] = lights[i]["ang"]
		light_fan_ang[i] = lights[i]["fan_ang"]
		light_energy[i] = lights[i]["energy"]
		light_blend_mode[i] = lights[i]["blend_mode"]
	
	# The shader parameters are passed updated
	canvas.material.set_shader_parameter("light_n", lights.size())
	canvas.material.set_shader_parameter("light_pos", light_pos)
	canvas.material.set_shader_parameter("light_col", light_col)
	canvas.material.set_shader_parameter("light_rng", light_range)
	canvas.material.set_shader_parameter("light_ang", light_ang)
	canvas.material.set_shader_parameter("light_fan_ang", light_fan_ang)
	canvas.material.set_shader_parameter("light_energy", light_energy)
	canvas.material.set_shader_parameter("light_blend_mode", light_blend_mode)
	canvas.material.set_shader_parameter("ambient_modulate", canvas.color)
	
	# The camera is not changed in this demo,
	# but if someone wants to mess around with the camera,
	# these lines make sure the shader knows about it
	var camera = get_tree().get_first_node_in_group("camera")
	if camera:
		var trans_comp: Transform2D = get_global_transform_with_canvas()
		canvas.material.set_shader_parameter("comp_mat", trans_comp)
		canvas.material.set_shader_parameter("zoom", camera.zoom.x)
		canvas.material.set_shader_parameter("rotation", camera.global_rotation)
