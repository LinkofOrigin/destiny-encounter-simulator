class_name Statue3D
extends Statue

#@onready var body_marker: Marker3D = %BodyMarker
@onready var interactable_component: InteractableComponent = %InteractableComponent
@onready var held_shape_marker: Marker3D = %HeldShapeMarker
@onready var shape_spawner: ShapeSpawner = %ShapeSpawner
const STATUE_3D_REQUIREMENT = preload("res://systems/core/components/interaction/requirements/statue_3d_requirements/statue_3d_requirement.tres")
const SHAPE_RESOLVER = preload("res://encounters/verity/shapes/3d_shapes/shape_resolver.tres")

var current_held_shape: Base3DShape


func _ready() -> void:
	if interaction_behavior != null:
		interactable_component.requirement = interaction_behavior
	interactable_component.interacted_with.connect(_on_interactable_component_interacted_with)


func create_and_hold_3d_shape(shape: EffectLibrary.SHAPE_3D_TYPES) -> void:
	var new_3d_shape := shape_spawner.create_new_3d_shape(shape)
	interaction_behavior = STATUE_3D_REQUIREMENT.duplicate()
	(interaction_behavior as Statue3DRequirement).current_shape = new_3d_shape.effect
	_hold_new_shape(new_3d_shape)


func alter_3d_shape(existing_shape: Shape2DEffectData, new_shape: Shape2DEffectData) -> void:
	var curr_shape := (interaction_behavior as Statue3DRequirement).current_shape
	var new_3d_shape := SHAPE_RESOLVER.alter_shape(curr_shape, existing_shape, new_shape)
	create_and_hold_3d_shape(new_3d_shape.shape)
	

func _hold_new_shape(shape_scene: Base3DShape) -> void:
	if is_instance_valid(current_held_shape):
		current_held_shape.queue_free()
	
	current_held_shape = shape_scene
	held_shape_marker.add_child(shape_scene)
	


func _set_interaction_behavior(new_behavior: InteractionRequirement) -> void:
	interaction_behavior = new_behavior
	if is_instance_valid(interactable_component):
		interactable_component.requirement = interaction_behavior
