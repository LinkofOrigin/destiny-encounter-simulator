class_name Statue
extends Node3D

@onready var body_marker: Marker3D = %BodyMarker
@onready var interactable_component: InteractableComponent = %InteractableComponent
@onready var interaction_target: InteractionTarget = $InteractableComponent/InteractionTarget


func _ready() -> void:
	pass


func _on_interactable_component_interacted_with() -> void:
	print("Statue was interated with!")
	# TODO: Signal to a EncounterManager or something?
	pass # Replace with function body.