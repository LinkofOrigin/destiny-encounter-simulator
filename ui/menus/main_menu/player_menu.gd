class_name PlayerMenu
extends CanvasLayer

@onready var main_menu_tab_container: TabContainer = %MainMenuTabContainer
@onready var dissection_button: Button = %DissectionButton
@onready var key_building_button: Button = %KeyBuildingButton
@onready var ghosts_button: Button = %GhostsButton
@onready var misc_button: Button = %MiscButton
@onready var dissection_back_button: Button = %DissectionBackButton

@onready var dissection_options: DissectionOptions = %DissectionOptions
@onready var dissection_details: RichTextLabel = %DissectionDetails


func _ready() -> void:
	_connect_signals()
	hide()


func _connect_signals() -> void:
	dissection_button.pressed.connect(_set_current_tab.bind(1))
	key_building_button.pressed.connect(_set_current_tab.bind(2))
	ghosts_button.pressed.connect(_set_current_tab.bind(2))
	misc_button.pressed.connect(_set_current_tab.bind(2))
	
	dissection_options.settings_updated.connect(_update_dissection_settings)
	dissection_back_button.pressed.connect(_return_to_home)


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


func _set_current_tab(tab_number: int) -> void:
	main_menu_tab_container.current_tab = tab_number


func _return_to_home() -> void:
	_set_current_tab(0)
