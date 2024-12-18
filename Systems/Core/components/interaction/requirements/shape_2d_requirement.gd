class_name Shape2DRequirement
extends InteractionRequirement

@export var effect_to_add: EffectData

func meets_requirements(_effect_manager: EffectManager) -> bool:
	return true


func resolve_interaction(effect_manager: EffectManager) -> void:
	effect_manager.add_effect(effect_to_add)
