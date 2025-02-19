extends BettingSection


func can_trigger(_value: int, color: int) -> bool:
	if color == 0:
		return true
	else:
		return false
