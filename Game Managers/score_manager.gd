extends Node
class_name ScoreManager


@export var active_wheel: Wheel
@export var betting_sections: Array[BettingSection]

@onready var round_manager: RoundManager = get_tree().get_first_node_in_group("RoundManager")


func clalculate_total_score() -> float:
	var total_score: float = 0
	for ball: Ball in active_wheel.active_balls:
		var ball_score: float = 0
		if ball.landed:
			var wheel_slot: WheelSlot = ball.landed_slot
			ball_score = wheel_slot.number
			print("Initial score from "+ball.name+": "+str(ball_score))
			for section: BettingSection in betting_sections:
				if section.can_trigger(wheel_slot.number, wheel_slot.color):
					ball_score = section.apply_chips(active_wheel, wheel_slot, wheel_slot.number, ball_score)
		total_score += ball_score
	return total_score
