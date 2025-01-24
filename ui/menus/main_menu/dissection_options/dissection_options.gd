class_name DissectionOptions
extends VBoxContainer

signal settings_updated(settings: Dictionary)

@onready var spin_box: SpinBox = %SpinBox


func _ready() -> void:
	spin_box.value_changed.connect(_on_timer_value_changed)


func focus_first_item() -> void:
	print("grabbing spin")
	spin_box.grab_focus.call_deferred()


func get_values() -> Dictionary:
	return {
		"Timer": spin_box.value,
	}


func _on_timer_value_changed(value: float) -> void:
	settings_updated.emit(get_values())
