extends Control
class_name ShopManager

var available_chips: Array[PackedScene] = []

@onready var shop_ui = $ShopUI
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var game_manager: GameManager = get_tree().get_first_node_in_group("GameManager")


func open_shop():
	#shop_ui.visible = true
	animation.play("open_shop")
	generate_shop_items()


func close_shop():
	#shop_ui.visible = false
	animation.play("close_shop")
	game_manager.shop_closed()


func generate_shop_items():
	available_chips.clear()
	var chip_pool = ChipDatabase.get_random_chips(3)
	available_chips.append_array(chip_pool)
	
	
	# Update the shop UI with new items
	for i in range(available_chips.size()):
		var item = available_chips[i]
		print(item.instantiate().name)
		var shop_chip: ShopChip = ShopChip.new()
		shop_chip.chip = item.instantiate()
		shop_ui.get_node("Chips").get_node(str(i)).add_child(shop_chip)
