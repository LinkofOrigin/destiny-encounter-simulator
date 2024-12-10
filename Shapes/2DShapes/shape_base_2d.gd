class_name ShapeBase2D
extends Node3D

@export_category("Shape Settings")
@export_enum("Triangle", "Circle", "Square") var shape_id := 0
@export var effect: Effect

@onready var interactable_component: InteractableComponent = $InteractableComponent


func _ready() -> void:
	pass


func _on_interactable_component_interacted_with() -> void:
	print("2D Shape interacted with")
	GlobalSignals.emit_effect_acquired(effect)
