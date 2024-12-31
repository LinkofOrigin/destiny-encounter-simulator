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


func remove_effects_by_data(data: EffectData) -> Array[EffectData]:
	var removed_data: Array[EffectData] = []
	for effect: Effect in effect_mapping[data]:
		var rem_data := _remove_effect(effect)
		removed_data.push_back(rem_data)
	
	return removed_data


func has_effect(data: EffectData) -> bool:
	return effect_mapping.has(data) and not (effect_mapping[data] as Array).is_empty()


func has_effect_of_type(type: EffectData.TYPES) -> bool:
	var data_list: Array = effect_mapping.keys()
	for data: EffectData in data_list:
		if data.type == type and not (effect_mapping[data] as Array).is_empty():
			return true
	return false


func clear_effects_of_type(type: EffectData.TYPES) -> Array[EffectData]:
	var cleared_effects: Array[EffectData] = []
	var data_list: Array = effect_mapping.keys()
	for data: EffectData in data_list:
		if data.type == type:
			var removed_effects := remove_effects_by_data(data)
			cleared_effects.append_array(removed_effects)
	
	return cleared_effects


func _remove_effect(effect: Effect) -> EffectData:
	var data := effect.data
	effect.queue_free()
	(effect_mapping[data] as Array).erase.call_deferred(effect)
	current_effects.erase.call_deferred(effect)
	return data
