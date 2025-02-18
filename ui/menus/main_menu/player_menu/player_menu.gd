class_name PlayerMenu
extends CanvasLayer

@onready var main_menu_tab_container: TabContainer = %MainMenuTabContainer
@onready var home_menu: VBoxContainer = %HomeMenu

@onready var key_building_button: Button = %KeyBuildingButton
@onready var ghosts_button: Button = %GhostsButton
@onready var misc_button: Button = %MiscButton

@onready var dissection_details: RichTextLabel = %DissectionDetails

@onready var restart_encounter_button: Button = %RestartEncounterButton


func _ready() -> void:
	_connect_signals()
	return_to_home()
	hide()


func return_to_home() -> void:
	_set_current_tab(0)
	home_menu.get_child(0).grab_focus.call_deferred()


func add_menu_option(menu: MechanicOptions) -> void:
	# TODO: Have menu priority for listing order?
	var button_text := menu.get_menu_button_text()
	var menu_button := Button.new()
	menu_button.text = button_text + " >"
	menu_button.theme_type_variation = "MenuSelectButton"
	menu_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	menu_button.custom_minimum_size = Vector2(0, 100)
	var tab_index := main_menu_tab_container.get_child_count()
	menu_button.pressed.connect(_set_current_tab.bind(tab_index, menu))
	home_menu.add_child(menu_button)
	home_menu.move_child(%Placeholders, tab_index) # FIXME: Hack for placeholders
	
	var back_button := Button.new()
	back_button.text = "< Back"
	back_button.pressed.connect(return_to_home)
	
	var sub_menu_container := VBoxContainer.new()
	sub_menu_container.add_child(back_button)
	sub_menu_container.add_child(menu)
	
	main_menu_tab_container.add_child(sub_menu_container)


func _connect_signals() -> void:
	key_building_button.pressed.connect(_set_current_tab.bind(2))
	ghosts_button.pressed.connect(_set_current_tab.bind(2))
	misc_button.pressed.connect(_set_current_tab.bind(2))
	restart_encounter_button.pressed.connect(_on_restart_encounter_pressed)


func _update_dissection_settings(settings: Dictionary) -> void:
	print("updating settings")
	var dissection_setting_text := ""
	for setting: String in settings:
		if not dissection_setting_text.is_empty():
			dissection_setting_text += "\n"
		dissection_setting_text += "  %s: %s" % [setting, settings[setting]]
	
	dissection_details.text = "[ul]"
	dissection_details.text += dissection_setting_text
	dissection_details.text += "[/ul]"


func _set_current_tab(tab_number: int, menu: Control = null) -> void:
	main_menu_tab_container.current_tab = tab_number
	if is_instance_valid(menu) and menu.has_method("focus_first_item"):
		menu.focus_first_item()


func _on_restart_encounter_pressed() -> void:
	GlobalSignals.emit_encounter_resetting()
