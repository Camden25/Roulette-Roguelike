extends Node
class_name RoundManager


@export var active_wheel: Wheel

@onready var score_manager: ScoreManager = get_tree().get_first_node_in_group("ScoreManager")

#flags
var round_over: bool = false
var shop_open: bool = false


func _ready() -> void:
	randomize()
	await get_tree().create_timer(2).timeout
	start_round()


func _process(_delta: float) -> void:
	var stopped_balls: int = 0
	for ball: Ball in active_wheel.active_balls:
		if ball.landed == true:
			stopped_balls += 1
	if round_over == false and stopped_balls == len(active_wheel.active_balls):
		end_round()


func start_round() -> void:
	round_over = false
	active_wheel.spin()
	for ball: Ball in active_wheel.active_balls:
		ball.start()


func end_round() -> void:
	round_over = true
	print(score_manager.clalculate_total_score())
	await get_tree().create_timer(2).timeout
	for ball: Ball in active_wheel.active_balls:
		ball.reset()
		ball.choose_random_position()
	await get_tree().create_timer(1.5).timeout
	start_round()
