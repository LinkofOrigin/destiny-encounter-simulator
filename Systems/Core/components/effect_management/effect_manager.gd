class_name EffectManager
extends Node

signal effect_added(effect: Effect)
signal effect_removed(effect: Effect)

var current_effects: Array[Effect]

const effect_node_packed := preload("res://Systems/Core/components/effect_management/effect_nodes/effect.tscn")


func add_effect(data: EffectData) -> void:
	var new_effect: Effect = effect_node_packed.instantiate()
	current_effects.push_back(new_effect)
	add_child(new_effect)
	effect_added.emit(new_effect)


func remove_effect(data: EffectData) -> void:
	pass


func has_effect(effect: Effect) -> bool:
	return true


func has_effect_of_type() -> bool:
	return true
