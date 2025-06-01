extends Node2D

# The shader is set to a maximum of 100 lights
const LIGHT_N: int = 100

# The parameters of the light sources are each passed to the shader as an array
var light_pos: Array[Vector2]
var light_col: Array[Color]
var light_range: Array[float]
var light_ang: Array[float]
var light_fan_ang: Array[float]

# For the sake of simplicity, I'll create a few lights as dictionaries
var lights: Array[Dictionary]

# For some animation only
var time: float

@onready var camera_2d = $Camera2D


func _ready():
	# 3 lights are defined
	lights = [
		{
			"pos" : Vector2(250.0, 250.0),
			"range" : 800.0,
			"col" : Color.AQUA,
			"ang" : PI,
			"fan_ang" : PI * 0.25
		},
		{
			"pos" : Vector2(0.0, 0.0),
			"range" : 800.0,
			"col" : Color.RED,
			"ang" : 0.0,
			"fan_ang" : TAU
		},
		{
			"pos" : Vector2(600.0, 600.0),
			"range" : 800.0,
			"col" : Color.BEIGE,
			"ang" : 0.0,
			"fan_ang" : PI * 0.125
		}
	]
