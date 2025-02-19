class_name LocationDisplay
extends Control

@onready var location_text: Label = %LocationText
@onready var full_state_holder: MarginContainer = %FullStateHolder
@onready var state_container: PanelContainer = %StateContainer

var current_state: LocationState


func _ready() -> void:
	hide_state()


func show_state() -> void:
	# TODO: Give this a fade or cooldown or something?
	full_state_holder.show()


func hide_state() -> void:
	# TODO: Give this a fade or cooldown or something?
	full_state_holder.hide()


func inject_location_state(state: LocationState) -> void:
	if is_instance_valid(current_state):
		current_state.queue_free()
	
	current_state = state
	state_container.add_child(state)
