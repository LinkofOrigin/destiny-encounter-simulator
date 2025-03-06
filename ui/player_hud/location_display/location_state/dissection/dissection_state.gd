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

# Key nodes
@onready var left_2d_key_icon: TextureRect = %Left2DKeyIcon
@onready var left_2d_key_label: Label = %Left2DKeyLabel
@onready var middle_2d_key_icon: TextureRect = %Middle2DKeyIcon
@onready var middle_2d_key_label: Label = %Middle2DKeyLabel
@onready var right_2d_key_icon: TextureRect = %Right2DKeyIcon
@onready var right_2d_key_label: Label = %Right2DKeyLabel

# Statue nodes
@onready var statues_3d_title: PanelContainer = %Statues3DTitle
@onready var statue_one: PanelContainer = %StatueOne
@onready var statue_two: PanelContainer = %StatueTwo
@onready var statue_three: PanelContainer = %StatueThree
@onready var statue_one_icon: TextureRect = %StatueOneIcon
@onready var statue_one_shape_text: Label = %StatueOneShapeText
@onready var statue_two_icon: TextureRect = %StatueTwoIcon
@onready var statue_two_shape_text: Label = %StatueTwoShapeText
@onready var statue_three_icon: TextureRect = %StatueThreeIcon
@onready var statue_three_shape_text: Label = %StatueThreeShapeText

# Shape Composition (ie. shape logic or "math")
@onready var shape_comp_title: PanelContainer = %ShapeCompTitle
@onready var composing_shapes_left: PanelContainer = %ComposingShapesLeft
@onready var composing_shapes_middle: PanelContainer = %ComposingShapesMiddle
@onready var composing_shapes_right: PanelContainer = %ComposingShapesRight
@onready var left_composing_shape_one_icon: TextureRect = %LeftComposingShapeOneIcon
@onready var left_composing_shape_one_label: Label = %LeftComposingShapeOneLabel
@onready var left_composing_shape_two_icon: TextureRect = %LeftComposingShapeTwoIcon
@onready var left_composing_shape_two_label: Label = %LeftComposingShapeTwoLabel
@onready var middle_composing_shape_one_icon: TextureRect = %MiddleComposingShapeOneIcon
@onready var middle_composing_shape_one_label: Label = %MiddleComposingShapeOneLabel
@onready var middle_composing_shape_two_icon: TextureRect = %MiddleComposingShapeTwoIcon
@onready var middle_composing_shape_two_label: Label = %MiddleComposingShapeTwoLabel
@onready var right_composing_shape_one_icon: TextureRect = %RightComposingShapeOneIcon
@onready var right_composing_shape_one_label: Label = %RightComposingShapeOneLabel
@onready var right_composing_shape_two_icon: TextureRect = %RightComposingShapeTwoIcon
@onready var right_composing_shape_two_label: Label = %RightComposingShapeTwoLabel

# Match nodes
@onready var matches_title: PanelContainer = %MatchesTitle
@onready var left_key_match: PanelContainer = %LeftKeyMatch
@onready var middle_key_match: PanelContainer = %MiddleKeyMatch
@onready var right_key_match: PanelContainer = %RightKeyMatch
@onready var left_key_match_indicator: TextureRect = %LeftKeyMatchIndicator
@onready var middle_key_match_indicator: TextureRect = %MiddleKeyMatchIndicator
@onready var right_key_match_indicator: TextureRect = %RightKeyMatchIndicator

var dissecting_keys_mechanic: DissectingKeysMechanic:
	set = set_dissecting_keys_mechanic


func set_dissecting_keys_mechanic(new_dissecting_keys_mechanic: DissectingKeysMechanic) -> void:
	dissecting_keys_mechanic = new_dissecting_keys_mechanic
	dissecting_keys_mechanic.key_shapes_set.connect(_on_key_shapes_set)
	dissecting_keys_mechanic.shapes_matches_updated.connect(_on_shape_matches_updated)
	dissecting_keys_mechanic.statue_shapes_updated.connect(_on_statue_shapes_updated)


func set_dissection_options_menu(new_dissection_options: DissectionOptions) -> void:
	new_dissection_options.hint_display_settings_changed.connect(_update_hint_display_settings)


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
	statue_one_shape_text.text = details[0]
	statue_one_icon.texture = details[1]
	set_left_composing_shapes_for(new_shape)


func set_middle_3d_shape(new_shape: EffectLibrary.SHAPE_3D_TYPES) -> void:
	var details := _get_3d_display_details(new_shape)
	statue_two_shape_text.text = details[0]
	statue_two_icon.texture = details[1]
	set_middle_composing_shapes_for(new_shape)


func set_right_3d_shape(new_shape: EffectLibrary.SHAPE_3D_TYPES) -> void:
	var details := _get_3d_display_details(new_shape)
	statue_three_shape_text.text = details[0]
	statue_three_icon.texture = details[1]
	set_right_composing_shapes_for(new_shape)


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


func set_left_composing_shapes_for(shape_3d: EffectLibrary.SHAPE_3D_TYPES) -> void:
	_set_composing_shape_details_for(
		shape_3d,
		left_composing_shape_one_icon,
		left_composing_shape_one_label,
		left_composing_shape_two_icon,
		left_composing_shape_two_label
	)


func set_middle_composing_shapes_for(shape_3d: EffectLibrary.SHAPE_3D_TYPES) -> void:
	_set_composing_shape_details_for(
		shape_3d,
		middle_composing_shape_one_icon,
		middle_composing_shape_one_label,
		middle_composing_shape_two_icon,
		middle_composing_shape_two_label
	)


func set_right_composing_shapes_for(shape_3d: EffectLibrary.SHAPE_3D_TYPES) -> void:
	_set_composing_shape_details_for(
		shape_3d,
		right_composing_shape_one_icon,
		right_composing_shape_one_label,
		right_composing_shape_two_icon,
		right_composing_shape_two_label
	)


func _set_composing_shape_details_for(shape_3d: EffectLibrary.SHAPE_3D_TYPES, icon_one: TextureRect, label_one: Label, icon_two: TextureRect, label_two: Label) -> void:
	var names_and_textures := _get_composing_shapes_for_3d_shape(shape_3d)
	var texture_one: Texture2D = names_and_textures.get("shape_one")[1]
	var name_one: String = names_and_textures.get("shape_one")[0]
	var texture_two: Texture2D = names_and_textures.get("shape_two")[1]
	var name_two: String = names_and_textures.get("shape_two")[0]
	icon_one.texture = texture_one
	label_one.text = name_one
	icon_two.texture = texture_two
	label_two.text = name_two


func _update_hint_display_settings(show_statue_shapes: bool, show_shape_logic: bool, show_key_matches: bool) -> void:
	_set_3d_statue_hint_display(show_statue_shapes)
	_set_composing_shape_hint_display(show_shape_logic)
	_set_key_match_hint_display(show_key_matches)


func _set_3d_statue_hint_display(show: bool) -> void:
	statues_3d_title.visible = show
	statue_one.visible = show
	statue_two.visible = show
	statue_three.visible = show


func _set_composing_shape_hint_display(show: bool) -> void:
	shape_comp_title.visible = show
	composing_shapes_left.visible = show
	composing_shapes_middle.visible = show
	composing_shapes_right.visible = show


func _set_key_match_hint_display(show: bool) -> void:
	matches_title.visible = show
	left_key_match.visible = show
	middle_key_match.visible = show
	right_key_match.visible = show


func _on_key_shapes_set(left: EffectLibrary.SHAPE_2D_TYPES, middle: EffectLibrary.SHAPE_2D_TYPES, right: EffectLibrary.SHAPE_2D_TYPES) -> void:
	set_2d_shapes(left, middle, right)


func _on_shape_matches_updated(left_match: bool, middle_match: bool, right_match: bool) -> void:
	set_left_key_matching(left_match)
	set_middle_key_matching(middle_match)
	set_right_key_matching(right_match)


func _on_statue_shapes_updated(left: EffectLibrary.SHAPE_3D_TYPES, middle: EffectLibrary.SHAPE_3D_TYPES, right: EffectLibrary.SHAPE_3D_TYPES) -> void:
	set_3d_shapes(left, middle, right)


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


func _get_composing_shapes_for_3d_shape(shape_3d: EffectLibrary.SHAPE_3D_TYPES) -> Dictionary:
	match shape_3d:
		EffectLibrary.SHAPE_3D_TYPES.SPHERE:
			return {
				"shape_one": ["Circle", circle_texture],
				"shape_two": ["Circle", circle_texture],
			}
		EffectLibrary.SHAPE_3D_TYPES.CUBE:
			return {
				"shape_one": ["Square", square_texture],
				"shape_two": ["Square", square_texture],
			}
		EffectLibrary.SHAPE_3D_TYPES.PYRAMID:
			return {
				"shape_one": ["Triangle", triangle_texture],
				"shape_two": ["Triangle", triangle_texture],
			}
		EffectLibrary.SHAPE_3D_TYPES.CYLINDER:
			return {
				"shape_one": ["Circle", circle_texture],
				"shape_two": ["Square", square_texture],
			}
		EffectLibrary.SHAPE_3D_TYPES.CONE:
			return {
				"shape_one": ["Triangle", triangle_texture],
				"shape_two": ["Circle", circle_texture],
			}
		EffectLibrary.SHAPE_3D_TYPES.PRISM:
			return {
				"shape_one": ["Square", square_texture],
				"shape_two": ["Triangle", triangle_texture],
			}
	return {}
