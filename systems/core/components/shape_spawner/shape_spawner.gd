class_name ShapeSpawner
extends Node

enum SHAPES {CIRCLE, TRIANGLE, SQUARE}

@export var new_shape_parent: Node3D

var circle_packed := preload("res://encounters/verity/shapes/2d_shapes/circle_2d.tscn")
var triangle_packed := preload("res://encounters/verity/shapes/2d_shapes/triangle_2d.tscn")
var square_packed := preload("res://encounters/verity/shapes/2d_shapes/square_2d.tscn")


func spawn_new_shape_at_location(shape: SHAPES, location: Vector3, parent: Node3D = null):
	var new_shape := _create_shape_by_id(shape)
	var shape_parent = new_shape_parent
	if shape_parent == null:
		shape_parent = owner
	
	shape_parent.add_child(new_shape)
	new_shape.global_position = location


func _create_shape_by_id(shape_id: SHAPES) -> ShapeBase2D:
	if shape_id == SHAPES.CIRCLE:
		return circle_packed.instantiate()
	elif shape_id == SHAPES.TRIANGLE:
		return triangle_packed.instantiate()
	elif shape_id == SHAPES.SQUARE:
		return square_packed.instantiate()
	else:
		printerr("TRIED TO CREATE SHAPE FOR UNKNOWN ID!!")
		return null
