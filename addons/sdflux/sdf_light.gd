@tool
class_name SDFLight extends Node2D

enum BlendMode {
	ADD,
	MIX,
	SUB,
}

@export var range:int = 500:
	set(v):
		_data["range"] = v
		range = v
@export var color:Color = Color.WHITE:
	set(v):
		_data["col"] = v
		color = v
@export var angle:float = 0.0:
	set(v):
		_data["ang"] = v
		angle = v
@export var fan_angle:float = TAU:
	set(v):
		_data["fan_ang"] = v
		fan_angle = v
@export var energy:float = 1.0:
	set(v):
		_data["energy"] = v
		energy = v
@export var blend_mode:BlendMode = BlendMode.ADD:
	set(v):
		_data["blend_mode"] = v
		blend_mode = v


var _data = {}
var _id:String


func _ready() -> void:
	_data["pos"] = Vector2(0.0, 0.0)
	_data["range"] = range
	_data["col"] = color
	_data["ang"] = angle
	_data["fan_ang"] = fan_angle
	_data["energy"] = energy
	_data["blend_mode"] = blend_mode


func _enter_tree() -> void:
	self._id = SDFluxLightingManager.register_light(_data)


func _exit_tree() -> void:
	SDFluxLightingManager.unregister_light(_id)


func _physics_process(delta: float) -> void:
	_data["pos"] = global_position
