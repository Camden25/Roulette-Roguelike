extends BettingSection


func can_trigger(value: int, _color: int) -> bool:
	if value%2 == 0:
		return true
	else:
		return false
