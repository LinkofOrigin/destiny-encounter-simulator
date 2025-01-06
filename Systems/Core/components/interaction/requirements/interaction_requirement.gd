class_name InteractionRequirement
extends Resource

@warning_ignore("unused_signal")
signal resolved_interaction(obj: Variant)


func meets_requirements(_effect_manager: EffectManager) -> bool:
	return false


func resolve_interaction(_effect_manager: EffectManager) -> void:
	pass
