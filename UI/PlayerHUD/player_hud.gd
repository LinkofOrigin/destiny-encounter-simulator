class_name PlayerHUD
extends CanvasLayer

@onready var interact_prompt: InteractPrompt = $InteractPrompt


func _ready():
	interact_prompt.visible = false


func display_interact_prompt_for_interactable(interactable: InteractableComponent):
	interact_prompt.set_data(interactable.input_icon, interactable.prompt_text)
	interact_prompt.visible = true


func hide_interact_prompt():
	interact_prompt.visible = false


func set_interact_progress(progress: float):
	interact_prompt.set_progress(progress)
