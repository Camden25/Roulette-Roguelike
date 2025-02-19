extends Node
class_name InventoryManager

var money: int = 10
var owned_chips: Array[String]


func spend_money(amount: int) -> bool:
	if money >= amount:
		money -= amount
		return true
	return false
