class_name Statue
extends Node3D

signal received_effects(effects: Array[EffectData])

@onready var body_marker: Marker3D = %BodyMarker
@onready var interactable_component: InteractableComponent = %InteractableComponent
@onready var held_shape_marker: Marker3D = %HeldShapeMarker
@onready var shape_spawner: ShapeSpawner = %ShapeSpawner

var current_held_shape: Node3D

func _ready() -> void:
	pass


func create_and_hold_2d_shape(shape: ShapeSpawner.SHAPES_2D) -> void:
	var new_2d_shape := shape_spawner.create_new_2d_shape(shape)
	new_2d_shape.despawn_time = -1
	_hold_new_shape(new_2d_shape)


func create_and_hold_3d_shape(shape: ShapeSpawner.SHAPES_3D) -> void:
	var new_3d_shape := shape_spawner.create_new_3d_shape(shape)
	_hold_new_shape(new_3d_shape)


func _hold_new_shape(shape_scene: Node3D) -> void:
	if is_instance_valid(current_held_shape):
		current_held_shape.queue_free()
	
	current_held_shape = shape_scene
	held_shape_marker.add_child(shape_scene)
	

func _on_interactable_component_interacted_with(effects: Array[EffectData]) -> void:
	print("Statue was interated with!")
	# TODO: Signal to a EncounterManager or something?
	received_effects.emit(effects)
