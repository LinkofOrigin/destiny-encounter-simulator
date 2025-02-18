class_name PlayerHUD
extends CanvasLayer

@onready var timer_display: TimerDisplay = %TimerDisplay
@onready var location_display: LocationDisplay = %LocationDisplay
@onready var effect_display: EffectDisplay = %EffectDisplay
@onready var interact_prompt: InteractPrompt = %InteractPrompt
@onready var start_encounter_display: StartEncounterDisplay = %StartEncounterDisplay


func _ready() -> void:
	interact_prompt.hide()


func display_interact_prompt_for_interactable(interactable: InteractableComponent) -> void:
	interact_prompt.set_data(interactable.input_icon, interactable.prompt_text)
	interact_prompt.show()


func hide_interact_prompt() -> void:
	interact_prompt.hide()


func set_interact_progress(progress: float) -> void:
	interact_prompt.set_progress(progress)


func add_effect(effect: Effect) -> void:
	effect_display.add_effect(effect)


func set_encounter_start_progress(percent: float) -> void:
	start_encounter_display.set_progress_percent(percent)


func show_encounter_start_display() -> void:
	start_encounter_display.show()


func hide_encounter_start_display() -> void:
	start_encounter_display.hide()


func inject_location_state(display: LocationState) -> void:
	location_display.inject_location_state(display)


func update_location_state(new_state: Variant) -> void:
	if is_instance_valid(location_display.current_state):
		location_display.current_state.update_state(new_state)


func show_location_state() -> void:
	location_display.show()


func hide_location_state() -> void:
	location_display.hide()
