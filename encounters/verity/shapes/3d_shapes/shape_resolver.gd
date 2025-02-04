class_name ShapeResolver
extends Resource

const SPHERE_EFFECT: Shape3DEffectData = preload("res://systems/core/components/effect_management/effect_resources/shapes/3d_shapes/sphere_effect.tres")
const CUBE_EFFECT: Shape3DEffectData = preload("res://systems/core/components/effect_management/effect_resources/shapes/3d_shapes/cube_effect.tres")
const PYRAMID_EFFECT: Shape3DEffectData = preload("res://systems/core/components/effect_management/effect_resources/shapes/3d_shapes/pyramid_effect.tres")
const CYLINDER_EFFECT: Shape3DEffectData = preload("res://systems/core/components/effect_management/effect_resources/shapes/3d_shapes/cylinder_effect.tres")
const PRISM_EFFECT: Shape3DEffectData = preload("res://systems/core/components/effect_management/effect_resources/shapes/3d_shapes/prism_effect.tres")
const CONE_EFFECT: Shape3DEffectData = preload("res://systems/core/components/effect_management/effect_resources/shapes/3d_shapes/cone_effect.tres")

var shape_map := {
	[SPHERE_EFFECT.get_first_type().shape, SPHERE_EFFECT.get_second_type().shape]: SPHERE_EFFECT,
	[CUBE_EFFECT.get_first_type().shape, CUBE_EFFECT.get_second_type().shape]: CUBE_EFFECT,
	[PYRAMID_EFFECT.get_first_type().shape, PYRAMID_EFFECT.get_second_type().shape]: PYRAMID_EFFECT,
	[CYLINDER_EFFECT.get_first_type().shape, CYLINDER_EFFECT.get_second_type().shape]: CYLINDER_EFFECT,
	[PRISM_EFFECT.get_first_type().shape, PRISM_EFFECT.get_second_type().shape]: PRISM_EFFECT,
	[CONE_EFFECT.get_first_type().shape, CONE_EFFECT.get_second_type().shape]: CONE_EFFECT,
}

var composition_map := {
	EffectLibrary.SHAPE_3D_TYPES.SPHERE: SPHERE_EFFECT,
	EffectLibrary.SHAPE_3D_TYPES.CUBE: CUBE_EFFECT,
	EffectLibrary.SHAPE_3D_TYPES.PYRAMID: PYRAMID_EFFECT,
	EffectLibrary.SHAPE_3D_TYPES.CYLINDER: CYLINDER_EFFECT,
	EffectLibrary.SHAPE_3D_TYPES.PRISM: PRISM_EFFECT,
	EffectLibrary.SHAPE_3D_TYPES.CONE: CONE_EFFECT,
}

func alter_shape(shape_3d: Shape3DEffectData, remove_shape: Shape2DEffectData, add_shape: Shape2DEffectData) -> Shape3DEffectData:
	var shape_array := [shape_3d.get_first_type(), shape_3d.get_second_type()]
	if shape_array[0] == remove_shape:
		shape_array[0] = add_shape
	elif shape_array[1] == remove_shape:
		shape_array[1] = add_shape
	else:
		printerr("Invalid shape stuff!")
		return null
	
	# TODO: This doesn't work because the values can be swapped?? Getting errors
	var shape_map_key := [(shape_array[0] as Shape2DEffectData).shape, (shape_array[1] as Shape2DEffectData).shape]
	if shape_map.get(shape_map_key) == null:
		# If the order is "backwards" from our mapping above, just swap and try again
		shape_map_key.reverse()
	return (shape_map[shape_map_key] as Shape3DEffectData).duplicate()


func determine_3d_shape(first_2d_shape: EffectLibrary.SHAPE_2D_TYPES, second_2d_shape: EffectLibrary.SHAPE_2D_TYPES) -> EffectLibrary.SHAPE_3D_TYPES:
	var shapes_array := [first_2d_shape, second_2d_shape]
	if shape_map.get(shapes_array) == null:
		# If the order is "backwards" from our mapping above, just swap and try again
		shapes_array.reverse()
	
	var shape: Shape3DEffectData = shape_map.get(shapes_array)
	if shape != null:
		return shape.shape
	return -1


func determine_2d_shapes(shape_3d: EffectLibrary.SHAPE_3D_TYPES) -> Array[EffectLibrary.SHAPE_2D_TYPES]:
	var shape_3d_effect: Shape3DEffectData = composition_map[shape_3d]
	return [shape_3d_effect.get_first_type().shape, shape_3d_effect.get_second_type().shape]
