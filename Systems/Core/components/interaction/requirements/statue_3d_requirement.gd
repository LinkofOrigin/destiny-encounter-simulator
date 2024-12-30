class_name Statue3DRequirement
extends InteractionRequirement

const effect_type := EffectData.TYPES.SHAPE_2D


func meets_requirements(effect_manager: EffectManager) -> bool:
	# TODO: Handle if the statue has been primed?? Make a manager?
	return effect_manager.has_effect_of_type(effect_type)


func resolve_interaction(effect_manager: EffectManager) -> void:
	effect_manager.clear_effects_of_type(effect_type)
	print("3d Statue cleared effects!")
