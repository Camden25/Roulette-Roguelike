extends Area2D
class_name ShopChip


var chip: Chip

var offset: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var lerp_speed: float = 0.2
var potential_section: BettingSection

#flags
var dragging: bool = false


func _ready() -> void:
	create_image()
	create_collision()


func _input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dragging = true
			offset = global_position - event.global_position
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dragging = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		dragging = false


func _process(_delta) -> void:
	if dragging:
		modulate = Color(1, 1, 1, 0.7)
		target_position = get_viewport().get_mouse_position() + offset
	else:
		modulate = Color(1, 1, 1, 1)
		snap_to_betting_section()
	
	global_position = lerp(global_position, target_position, lerp_speed)


func snap_to_betting_section() -> void:
	if potential_section and potential_section is BettingSection:
		chip.global_position = global_position
		potential_section.add_child(chip)
	else:
		target_position = get_parent().global_position


func create_image() -> void:
	var chip_image: Sprite2D = Sprite2D.new()
	chip_image.texture = chip.texture
	add_child(chip_image)


func create_collision() -> void:
	var chip_collision: CollisionShape2D = CollisionShape2D.new()
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)
	set_collision_mask_value(1, false)
	set_collision_mask_value(4, true)
	
	chip_collision.shape = CircleShape2D.new()
	chip_collision.shape.radius = 32
	add_child(chip_collision)


func set_potential_section(section: BettingSection) -> void:
	potential_section = section
