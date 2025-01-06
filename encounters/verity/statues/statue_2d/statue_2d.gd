class_name Statue2D
extends Statue

@onready var interactable_component: InteractableComponent = %InteractableComponent
@onready var held_shape_marker: Marker3D = %HeldShapeMarker
@onready var shape_spawner: ShapeSpawner = %ShapeSpawner

const STATUE_2D_REQUIREMENT = preload("res://systems/core/components/interaction/requirements/statue_2d_requirements/statue_2d_requirement.tres")
var current_held_shape: Sprite3D


func _ready() -> void:
	if interaction_behavior != null:
		interactable_component.requirement = interaction_behavior
	interactable_component.interacted_with.connect(_on_interactable_component_interacted_with)


func create_and_hold_2d_shape(shape: EffectLibrary.SHAPE_2D_TYPES) -> void:
	var new_2d_shape := shape_spawner.create_new_2d_sprite(shape)
	interaction_behavior = STATUE_2D_REQUIREMENT.duplicate()
	_hold_new_shape(new_2d_shape)


func _hold_new_shape(shape_scene: Sprite3D) -> void:
	if is_instance_valid(current_held_shape):
		current_held_shape.queue_free()
	
	current_held_shape = shape_scene
	held_shape_marker.add_child(shape_scene)


func _set_interaction_behavior(new_behavior: InteractionRequirement) -> void:
	interaction_behavior = new_behavior
	if is_instance_valid(interactable_component):
		interactable_component.requirement = interaction_behavior
