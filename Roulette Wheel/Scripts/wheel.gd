extends Node2D
class_name Wheel

@export var initial_rotation_speed: float = 20
var rotation_speed: float = 0

var cycles: int = 0
var random_cycle: float = 0

var radius: float = 0

var active_balls: Array[Ball]

@onready var time_per_rotation: float = initial_rotation_speed*60/(2*PI)

#flags
var slow_down: bool = false
var stopped: bool = false


func _ready() -> void:
	radius = $WheelGenerator.inner_radius+($WheelGenerator.outer_radius-$WheelGenerator.inner_radius)/2
	$WheelGenerator.generate_wheel_shape()


func _physics_process(delta: float) -> void:
	if slow_down == true and rotation_speed != 0:
		if rotation_speed >= initial_rotation_speed/1.05:
			rotation_speed = lerp(float(rotation_speed), float(0), 0.0005)
		else:
			rotation_speed = lerp(float(rotation_speed), float(0), 0.002)
	elif rotation_speed != 0:
		if cycles >= random_cycle:
			slow_down = true
		else:
			cycles += 1
	if rotation_speed <= 0.5 and stopped == false:
		rotation_speed = 0
		stopped = true
	if rotation_speed != 0:
		$Center.rotation += (rotation_speed/(2*PI))*delta


func spin() -> void:
	random_cycle = randf_range(0, time_per_rotation)
	cycles = 0
	rotation_speed = initial_rotation_speed
	stopped = false
