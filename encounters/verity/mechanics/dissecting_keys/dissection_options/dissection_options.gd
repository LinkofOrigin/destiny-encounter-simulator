class_name DissectionOptions
extends MechanicOptions

signal timer_value_changed(new_time: float)
signal hint_display_changed(display: bool)
signal hint_display_settings_changed(statue_shapes: bool, shape_logic: bool, key_matches: bool)
signal statue_3d_hint_setting_changed(show_3d_statue_hints: bool)

const MENU_TITLE := "Dissection"

@onready var timer_spin_box: SpinBox = %TimerSpinBox
@onready var hint_display_options: MechanicOptionButton = %HintDisplayOptions
@onready var hint_display_settings: HintDisplaySettings = %HintDisplaySettings
@onready var statue_hint_setting_options: MechanicOptionButton = %StatueHintSettingOptions


func _ready_behavior() -> void:
	timer_spin_box.value_changed.connect(_on_timer_value_changed)
	hint_display_options.item_selected.connect(_on_hint_display_option_selected)
	hint_display_settings.updated.connect(_on_hint_settings_updated)
	statue_hint_setting_options.item_selected.connect(_on_statue_3d_hint_option_selected)


func get_menu_title() -> String:
	return MENU_TITLE


func get_mechanics_state_description() -> Dictionary:
	return {
		"Timer": timer_spin_box.value,
		"Hint Display": hint_display_options.get_settings_text(),
		"Hints Enabled": hint_display_settings.get_settings_text(),
		"Statue Hints": statue_hint_setting_options.get_settings_text()
	}


func _on_timer_value_changed(value: float) -> void:
	timer_value_changed.emit(value)
	_emit_settings_updated(get_mechanics_state_description())


func _on_hint_display_option_selected(item_index: int) -> void:
	if item_index == 0:
		# enabled, input-based display
		GlobalSignals.emit_player_hint_display_on_input(false)
		PlayerHudManager.show_hints_at_start(true)
		PlayerHudManager.show_hint_display()
	elif item_index == 2:
		# show on button press only
		GlobalSignals.emit_player_hint_display_on_input(true)
		PlayerHudManager.show_hints_at_start(false)
		PlayerHudManager.hide_hint_display()
	elif item_index == 4:
		GlobalSignals.emit_player_hint_display_on_input(false)
		PlayerHudManager.show_hints_at_start(false)
		PlayerHudManager.hide_hint_display()
	
	_emit_settings_updated(get_mechanics_state_description())


func _on_hint_settings_updated(show_statue_shapes: bool, show_shape_logic: bool, show_key_matches: bool) -> void:
	hint_display_settings_changed.emit(show_statue_shapes, show_shape_logic, show_key_matches)
	_emit_settings_updated(get_mechanics_state_description())


func _on_statue_3d_hint_option_selected(item_index: int) -> void:
	if item_index == 0:
		# enabled, statues should show their composing shapes
		statue_3d_hint_setting_changed.emit(true)
	elif item_index == 2:
		# disabled, statues should hide their composing shapes
		statue_3d_hint_setting_changed.emit(false)
	
	_emit_settings_updated(get_mechanics_state_description())
