@tool
extends Node2D

@export var generate_wheel: bool:
	set(value):
		value = false
		generate_wheel_shape()
@export var reset_wheel: bool:
	set(value):
		value = false
		for i in wheel_parent.get_children():
			i.queue_free()
@export var inner_radius: int = 200
@export var outer_radius: int = 225
@export var number_order: Array[int]
@export var color_order: Array[int]
@export var wheel_slot_scene: PackedScene
@export var wheel_parent: Node2D


func generate_wheel_shape() -> void:
	for i in range(len(number_order)):
		var wheel_slot_instance: WheelSlot = wheel_slot_scene.instantiate()
		wheel_slot_instance.inner_radius = inner_radius
		wheel_slot_instance.outer_radius = outer_radius
		wheel_slot_instance.amount_of_slots = len(number_order)
		wheel_slot_instance.number = number_order[i]
		wheel_slot_instance.color = color_order[i]
		wheel_slot_instance.rotation = (2*PI*i)/len(number_order)
		wheel_slot_instance.generate_slot_shape()
		wheel_parent.add_child(wheel_slot_instance)
