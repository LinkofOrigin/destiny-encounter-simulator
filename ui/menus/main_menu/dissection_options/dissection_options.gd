class_name DissectionOptions
extends MechanicOptions

signal timer_value_changed(new_time: float)
signal hint_display_changed(display: bool)
signal settings_updated(settings: Dictionary)

const MENU_BUTTON_TEXT := "Dissection"

@onready var timer_spin_box: SpinBox = %TimerSpinBox
@onready var hint_display_checkbox: CheckBox = %HintDisplayCheckbox


func _ready() -> void:
	timer_spin_box.value_changed.connect(_on_timer_value_changed)
	hint_display_checkbox.toggled.connect(_on_hint_display_checkbox_toggled)


func get_menu_button_text() -> String:
	return MENU_BUTTON_TEXT


func focus_first_item() -> void:
	#print("grabbing spin")
	timer_spin_box.grab_focus.call_deferred()


func get_values() -> Dictionary:
	return {
		"Timer": timer_spin_box.value,
	}


func _on_timer_value_changed(value: float) -> void:
	settings_updated.emit(get_values())
	timer_value_changed.emit(value)


func _on_hint_display_checkbox_toggled(toggled_on: bool) -> void:
	hint_display_changed.emit(toggled_on)
	if toggled_on:
		PlayerHudManager.show_hint_display()
	else:
		PlayerHudManager.hide_hint_display()
