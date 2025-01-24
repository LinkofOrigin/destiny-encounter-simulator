class_name StartEncounterDisplay
extends PanelContainer

signal encounter_start

@onready var progress_bar: ProgressBar = %ProgressBar


func set_progress_percent(percent: float) -> void:
	progress_bar.value = percent * progress_bar.max_value
