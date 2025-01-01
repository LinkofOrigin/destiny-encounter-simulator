class_name ShapeSpawner
extends Node

enum SHAPES_2D {
	CIRCLE,
	TRIANGLE,
	SQUARE,
}

enum SHAPES_3D {
	SPHERE,
	CUBE,
	PYRAMID,
	CYLINDER,
	CONE,
	PRISM,
}

@export var new_shape_parent: Node3D

# 2D Shapes
var circle_packed := preload("res://encounters/verity/shapes/2d_shapes/circle_2d.tscn")
var triangle_packed := preload("res://encounters/verity/shapes/2d_shapes/triangle_2d.tscn")
var square_packed := preload("res://encounters/verity/shapes/2d_shapes/square_2d.tscn")

# 3D Shapes
var sphere_packed := preload("res://encounters/verity/shapes/3d_shapes/sphere.tscn")
var cube_packed := preload("res://encounters/verity/shapes/3d_shapes/cube.tscn")
var pyramid_packed := preload("res://encounters/verity/shapes/3d_shapes/pyramid.tscn")
var cylinder_packed := preload("res://encounters/verity/shapes/3d_shapes/cylinder.tscn")
var cone_packed := preload("res://encounters/verity/shapes/3d_shapes/cone.tscn")
var prism_packed := preload("res://encounters/verity/shapes/3d_shapes/prism.tscn")

var _2d_shape_scene_mapping := {
	SHAPES_2D.CIRCLE: circle_packed,
	SHAPES_2D.TRIANGLE: triangle_packed,
	SHAPES_2D.SQUARE: square_packed,
}
var _3d_shape_scene_mapping := {
	SHAPES_3D.SPHERE: sphere_packed,
	SHAPES_3D.CUBE: cube_packed,
	SHAPES_3D.PYRAMID: pyramid_packed,
	SHAPES_3D.CYLINDER: cylinder_packed,
	SHAPES_3D.CONE: cone_packed,
	SHAPES_3D.PRISM: prism_packed,
}


func spawn_new_2d_shape_at_location(shape: SHAPES_2D, location: Vector3) -> Base2DShape:
	var new_shape: Base2DShape = create_new_2d_shape(shape)
	var shape_parent := new_shape_parent
	if shape_parent == null:
		shape_parent = owner
	
	shape_parent.add_child(new_shape)
	new_shape.global_position = location
	return new_shape


func create_new_2d_shape(shape: SHAPES_2D) -> Base2DShape:
	var new_shape: Base2DShape = (_2d_shape_scene_mapping[shape] as PackedScene).instantiate()
	return new_shape


func create_new_3d_shape(shape: SHAPES_3D) -> Base3DShape:
	var new_shape: Base3DShape = (_3d_shape_scene_mapping[shape] as PackedScene).instantiate()
	return new_shape
