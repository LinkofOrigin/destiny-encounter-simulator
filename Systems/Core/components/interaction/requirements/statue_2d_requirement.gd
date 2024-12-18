class_name Statue2DRequirement
extends InteractionRequirement

const effect_type := EffectData.TYPES.SHAPE_2D


func meets_requirements(effect_manager: EffectManager) -> bool:
	return effect_manager.has_effect_of_type(effect_type)


func resolve_interaction(effect_manager: EffectManager) -> void:
	effect_manager.clear_effects_of_type(effect_type)
