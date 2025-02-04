class_name Shape3DEffectData
extends ShapeEffectData

@export var shape: EffectLibrary.SHAPE_3D_TYPES ## The noted type of 3D shape
@export var comprised_type_one: EffectLibrary.SHAPE_2D_TYPES ## First type this 3D shape is comprised of
@export var comprised_type_two: EffectLibrary.SHAPE_2D_TYPES ## Second type this 3D shape is comprised of

const CIRCLE: Shape2DEffectData = preload("res://systems/core/components/effect_management/effect_resources/shapes/2d_shapes/circle_effect.tres")
const SQUARE: Shape2DEffectData = preload("res://systems/core/components/effect_management/effect_resources/shapes/2d_shapes/square_effect.tres")
const TRIANGLE: Shape2DEffectData = preload("res://systems/core/components/effect_management/effect_resources/shapes/2d_shapes/triangle_effect.tres")

const _shape_resource_mapping := {
	EffectLibrary.SHAPE_2D_TYPES.CIRCLE: CIRCLE,
	EffectLibrary.SHAPE_2D_TYPES.TRIANGLE: TRIANGLE,
	EffectLibrary.SHAPE_2D_TYPES.SQUARE: SQUARE,
}


func get_first_type() -> Shape2DEffectData:
	return _map_type_to_resource(comprised_type_one)


func get_second_type() -> Shape2DEffectData:
	return _map_type_to_resource(comprised_type_two)


func contains(shape_2d: EffectLibrary.SHAPE_2D_TYPES) -> bool:
	return comprised_type_one == shape_2d or comprised_type_two == shape_2d


func _map_type_to_resource(value: EffectLibrary.SHAPE_2D_TYPES) -> Shape2DEffectData:
	if _shape_resource_mapping[value] != null:
		var shape_data: Shape2DEffectData = _shape_resource_mapping[value]
		return _shape_resource_mapping[value] as Shape2DEffectData
	
	printerr("Tried to get 2D effect type and received invalid type! Type: ", value)
	return null
