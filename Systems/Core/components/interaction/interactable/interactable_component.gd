class_name InteractableComponent
extends Node3D

signal interacted_with

@export_category("Interaction Settings")
@export var requirement: InteractionRequirement
@export var input_icon: Texture2D = preload("res://addons/controller_icons/assets/xboxseries/x.png") ## Input icon to display to the player indicating what button to press
@export var prompt_text: String = "INTERACT" ## Text to display to the player that indicates the action they are taking
@export_range(0.2, 5.0, 0.1) var interact_time: float = 1.0 ## Time in seconds to complete interaction

var _interaction_zone: InteractionZone
var _interaction_target: InteractionTarget


func _ready() -> void:
	for area: Area3D in get_children():
		if area is InteractionZone:
			_interaction_zone = area
		elif area is InteractionTarget:
			_interaction_target = area
	
	# TODO: Change this to be @tool script logic or something?
	# Enforces that any interaction component has a zone and target set
	assert(_interaction_zone != null, "Interaction Zone is not set")
	assert(_interaction_target != null, "Interaction Target is not set")


func check_interact_condition(effect_manager: EffectManager) -> bool:
	if requirement == null:
		return true
	return requirement.meets_requirements(effect_manager)


func complete_interaction(effect_manager: EffectManager) -> void:
	if requirement != null:
		requirement.resolve_interaction(effect_manager)
	interacted_with.emit()
