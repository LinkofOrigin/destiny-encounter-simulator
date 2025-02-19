class_name LocationDisplay
extends Control

@onready var location_text: Label = %LocationText
@onready var state_container: PanelContainer = %StateContainer

var current_state: LocationState

var _only_show_on_input: bool = false


func _ready() -> void:
	hide_state()


func set_show_on_input(show: bool) -> void:
	_only_show_on_input = show


func show_state() -> void:
	state_container.show()


func hide_state() -> void:
	state_container.hide()


func inject_location_state(state: LocationState) -> void:
	if is_instance_valid(current_state):
		current_state.queue_free()
	
	current_state = state
	state_container.add_child(state)
	if not _only_show_on_input:
		show_state()


func _unhandled_input(event: InputEvent) -> void:
	if _only_show_on_input:
		# TODO: Give this a fade or cooldown or something?
		if event.is_action_pressed("SecondaryFire"):
			show_state()
		elif event.is_action_released("SecondaryFire"):
			hide_state()
