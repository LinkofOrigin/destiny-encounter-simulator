class_name Statue
extends Node3D

signal received_effects(effects: Array[EffectData])

@export var interaction_behavior: InteractionRequirement:
	get = get_interaction_behavior,
	set = _set_interaction_behavior

@onready var body_marker: Marker3D = %BodyMarker
#@onready var interactable_component: InteractableComponent = %InteractableComponent
#@onready var held_shape_marker: Marker3D = %HeldShapeMarker
#@onready var shape_spawner: ShapeSpawner = %ShapeSpawner

#const STATUE_2D_REQUIREMENT = preload("res://systems/core/components/interaction/requirements/statue_2d_requirements/statue_2d_requirement.tres")
#const STATUE_3D_REQUIREMENT = preload("res://systems/core/components/interaction/requirements/statue_3d_requirements/statue_3d_requirement.tres")

#var current_held_shape: Node3D

#func _ready() -> void:
	#if interaction_behavior != null:
		#interactable_component.requirement = interaction_behavior

#
#func create_and_hold_2d_shape(shape: EffectLibrary.SHAPE_2D_TYPES) -> void:
	#var new_2d_shape := shape_spawner.create_new_2d_shape(shape)
	#new_2d_shape.despawn_time = -1
	#interaction_behavior = STATUE_2D_REQUIREMENT.duplicate()
	#_hold_new_shape(new_2d_shape)
#
#
#func create_and_hold_3d_shape(shape: EffectLibrary.SHAPE_3D_TYPES) -> void:
	#var new_3d_shape := shape_spawner.create_new_3d_shape(shape)
	#interaction_behavior = STATUE_3D_REQUIREMENT.duplicate()
	#(interaction_behavior as Statue3DRequirement).current_shape = new_3d_shape.effect
	#_hold_new_shape(new_3d_shape)
#
#
#func alter_3d_shape(existing_shape: Shape2DEffectData, new_shape: Shape2DEffectData) -> void:
	#pass
	#
#
#func _hold_new_shape(shape_scene: Node3D) -> void:
	#if is_instance_valid(current_held_shape):
		#current_held_shape.queue_free()
	#
	#current_held_shape = shape_scene
	#held_shape_marker.add_child(shape_scene)
	

func _on_interactable_component_interacted_with(effects: Array[EffectData]) -> void:
	print("Statue was interacted with!")
	received_effects.emit(effects)


func get_interaction_behavior() -> InteractionRequirement:
	return interaction_behavior


func _set_interaction_behavior(new_behavior: InteractionRequirement) -> void:
	interaction_behavior = new_behavior
