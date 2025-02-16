extends CharacterBody2D


@export var initial_speed: int = 6
@export var acceleration: float = -0.45
@export var fall_speed: float = 1
@export var time_elapsed: float = 0

var reference_angle: float = 0
var current_radius: float = 0

@export var target_wheel: Wheel
var landed_slot: WheelSlot

var is_spinning: bool = false
var is_decelerating: bool = false
var is_falling: bool = false
var is_bouncing: bool = false
var landed: bool = false

var bounce_radius: float = 0
var bounce_target: float = 0
var bounces_left: int = 6


func _ready() -> void:
	randomize()
	is_decelerating = false
	reference_angle = atan(position.y/position.x)
	time_elapsed = 0
	await get_tree().create_timer(2).timeout
	current_radius = target_wheel.get_node("WheelGenerator").outer_radius+20
	start()
	await get_tree().create_timer(randf_range(0, (2*PI)/initial_speed)).timeout
	start_deceleration()


func _process(delta: float) -> void:
	if is_spinning == true and landed == false:
		time_elapsed += delta
		position = position_at_time(time_elapsed)
	if speed_at_time(time_elapsed) <= fall_speed and is_falling == false:
		is_falling = true
		choose_bounce_radius()
	if is_falling == true and is_bouncing == false:
		current_radius = lerp(float(current_radius), float(target_wheel.radius), delta*6)
		if current_radius <= bounce_radius and bounces_left > 0:
			bounce()
	if is_bouncing == true:
		current_radius = lerp(float(current_radius), float(bounce_target), delta*7)
		if current_radius >= bounce_target-1.5:
			is_bouncing = false
			if bounces_left > 0:
				choose_bounce_radius()
				bounces_left -= 1
	if speed_at_time(time_elapsed) <= 0.1 and bounces_left <= 0 and $SlotDetector.get_overlapping_areas().size() == 1 and landed == false:
		if $SlotDetector.get_overlapping_areas()[0].get_parent().is_occupied == false:
			is_spinning = false
			landed = true
			landed_slot = $SlotDetector.get_overlapping_areas()[0].get_parent()
			landed_slot.is_occupied = true
	elif speed_at_time(time_elapsed) <= -0.5 and bounces_left <= 0:
		is_spinning = false
	if landed == true:
		global_position = landed_slot.get_node("BallCollision").global_position


func start_deceleration() -> void:
	reference_angle = angle_from_time(time_elapsed)
	time_elapsed = 0
	is_decelerating = true


func angle_from_time(time) -> float:
	return reference_angle + -initial_speed*time + -0.5*acceleration*(time**2)


func polar_to_cartesian(radius, angle) -> Vector2:
	return Vector2(radius*cos(angle), radius*sin(angle))


func position_at_time(time) -> Vector2:
	return polar_to_cartesian(current_radius, angle_from_time(time))


func speed_at_time(time) -> float:
	return initial_speed + acceleration*time


func start() -> void:
	is_spinning = true


func bounce() -> void:
	is_bouncing = true
	choose_bounce_target()


func choose_bounce_radius() -> void:
	bounce_radius = randf_range(float(target_wheel.radius)+5, float(target_wheel.radius)+15)


func choose_bounce_target() -> void:
	bounce_target = bounce_radius + randf_range(0.7, 1)*(bounces_left+1)*3
