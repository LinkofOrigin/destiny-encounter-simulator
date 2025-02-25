class_name MechanicOptions
extends Control

signal navigated_back
signal settings_updated(settings: Dictionary)

@export var mechanic_state_container: Control


func _ready() -> void:
	var children := find_children("*", "OptionContainer", false)
	for option_container: OptionContainer in children:
		option_container.cancel_pressed.connect(_emit_navigated_back)
	_ready_behavior()


## To be overridden
func _ready_behavior() -> void:
	pass


## To be overridden
func get_menu_title() -> String:
	return ""


## To be overridden
func get_mechanics_state_description() -> Dictionary:
	return {}


func focus_first_item() -> void:
	get_child(0).grab_focus.call_deferred()


func _emit_navigated_back() -> void:
	navigated_back.emit()


func _emit_settings_updated(settings: Dictionary) -> void:
	settings_updated.emit(settings)
