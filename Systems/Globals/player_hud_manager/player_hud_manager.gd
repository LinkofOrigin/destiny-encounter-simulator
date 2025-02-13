# class_name PlayerHudManager
extends Node

@onready var player_hud: PlayerHUD = $PlayerHud


func _ready() -> void:
	GlobalSignals.player_can_interact.connect(_on_player_can_interact)
	GlobalSignals.player_can_not_interact.connect(_on_player_can_not_interact)
	GlobalSignals.player_interact_progress_made.connect(_on_player_interact_progress_made)
	GlobalSignals.player_interaction_complete.connect(_on_player_interaction_complete)
	GlobalSignals.effect_acquired.connect(_on_effect_acquired)
	GlobalSignals.encounter_start_progress.connect(_on_encounter_start_progress)
	GlobalSignals.encounter_starting.connect(_on_encounter_starting)


func load_location_state_display(state_display: LocationState) -> void:
	player_hud.inject_location_state(state_display)


func _on_player_can_interact(interactable: InteractableComponent) -> void:
	player_hud.display_interact_prompt_for_interactable(interactable)


func _on_player_can_not_interact() -> void:
	player_hud.hide_interact_prompt()


func _on_player_interact_progress_made(current_progress: float) -> void:
	player_hud.set_interact_progress(current_progress)


func _on_player_interaction_complete(_interactable: InteractableComponent) -> void:
	player_hud.set_interact_progress(0) # why no work...
	player_hud.hide_interact_prompt()


func _on_effect_acquired(effect: Effect) -> void:
	player_hud.add_effect(effect)


func _on_encounter_start_progress(percent: float) -> void:
	player_hud.set_encounter_start_progress(percent)


func _on_encounter_starting() -> void:
	player_hud.hide_encounter_start_display()
