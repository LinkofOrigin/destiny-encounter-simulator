class_name InteractPrompt
extends PanelContainer

@onready var input_indicator: TextureRect = %InputIndicator
@onready var prompt_text: Label = %PromptText
@onready var progress_bar: TextureProgressBar = %ProgressIndicator

func _ready() -> void:
	progress_bar.value = 0


func set_data(input_texture: Texture2D, text: String) -> void:
	set_input_prompt(input_texture)
	set_text_prompt(text)


func set_input_prompt(input_texture: Texture2D) -> void:
	input_indicator.texture = input_texture


func set_text_prompt(text: String) -> void:
	prompt_text.text = text


func set_progress(progress: float) -> void:
	progress_bar.value = progress
