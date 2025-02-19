@tool
extends Node2D
class_name WheelSlot

#editor buttons
@export var generate_slot: bool:
	set(value):
		generate_slot_shape()

@export var number: int
@export var color: int #0:Red, 1:Black, 2:Green
var colors: Array[Color] = [Color("c51919"), Color("181818"), Color("65c34a")]

var inner_radius: int = 200
var outer_radius: int = 225
var amount_of_slots: int = 37

#flags
var is_occupied: bool = false


func generate_slot_shape() -> void:
	var inner_length = 2 * inner_radius * sin(PI / amount_of_slots)
	var outer_length = 2 * outer_radius * sin(PI / amount_of_slots)
	$Shape.polygon = [Vector2(-inner_length/2,-inner_radius),Vector2(inner_length/2,-inner_radius),Vector2(outer_length/2,-outer_radius),Vector2(-outer_length/2,-outer_radius)]
	$Shape.color = colors[int(color)]
	
	$Number.text = str(number)
	$Number.position.y = -outer_radius
	$Number.position.x = -outer_length/2
	$Number.size.x = outer_length
	$Number.size.y = outer_radius-inner_radius
	
	$BallCollision.position.y = -outer_radius+(outer_radius-inner_radius)/2.0
	$BallCollision/CollisionShape2D.shape.size = Vector2(inner_length-2, (outer_radius-inner_radius)-3)
