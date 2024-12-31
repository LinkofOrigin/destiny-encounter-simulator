class_name InteractionRequirement
extends Resource

signal resolved_interaction(obj: Variant)


func meets_requirements(effect_manager: EffectManager) -> bool:
	return false


func resolve_interaction(effect_manager: EffectManager) -> void:
	pass
