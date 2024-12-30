class_name PlayerHUD
extends CanvasLayer

@onready var interact_prompt: InteractPrompt = $InteractPrompt
@onready var effect_display: EffectDisplay = $EffectDisplay


func _ready() -> void:
	interact_prompt.visible = false


func display_interact_prompt_for_interactable(interactable: InteractableComponent) -> void:
	interact_prompt.set_data(interactable.input_icon, interactable.prompt_text)
	interact_prompt.visible = true


func hide_interact_prompt() -> void:
	interact_prompt.visible = false


func set_interact_progress(progress: float) -> void:
	interact_prompt.set_progress(progress)


func add_effect(effect: Effect) -> void:
	effect_display.add_effect(effect)
