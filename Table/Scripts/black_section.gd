extends BettingSection


func can_trigger(_value: int, color: int) -> bool:
	if color == 1:
		return true
	else:
		return false
