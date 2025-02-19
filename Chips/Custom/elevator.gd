extends Chip

@export var value_change: int = 0


func apply_effect(_wheel: Wheel, wheel_slot: WheelSlot, _result: int, payout: float) -> float:
	if enabled:
		wheel_slot.number += value_change
		wheel_slot.generate_slot_shape()
	return payout
