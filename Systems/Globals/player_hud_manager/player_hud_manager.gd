# class_name PlayerHudManager
extends Node

@onready var player_hud: PlayerHUD = $PlayerHud


func _ready() -> void:
	GlobalSignals.player_can_interact.connect(_on_player_can_interact)
	GlobalSignals.player_can_not_interact.connect(_on_player_can_not_interact)
	GlobalSignals.player_interact_progress_made.connect(_on_player_interact_progress_made)
	GlobalSignals.player_interaction_complete.connect(_on_player_interaction_complete)
	GlobalSignals.player_hint_display_on_input.connect(_on_player_hint_display_on_input)
	GlobalSignals.effect_acquired.connect(_on_effect_acquired)
	GlobalSignals.encounter_start_progress.connect(_on_encounter_start_progress)
	GlobalSignals.encounter_starting.connect(_on_encounter_starting)
	GlobalSignals.encounter_resetting.connect(_on_encounter_resetting)


## Timer
func show_timer() -> void:
	player_hud.timer_display.show()


func hide_timer() -> void:
	player_hud.timer_display.hide()


func set_timer_for_display(display_timer: Timer) -> void:
	player_hud.timer_display.set_timer(display_timer)


## Hint Display
func load_location_state_display(state_display: LocationState) -> void:
	player_hud.inject_location_state(state_display)


func show_hints_at_start(show_at_start: bool) -> void:
	player_hud.display_hint_on_start(show_at_start)


func show_hint_display() -> void:
	player_hud.show_location_state()


func hide_hint_display() -> void:
	player_hud.hide_location_state()


## Screen fades
func fade_screen_out(callback: Callable = Callable()) -> void:
	player_hud.fade_screen_to_black(callback)


func fade_screen_in(callback: Callable = Callable()) -> void:
	player_hud.fade_screen_to_normal(callback)


## Player signals
func _on_player_can_interact(interactable: InteractableComponent) -> void:
	player_hud.display_interact_prompt_for_interactable(interactable)


func _on_player_can_not_interact() -> void:
	player_hud.hide_interact_prompt()


func _on_player_interact_progress_made(current_progress: float) -> void:
	player_hud.set_interact_progress(current_progress)


func _on_player_interaction_complete(_interactable: InteractableComponent) -> void:
	player_hud.set_interact_progress(0) # why no work...
	player_hud.hide_interact_prompt()


func _on_player_hint_display_on_input(display: bool) -> void:
	player_hud.display_hint_on_start(not display)


## Effect Signals
func _on_effect_acquired(effect: Effect) -> void:
	player_hud.add_effect(effect)


## Encounter Signals
func _on_encounter_start_progress(percent: float) -> void:
	player_hud.set_encounter_start_progress(percent)


func _on_encounter_starting() -> void:
	player_hud.hide_encounter_start_display()


func _on_encounter_resetting() -> void:
	player_hud.show_encounter_start_display()
	player_hud.timer_display.hide()
	player_hud.hide_location_state()
