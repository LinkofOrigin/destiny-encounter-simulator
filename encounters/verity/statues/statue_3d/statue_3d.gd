class_name Statue3D
extends Statue

#@onready var body_marker: Marker3D = %BodyMarker
@onready var shape_spawner: ShapeSpawner = %ShapeSpawner
@onready var interactable_component: InteractableComponent = %InteractableComponent
@onready var held_shape_marker: Marker3D = %HeldShapeMarker
@onready var left_composing_shape_marker: Marker3D = %LeftComposingShapeMarker
@onready var right_composing_shape_marker: Marker3D = %RightComposingShapeMarker

const STATUE_3D_REQUIREMENT: Statue3DRequirement = preload("res://systems/core/components/interaction/requirements/statue_3d_requirements/statue_3d_requirement.tres")
const SHAPE_RESOLVER: ShapeResolver = preload("res://encounters/verity/shapes/3d_shapes/shape_resolver.tres")
const CIRCLE_SPRITE = preload("res://encounters/verity/shapes/2d_shapes/circle_sprite.tscn")
const SQUARE_SPRITE = preload("res://encounters/verity/shapes/2d_shapes/square_sprite.tscn")
const TRIANGLE_SPRITE = preload("res://encounters/verity/shapes/2d_shapes/triangle_sprite.tscn")

var current_held_shape: Base3DShape
var current_left_composing_shape: Sprite3D
var current_right_composing_shape: Sprite3D


func _ready() -> void:
	GlobalSignals.encounter_resetting.connect(_on_encounter_resetting)
	if interaction_behavior != null:
		interactable_component.requirement = interaction_behavior
	interactable_component.interacted_with.connect(_on_interactable_component_interacted_with)


func create_and_hold_3d_shape(shape: EffectLibrary.SHAPE_3D_TYPES) -> void:
	var new_3d_shape := shape_spawner.create_new_3d_shape(shape)
	interaction_behavior = STATUE_3D_REQUIREMENT.duplicate()
	get_interaction_behavior().current_shape = new_3d_shape.effect
	_hold_new_shape(new_3d_shape)


func alter_3d_shape(existing_shape: Shape2DEffectData, new_shape: Shape2DEffectData) -> void:
	var curr_shape := get_interaction_behavior().current_shape
	var new_3d_shape := SHAPE_RESOLVER.alter_shape(curr_shape, existing_shape, new_shape)
	create_and_hold_3d_shape(new_3d_shape.shape)


func get_primed_shape() -> Shape2DEffectData:
	return get_interaction_behavior().primed_with


func current_shape_has(shape_2d: EffectLibrary.SHAPE_2D_TYPES) -> bool:
	return get_interaction_behavior().current_shape.contains(shape_2d)


func get_interaction_behavior() -> Statue3DRequirement:
	return interaction_behavior as Statue3DRequirement


func set_display_for_composing_shape_hints(should_show_hints: bool) -> void:
	left_composing_shape_marker.visible = should_show_hints
	right_composing_shape_marker.visible = should_show_hints


func _hold_new_shape(shape_scene: Base3DShape) -> void:
	if is_instance_valid(current_held_shape):
		current_held_shape.queue_free()
	
	current_held_shape = shape_scene
	held_shape_marker.add_child(shape_scene)
	_set_composing_shapes(shape_scene.effect)


func _set_interaction_behavior(new_behavior: InteractionRequirement) -> void:
	interaction_behavior = new_behavior
	if is_instance_valid(interactable_component):
		interactable_component.requirement = interaction_behavior


func _set_composing_shapes(shape_3d: Shape3DEffectData) -> void:
	if is_instance_valid(current_left_composing_shape):
		current_left_composing_shape.queue_free()
	if is_instance_valid(current_right_composing_shape):
		current_right_composing_shape.queue_free()
	
	current_left_composing_shape = _get_sprite_scene_for_shape(shape_3d.get_first_type().shape)
	current_left_composing_shape.scale = Vector3(0.08, 0.08, 0.08)
	current_right_composing_shape = _get_sprite_scene_for_shape(shape_3d.get_second_type().shape)
	current_right_composing_shape.scale = Vector3(0.08, 0.08, 0.08)
	left_composing_shape_marker.add_child(current_left_composing_shape)
	right_composing_shape_marker.add_child(current_right_composing_shape)


func _get_sprite_scene_for_shape(shape_2d: EffectLibrary.SHAPE_2D_TYPES) -> Sprite3D:
	match shape_2d:
		EffectLibrary.SHAPE_2D_TYPES.CIRCLE:
			return CIRCLE_SPRITE.instantiate()
		EffectLibrary.SHAPE_2D_TYPES.SQUARE:
			return SQUARE_SPRITE.instantiate()
		EffectLibrary.SHAPE_2D_TYPES.TRIANGLE:
			return TRIANGLE_SPRITE.instantiate()
	printerr("invalid 2d shape passed for a sprite scene!")
	return null


func _on_encounter_resetting() -> void:
	if is_instance_valid(current_held_shape):
		current_held_shape.queue_free()
	if is_instance_valid(current_left_composing_shape):
		current_left_composing_shape.queue_free()
	if is_instance_valid(current_right_composing_shape):
		current_right_composing_shape.queue_free()
	interaction_behavior = null
	interactable_component.requirement = null
