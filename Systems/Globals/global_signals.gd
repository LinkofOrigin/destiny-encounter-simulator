# class_name GlobalSignals
extends Node

## Player signals
signal player_allowed_interaction(interact_allowed: bool)
signal player_can_interact(interactable: InteractableComponent)
signal player_can_not_interact()
signal player_interact_progress_made(current_progress: float)
signal player_interaction_complete(interactable: InteractableComponent)
signal player_hint_display_on_input(display: bool)
signal restricted_input_changed(restricted: bool)


func emit_player_interaction_allowed(interact_allowed: bool) -> void:
	player_allowed_interaction.emit(interact_allowed)


func emit_player_can_interact(interactable: InteractableComponent) -> void:
	player_can_interact.emit(interactable)


func emit_player_can_not_interact() -> void:
	player_can_not_interact.emit()


func emit_player_interact_progress_made(current_progress: float) -> void:
	player_interact_progress_made.emit(current_progress)


func emit_player_interaction_complete(interactable: InteractableComponent) -> void:
	player_interaction_complete.emit(interactable)


func emit_player_hint_display_on_input(display: bool) -> void:
	player_hint_display_on_input.emit(display)


# TODO: This signal and it's effects are a bit hacky, lots of copy/paste. May consider changing later
func emit_restricted_input_changed(restricted: bool) -> void:
	restricted_input_changed.emit(restricted)


## Buff Effect signals
signal effect_acquired(effect: Effect)


func emit_effect_acquired(effect: Effect) -> void:
	effect_acquired.emit(effect)


## Encounter signals
signal encounter_start_progress(percent: float)
signal encounter_starting
signal encounter_resetting
signal encounter_complete


func emit_encounter_start_progress(percent: float) -> void:
	encounter_start_progress.emit(percent)


func emit_encounter_starting() -> void:
	encounter_starting.emit()


func emit_encounter_resetting() -> void:
	encounter_resetting.emit()


func emit_encounter_complete() -> void:
	encounter_complete.emit()
