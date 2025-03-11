extends Area2D
class_name BettingSection


@export var section_name: String
@export var max_chips: int

var chips: Array


func _init() -> void:
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)


func _ready() -> void:
	determine_chips()


@warning_ignore("unused_parameter")
func can_trigger(value: int, color: int) -> bool:
	return false


func apply_chips(wheel: Wheel, wheel_slot: WheelSlot, result: int, base_payout: float) -> float:
	var modified_payout = base_payout
	for chip in chips:
		modified_payout = chip.apply_effect(wheel, wheel_slot, result, modified_payout)
		print(chip.name+": "+str(modified_payout))
	print(name+": "+str(modified_payout))
	return modified_payout


func determine_chip_location(chip: Chip) -> Vector2:
	var location: Vector2
	
	location.y = global_position.y
	location.x = float((2*chips.find(chip)+1)/float(2*len(chips)))*$CollisionShape2D.shape.size.x-$CollisionShape2D.shape.size.x/2+global_position.x
	
	return location


func determine_chips() -> void:
	chips = get_children().filter(func(child): return child is Chip)


func _on_area_entered(area) -> void:
	if area is Chip:
		if area.bet_type.has(section_name) and len(chips) < max_chips:
			area.set_potential_section(self)
	
	if area is ShopChip:
		if area.chip.bet_type.has(section_name) and len(chips) < max_chips:
			area.set_potential_section(self)


func _on_area_exited(area) -> void:
	if area is Chip:
		if area.potential_section == self:
			area.clear_potential_section()
	
	if area is ShopChip:
		if area.potential_section == self:
			area.clear_potential_section()
