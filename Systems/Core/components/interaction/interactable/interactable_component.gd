class_name InteractableComponent
extends Node3D

signal interaction_complete
signal interacted_with(obj: Variant)

@export_category("Interaction Settings")
@export var requirement: InteractionRequirement:
	set = _set_requirement
@export var input_icon: Texture2D = preload("res://addons/controller_icons/assets/xboxseries/x.png") ## Input icon to display to the player indicating what button to press
@export var prompt_text: String = "INTERACT" ## Text to display to the player that indicates the action they are taking
@export_range(0.2, 5.0, 0.1) var interact_time: float = 1.0 ## Time in seconds to complete interaction

var _interaction_zone: InteractionZone
var _interaction_target: InteractionTarget


func _ready() -> void:
	if requirement != null:
		requirement.resolved_interaction.connect(_on_requirement_resolved)
	
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
	interaction_complete.emit()


func _on_requirement_resolved(obj: Variant) -> void:
	interacted_with.emit(obj)


func _set_requirement(new_requirement: InteractionRequirement) -> void:
	if is_inside_tree():
		if requirement != null and requirement.resolved_interaction.is_connected(_on_requirement_resolved):
			requirement.resolved_interaction.disconnect(_on_requirement_resolved)
	
	
	requirement = new_requirement
	
	if is_inside_tree() and requirement != null:
		requirement.resolved_interaction.connect(_on_requirement_resolved)
