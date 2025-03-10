extends Node
class_name GameManager


@onready var round_manager: RoundManager = get_tree().get_first_node_in_group("RoundManager")
@onready var shop_manager: ShopManager = get_tree().get_first_node_in_group("ShopManager")


func _ready() -> void:
	start_round()


func start_round() -> void:
	round_manager.start_round()


func round_over() -> void:
	start_shop()


func start_shop() -> void:
	shop_manager.open_shop()


func shop_closed() -> void:
	pass
