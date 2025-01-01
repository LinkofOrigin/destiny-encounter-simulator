extends Node3D

@onready var statues_3d: Node3D = %Statues3D
@onready var statues_2d: Node3D = %Statues2D

var test_3d_shapes := [
	ShapeSpawner.SHAPES_3D.SPHERE,
	ShapeSpawner.SHAPES_3D.CUBE,
	ShapeSpawner.SHAPES_3D.PYRAMID,
	ShapeSpawner.SHAPES_3D.CYLINDER,
	ShapeSpawner.SHAPES_3D.CONE,
	ShapeSpawner.SHAPES_3D.PRISM,
]

var test_2d_shapes := [
	ShapeSpawner.SHAPES_2D.CIRCLE,
	ShapeSpawner.SHAPES_2D.TRIANGLE,
	ShapeSpawner.SHAPES_2D.SQUARE,
]

func _ready() -> void:
	var all_3d_statues := statues_3d.find_children("*", "Statue")
	var curr_shape_index := 0
	for statue: Statue in all_3d_statues:
		statue.create_and_hold_3d_shape(test_3d_shapes[curr_shape_index])
		curr_shape_index += 1
	
	var all_2d_statues := statues_2d.find_children("*", "Statue")
	curr_shape_index = 0
	for statue: Statue in all_2d_statues:
		statue.create_and_hold_2d_shape(test_2d_shapes[curr_shape_index])
		curr_shape_index += 1
