# class_name PlayerHudManager
extends Node

@onready var player_hud: PlayerHUD = $PlayerHud


func _ready() -> void:
	GlobalSignals.player_can_interact.connect(_on_player_can_interact)
	GlobalSignals.player_can_not_interact.connect(_on_player_can_not_interact)
	GlobalSignals.player_interact_progress_made.connect(_on_player_interact_progress_made)
	GlobalSignals.player_interaction_complete.connect(_on_player_interaction_complete)
	GlobalSignals.effect_acquired.connect(_on_effect_acquired)


func _on_player_can_interact(interactable: InteractableComponent) -> void:
	player_hud.display_interact_prompt_for_interactable(interactable)


func _on_player_can_not_interact() -> void:
	player_hud.hide_interact_prompt()


func _on_player_interact_progress_made(current_progress: float) -> void:
	player_hud.set_interact_progress(current_progress)


func _on_player_interaction_complete(interactable: InteractableComponent) -> void:
	# TODO: Evaluate if anything else should be done here...?
	player_hud.hide_interact_prompt()
	player_hud.set_interact_progress(0) # why no work...


func _on_effect_acquired(effect: Effect) -> void:
	player_hud.add_effect(effect)
