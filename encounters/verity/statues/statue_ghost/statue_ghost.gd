class_name StatueGhost
extends Statue

@onready var interactable_component: InteractableComponent = %InteractableComponent


func _ready() -> void:
	if interaction_behavior != null:
		interactable_component.requirement = interaction_behavior
	interactable_component.interacted_with.connect(_on_interactable_component_interacted_with)
