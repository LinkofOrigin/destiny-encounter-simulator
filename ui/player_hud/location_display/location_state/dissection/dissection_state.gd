class_name DissectionState
extends LocationState

@export var circle_texture: Texture2D
@export var triangle_texture: Texture2D
@export var square_texture: Texture2D
@export var sphere_texture: Texture2D
@export var pyramid_texture: Texture2D
@export var cube_texture: Texture2D
@export var cylinder_texture: Texture2D
@export var cone_texture: Texture2D
@export var prism_texture: Texture2D
@export var correct_texture: Texture2D
@export var wrong_texture: Texture2D

@onready var left_2d_key_icon: TextureRect = %Left2DKeyIcon
@onready var left_2d_key_label: Label = %Left2DKeyLabel
@onready var middle_2d_key_icon: TextureRect = %Middle2DKeyIcon
@onready var middle_2d_key_label: Label = %Middle2DKeyLabel
@onready var right_2d_key_icon: TextureRect = %Right2DKeyIcon
@onready var right_2d_key_label: Label = %Right2DKeyLabel
@onready var statue_one_icon: TextureRect = %StatueOneIcon
@onready var statue_one_shape_text: Label = %StatueOneShapeText
@onready var statue_two_icon: TextureRect = %StatueTwoIcon
@onready var statue_two_shape_text: Label = %StatueTwoShapeText
@onready var statue_three_icon: TextureRect = %StatueThreeIcon
@onready var statue_three_shape_text: Label = %StatueThreeShapeText
@onready var left_key_match_indicator: TextureRect = %LeftKeyMatchIndicator
@onready var middle_key_match_indicator: TextureRect = %MiddleKeyMatchIndicator
@onready var right_key_match_indicator: TextureRect = %RightKeyMatchIndicator


func set_2d_shapes(left_shape: EffectLibrary.SHAPE_2D_TYPES, middle_shape: EffectLibrary.SHAPE_2D_TYPES, right_shape: EffectLibrary.SHAPE_2D_TYPES) -> void:
	var left_details := _get_2d_display_details(left_shape)
	var middle_details := _get_2d_display_details(middle_shape)
	var right_details := _get_2d_display_details(right_shape)
	
	left_2d_key_label.text = left_details[0]
	left_2d_key_icon.texture = left_details[1]
	middle_2d_key_label.text = middle_details[0]
	middle_2d_key_icon.texture = middle_details[1]
	right_2d_key_label.text = right_details[0]
	right_2d_key_icon.texture = right_details[1]


func set_3d_shapes(left_shape: EffectLibrary.SHAPE_3D_TYPES, middle_shape: EffectLibrary.SHAPE_3D_TYPES, right_shape: EffectLibrary.SHAPE_3D_TYPES) -> void:
	set_left_3d_shape(left_shape)
	set_middle_3d_shape(middle_shape)
	set_right_3d_shape(right_shape)


func set_left_3d_shape(new_shape: EffectLibrary.SHAPE_3D_TYPES) -> void:
	var details := _get_3d_display_details(new_shape)
	statue_one_icon.text = details[0]
	statue_one_shape_text.texture = details[1]


func set_middle_3d_shape(new_shape: EffectLibrary.SHAPE_3D_TYPES) -> void:
	var details := _get_3d_display_details(new_shape)
	statue_two_icon.text = details[0]
	statue_two_shape_text.texture = details[1]


func set_right_3d_shape(new_shape: EffectLibrary.SHAPE_3D_TYPES) -> void:
	var details := _get_3d_display_details(new_shape)
	statue_three_icon.text = details[0]
	statue_three_shape_text.texture = details[1]


func _get_2d_display_details(shape_2d: EffectLibrary.SHAPE_2D_TYPES) -> Array:
	match shape_2d:
		EffectLibrary.SHAPE_2D_TYPES.CIRCLE:
			return ["Circle", circle_texture]
		EffectLibrary.SHAPE_2D_TYPES.TRIANGLE:
			return ["Triangle", triangle_texture]
		EffectLibrary.SHAPE_2D_TYPES.SQUARE:
			return ["Square", square_texture]
	return []


func _get_3d_display_details(shape_3d: EffectLibrary.SHAPE_3D_TYPES) -> Array:
	match shape_3d:
		EffectLibrary.SHAPE_3D_TYPES.SPHERE:
			return ["Sphere", sphere_texture]
		EffectLibrary.SHAPE_3D_TYPES.CUBE:
			return ["Cube", cube_texture]
		EffectLibrary.SHAPE_3D_TYPES.PYRAMID:
			return ["Pyramid", pyramid_texture]
		EffectLibrary.SHAPE_3D_TYPES.CYLINDER:
			return ["Cylinder", cylinder_texture]
		EffectLibrary.SHAPE_3D_TYPES.CONE:
			return ["Cone", cone_texture]
		EffectLibrary.SHAPE_3D_TYPES.PRISM:
			return ["Prism", prism_texture]
	return []


func set_left_key_matching(is_matching: bool) -> void:
	if is_matching:
		left_key_match_indicator.texture = correct_texture
	else:
		left_key_match_indicator.texture = wrong_texture


func set_middle_key_matching(is_matching: bool) -> void:
	if is_matching:
		middle_key_match_indicator.texture = correct_texture
	else:
		middle_key_match_indicator.texture = wrong_texture


func set_right_key_matching(is_matching: bool) -> void:
	if is_matching:
		right_key_match_indicator.texture = correct_texture
	else:
		right_key_match_indicator.texture = wrong_texture
