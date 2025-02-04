class_name LocationDisplay
extends Control

@onready var location_text: Label = %LocationText
@onready var state_container: PanelContainer = %StateContainer

var current_state: LocationState


func _ready() -> void:
	hide_state()


func show_state() -> void:
	state_container.show()


func hide_state() -> void:
	state_container.hide()


func inject_location_state(state: LocationState) -> void:
	if is_instance_valid(current_state):
		current_state.queue_free()
	
	current_state = state
	state_container.add_child(state)
	show_state()
