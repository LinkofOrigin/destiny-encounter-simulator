class_name LocationDisplay
extends Control

@onready var location_text: Label = %LocationText
@onready var hint_display_indicator_container: HBoxContainer = %HintDisplayIndicatorContainer
@onready var display_hints_indicator: Label = %DisplayHintsIndicator
@onready var full_state_holder: MarginContainer = %FullStateHolder
@onready var state_container: PanelContainer = %StateContainer

var current_state: LocationState

var show_on_encounter_start := true
var input_enabled_display := false:
	set = _set_input_enabled_display

var _encounter_running := false


func _ready() -> void:
	GlobalSignals.encounter_starting.connect(_on_encounter_starting)
	GlobalSignals.encounter_resetting.connect(_on_encounter_resetting)
	hide_state()
	hint_display_indicator_container.hide()


func show_state() -> void:
	# TODO: Give this a fade or cooldown or something?
	if _encounter_running:
		full_state_holder.show()
		display_hints_indicator.text = "[Release] Hide Hints"


func hide_state() -> void:
	# TODO: Give this a fade or cooldown or something?
	full_state_holder.hide()
	display_hints_indicator.text = "[Hold] Show Hints"


func inject_location_state(state: LocationState) -> void:
	if is_instance_valid(current_state):
		current_state.queue_free()
	
	current_state = state
	state_container.add_child(state)


func _set_input_enabled_display(display_on_input: bool) -> void:
	input_enabled_display = display_on_input
	if _encounter_running and input_enabled_display:
		hint_display_indicator_container.show()
	else:
		hint_display_indicator_container.hide()


func _on_encounter_starting() -> void:
	_encounter_running = true
	if input_enabled_display:
		hint_display_indicator_container.show()
	if show_on_encounter_start:
		show_state()


func _on_encounter_resetting() -> void:
	hide_state()
	hint_display_indicator_container.hide()
	_encounter_running = false
