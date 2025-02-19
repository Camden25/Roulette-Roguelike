extends Area2D
class_name Chip


@export var chip_name: String = "Default Chip"
@export var texture: Texture
@export var bet_type: Array[String] = ["any"]  # red, black, even, odd, high, low, 12
@export var score_change: float = 0.0
@export var multiplier: float = 1.0

var offset: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var lerp_speed: float = 0.2
var potential_section: BettingSection
var previous_section: BettingSection

#flags
var enabled: bool = true
var dragging := false


# Called when the bet is being evaluated
@warning_ignore("unused_parameter")
func apply_effect(wheel: Wheel, wheel_slot: WheelSlot, result: int, payout: float) -> float:
	if enabled:
		payout += score_change
		payout *= multiplier
	return payout


func _ready() -> void:
	if get_parent() is BettingSection:
		previous_section = get_parent()
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
		reparent(potential_section)
		previous_section.determine_chips()
		potential_section.determine_chips()
		previous_section = potential_section
		potential_section = null
	if get_parent() is BettingSection:
		target_position = get_parent().determine_chip_location(self)


func create_image() -> void:
	var chip_image: Sprite2D = Sprite2D.new()
	chip_image.texture = texture
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


func clear_potential_section() -> void:
	potential_section = null
