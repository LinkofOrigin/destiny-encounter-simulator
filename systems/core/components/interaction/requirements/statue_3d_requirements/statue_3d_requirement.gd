class_name Statue3DRequirement
extends InteractionRequirement

var current_shape: Shape3DEffectData

var primed: bool = false
var primed_with: Shape2DEffectData


func meets_requirements(effect_manager: EffectManager) -> bool:
	if primed:
		return false
	
	var first_type := current_shape.get_first_type()
	var second_type := current_shape.get_second_type()
	return effect_manager.has_effect(first_type) or effect_manager.has_effect(second_type)


func resolve_interaction(effect_manager: EffectManager) -> void:
	if primed or primed_with != null:
		printerr("Tried to interact with a 3D statue when it was already primed?!")
		return
	
	var first_type := current_shape.get_first_type()
	var second_type := current_shape.get_second_type()
	if effect_manager.has_effect(first_type):
		effect_manager.remove_effects_by_data(first_type)
		primed_with = first_type
	elif effect_manager.has_effect(second_type):
		effect_manager.remove_effects_by_data(second_type)
		primed_with = second_type
	print("3D Statue cleared effects! Now primed with: ", primed_with.name)
	
	primed = true
	var primed_effects: Array[EffectData] = []
	primed_effects.push_back(primed_with)
	resolved_interaction.emit(primed_effects)
