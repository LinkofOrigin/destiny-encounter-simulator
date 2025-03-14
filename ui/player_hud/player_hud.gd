class_name PlayerHUD
extends CanvasLayer

const TIME_TO_FADE_OUT := 4
const TIME_TO_FADE_IN := 2

@onready var timer_display: TimerDisplay = %TimerDisplay
@onready var location_display: LocationDisplay = %LocationDisplay
@onready var effect_display: EffectDisplay = %EffectDisplay
@onready var interact_prompt: InteractPrompt = %InteractPrompt
@onready var start_encounter_display: StartEncounterDisplay = %StartEncounterDisplay
@onready var fade_screen: ColorRect = %FadeScreen

var _show_hints_at_start: bool = true


func _ready() -> void:
	interact_prompt.hide()


## Interact Prompt
func display_interact_prompt_for_interactable(interactable: InteractableComponent) -> void:
	interact_prompt.set_data(interactable.input_icon, interactable.prompt_text)
	interact_prompt.show()


func hide_interact_prompt() -> void:
	interact_prompt.hide()


func set_interact_progress(progress: float) -> void:
	interact_prompt.set_progress(progress)


## Effect Display
func add_effect(effect: Effect) -> void:
	effect_display.add_effect(effect)


func remove_effect(effect: Effect) -> void:
	effect_display.remove_effect(effect)


## Encounter Start Display
func set_encounter_start_progress(percent: float) -> void:
	start_encounter_display.set_progress_percent(percent)


func show_encounter_start_display() -> void:
	start_encounter_display.show()
	set_encounter_start_progress(0)


func hide_encounter_start_display() -> void:
	start_encounter_display.hide()


## Location State (Hints)
func inject_location_state(display: LocationState) -> void:
	location_display.inject_location_state(display)


func update_location_state(new_state: Variant) -> void:
	if is_instance_valid(location_display.current_state):
		location_display.current_state.update_state(new_state)


func set_display_hint_on_input(display_on_input: bool) -> void:
	location_display.input_enabled_display = display_on_input


func display_hint_on_start(show_on_start: bool) -> void:
	location_display.show_on_encounter_start = show_on_start


func show_location_state(force := false) -> void:
	location_display.show_state(force)


func hide_location_state() -> void:
	location_display.hide_state()


## Screen Fade
func fade_screen_to_black(callback: Callable = Callable()) -> void:
	if fade_screen.color.a == 1.0:
		# Short circuit if the screen is already black, wait 1 second
		await get_tree().create_timer(1).timeout
		callback.call()
		return
	
	var tween := get_tree().create_tween()
	var faded_color := Color(fade_screen.color, 1.0)
	tween.tween_property(fade_screen, "color", faded_color, TIME_TO_FADE_OUT)
	if not callback.is_null():
		tween.tween_callback(callback)


func fade_screen_to_normal(callback: Callable = Callable()) -> void:
	if fade_screen.color.a == 0.0:
		# Short circuit if the screen is already normal, wait 1 second
		await get_tree().create_timer(1).timeout
		callback.call()
		return
	
	var tween := get_tree().create_tween()
	var faded_color := Color(fade_screen.color, 0.0)
	tween.tween_property(fade_screen, "color", faded_color, TIME_TO_FADE_IN)
	if not callback.is_null():
		tween.tween_callback(callback)
