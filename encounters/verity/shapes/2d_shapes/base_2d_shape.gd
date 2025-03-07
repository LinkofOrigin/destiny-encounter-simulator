class_name Base2DShape
extends Node3D

signal picked_up
signal despawned

@export_category("Shape Settings")
@export_enum("Triangle", "Circle", "Square") var shape_id := 0
@export var effect: Shape2DEffectData
@export var despawn_time: int = 20

@onready var interactable_component: InteractableComponent = %InteractableComponent
@onready var timer: Timer = %Timer
@onready var sprite: Sprite3D = %Sprite


func _ready() -> void:
	# TODO: animate?
	timer.timeout.connect(_on_timer_timeout)
	start_despawn_timer(despawn_time)
	
	interactable_component.interaction_complete.connect(_on_interactable_component_interaction_complete)


func start_despawn_timer(new_time: int = 0) -> void:
	despawn_time = new_time
	if despawn_time > 0:
		timer.wait_time = despawn_time
		timer.start()


func despawn() -> void:
	interactable_component.process_mode = Node.PROCESS_MODE_DISABLED
	var tween := get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(0,0,0,0), 2)
	tween.tween_callback(_handle_despawned)


func disable_interaction() -> void:
	interactable_component.process_mode = Node.PROCESS_MODE_DISABLED


func _handle_despawned() -> void:
	despawned.emit()
	queue_free()


func _on_interactable_component_interaction_complete() -> void:
	picked_up.emit()
	despawn()


func _on_timer_timeout() -> void:
	despawn()
