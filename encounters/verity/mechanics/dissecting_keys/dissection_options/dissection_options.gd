class_name DissectionOptions
extends MechanicOptions

signal timer_value_changed(new_time: float)
signal hint_display_changed(display: bool)

const MENU_TITLE := "Dissection"

@onready var timer_spin_box: SpinBox = %TimerSpinBox
@onready var hint_display_options: OptionButton = %HintDisplayOptions


func _ready_behavior() -> void:
	timer_spin_box.value_changed.connect(_on_timer_value_changed)
	hint_display_options.item_selected.connect(_on_hint_display_option_selected)


func get_menu_title() -> String:
	return MENU_TITLE


func get_mechanics_state_description() -> Dictionary:
	return {
		"Timer": timer_spin_box.value,
	}


func _on_timer_value_changed(value: float) -> void:
	timer_value_changed.emit(value)
	_emit_settings_updated(get_mechanics_state_description())


func _on_hint_display_checkbox_toggled(toggled_on: bool) -> void:
	hint_display_changed.emit(toggled_on)
	if toggled_on:
		PlayerHudManager.show_hint_display()
	else:
		PlayerHudManager.hide_hint_display()


func _on_hint_display_option_selected(item_index: int) -> void:
	if item_index == 0:
		# enabled, input-based display
		GlobalSignals.emit_player_hint_display_on_input(false)
		PlayerHudManager.show_hints_at_start(true)
	elif item_index == 2:
		# show on button press only
		GlobalSignals.emit_player_hint_display_on_input(true)
		PlayerHudManager.show_hints_at_start(false)
	elif item_index == 4:
		GlobalSignals.emit_player_hint_display_on_input(false)
		PlayerHudManager.show_hints_at_start(false)
