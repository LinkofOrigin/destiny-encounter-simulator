# class_name GlobalSignals
extends Node

# Player signals
signal player_can_interact(interactable: InteractableComponent)
signal player_can_not_interact()
signal player_interact_progress_made(current_progress: float)
signal player_interaction_complete(interactable: InteractableComponent)

func emit_player_can_interact(interactable: InteractableComponent) -> void:
	player_can_interact.emit(interactable)


func emit_player_can_not_interact() -> void:
	player_can_not_interact.emit()


func emit_player_interact_progress_made(current_progress: float) -> void:
	player_interact_progress_made.emit(current_progress)


func emit_player_interaction_complete(interactable: InteractableComponent) -> void:
	player_interaction_complete.emit(interactable)


# Buff Effect signals
signal effect_acquired(effect: Effect)


func emit_effect_acquired(effect: Effect) -> void:
	effect_acquired.emit(effect)
