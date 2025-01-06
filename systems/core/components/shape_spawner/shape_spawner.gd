class_name ShapeSpawner
extends Node

# 2D Shapes
const circle_packed := preload("res://encounters/verity/shapes/2d_shapes/circle_2d.tscn")
const triangle_packed := preload("res://encounters/verity/shapes/2d_shapes/triangle_2d.tscn")
const square_packed := preload("res://encounters/verity/shapes/2d_shapes/square_2d.tscn")
const CIRCLE_SPRITE = preload("res://encounters/verity/shapes/2d_shapes/circle_sprite.tscn")
const SQUARE_SPRITE = preload("res://encounters/verity/shapes/2d_shapes/square_sprite.tscn")
const TRIANGLE_SPRITE = preload("res://encounters/verity/shapes/2d_shapes/triangle_sprite.tscn")

# 3D Shapes
const sphere_packed := preload("res://encounters/verity/shapes/3d_shapes/sphere.tscn")
const cube_packed := preload("res://encounters/verity/shapes/3d_shapes/cube.tscn")
const pyramid_packed := preload("res://encounters/verity/shapes/3d_shapes/pyramid.tscn")
const cylinder_packed := preload("res://encounters/verity/shapes/3d_shapes/cylinder.tscn")
const cone_packed := preload("res://encounters/verity/shapes/3d_shapes/cone.tscn")
const prism_packed := preload("res://encounters/verity/shapes/3d_shapes/prism.tscn")

const _2d_shape_sprite_mapping := {
	EffectLibrary.SHAPE_2D_TYPES.CIRCLE: CIRCLE_SPRITE,
	EffectLibrary.SHAPE_2D_TYPES.TRIANGLE: TRIANGLE_SPRITE,
	EffectLibrary.SHAPE_2D_TYPES.SQUARE: SQUARE_SPRITE,
}
const _2d_shape_scene_mapping := {
	EffectLibrary.SHAPE_2D_TYPES.CIRCLE: circle_packed,
	EffectLibrary.SHAPE_2D_TYPES.TRIANGLE: triangle_packed,
	EffectLibrary.SHAPE_2D_TYPES.SQUARE: square_packed,
}
const _3d_shape_scene_mapping := {
	EffectLibrary.SHAPE_3D_TYPES.SPHERE: sphere_packed,
	EffectLibrary.SHAPE_3D_TYPES.CUBE: cube_packed,
	EffectLibrary.SHAPE_3D_TYPES.PYRAMID: pyramid_packed,
	EffectLibrary.SHAPE_3D_TYPES.CYLINDER: cylinder_packed,
	EffectLibrary.SHAPE_3D_TYPES.CONE: cone_packed,
	EffectLibrary.SHAPE_3D_TYPES.PRISM: prism_packed,
}


func create_new_2d_sprite(shape: EffectLibrary.SHAPE_2D_TYPES) -> Sprite3D:
	var new_shape: Sprite3D = (_2d_shape_sprite_mapping[shape] as PackedScene).instantiate()
	return new_shape


func create_new_2d_shape(shape: EffectLibrary.SHAPE_2D_TYPES) -> Base2DShape:
	var new_shape: Base2DShape = (_2d_shape_scene_mapping[shape] as PackedScene).instantiate()
	return new_shape


func create_new_3d_shape(shape: EffectLibrary.SHAPE_3D_TYPES) -> Base3DShape:
	var new_shape: Base3DShape = (_3d_shape_scene_mapping[shape] as PackedScene).instantiate()
	return new_shape
