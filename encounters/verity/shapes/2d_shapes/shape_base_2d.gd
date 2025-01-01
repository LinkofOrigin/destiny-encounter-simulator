class_name ShapeBase2D
extends Node3D

signal picked_up
signal despawned

@export_category("Shape Settings")
@export_enum("Triangle", "Circle", "Square") var shape_id := 0
@export var effect: EffectData
@export var despawn_time: int = 20

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var sprite: Sprite3D = %Sprite
@onready var timer: Timer = %Timer


func _ready() -> void:
	# TODO: animate?
	timer.wait_time = despawn_time
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func despawn() -> void:
	interactable_component.process_mode = Node.PROCESS_MODE_DISABLED
	var tween := get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(0,0,0,0), 2)
	tween.tween_callback(_handle_despawned)


func _handle_despawned() -> void:
	despawned.emit()
	queue_free()


func _on_interactable_component_interaction_complete() -> void:
	print("2D Shape interacted with")
	picked_up.emit()
	despawn()


func _on_timer_timeout() -> void:
	despawn()
