class_name Statue
extends Node3D

signal received_effects(effects: Array[EffectData])

@onready var body_marker: Marker3D = %BodyMarker
@onready var interactable_component: InteractableComponent = %InteractableComponent


func _ready() -> void:
	pass


func _on_interactable_component_interacted_with(effects: Array[EffectData]) -> void:
	print("Statue was interated with!")
	# TODO: Signal to a EncounterManager or something?
	received_effects.emit(effects)
