class_name ShapeBase2D
extends Node3D

signal picked_up

@export_category("Shape Settings")
@export_enum("Triangle", "Circle", "Square") var shape_id := 0
@export var effect: EffectData

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var sprite: Sprite3D = %Sprite


func _ready() -> void:
	# TODO: animate?
	pass


func _on_interactable_component_interaction_complete() -> void:
	print("2D Shape interacted with")
	interactable_component.process_mode = Node.PROCESS_MODE_DISABLED
	picked_up.emit()
	var tween := get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(0,0,0,0), 2)
	tween.tween_callback(self.queue_free)
