class_name EffectManager
extends Node

signal effect_added(effect: Effect)
signal effect_removed(effect: Effect)

const effect_node_packed := preload("res://systems/core/components/effect_management/effect_nodes/effect.tscn")

var current_effects: Array[Effect]
var effect_mapping: Dictionary


func add_effect(data: EffectData) -> void:
	var new_effect: Effect = effect_node_packed.instantiate()
	new_effect.data = data
	if not effect_mapping.has(data):
		effect_mapping[data] = []
	
	effect_mapping[data].push_back(new_effect)
	current_effects.push_back(new_effect)
	
	add_child(new_effect)
	effect_added.emit(new_effect)
	GlobalSignals.emit_effect_acquired(new_effect)


func remove_effects_by_data(data: EffectData) -> void:
	for effect: Effect in effect_mapping[data]:
		effect.queue_free()
		(effect_mapping[data] as Array).erase.call_deferred(effect)


func has_effect(effect: EffectData) -> bool:
	var data_list: Array[EffectData] = effect_mapping.keys()
	for data: EffectData in data_list:
		if data == effect:
			return true
	return false


func has_effect_of_type(type: EffectData.TYPES) -> bool:
	var data_list: Array = effect_mapping.keys()
	for data: EffectData in data_list:
		if data.type == type:
			return true
	return false


func clear_effects_of_type(type: EffectData.TYPES) -> void:
	var data_list: Array = effect_mapping.keys()
	for data: EffectData in data_list:
		if data.type == type:
			for effect: Effect in effect_mapping[data]:
				effect.queue_free()
				(effect_mapping[data] as Array).erase.call_deferred(effect)
