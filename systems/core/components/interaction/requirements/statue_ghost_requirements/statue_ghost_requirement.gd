class_name StatueGhostRequirement
extends InteractionRequirement

const effect_type := EffectLibrary.TYPES.GHOST


func meets_requirements(effect_manager: EffectManager) -> bool:
	return effect_manager.has_effect_of_type(effect_type)


func resolve_interaction(effect_manager: EffectManager) -> void:
	var cleared_effects := effect_manager.clear_effects_of_type(effect_type)
	print("Ghost Statue cleared effects!")
	resolved_interaction.emit(cleared_effects)
