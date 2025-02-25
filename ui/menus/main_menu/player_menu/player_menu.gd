class_name PlayerMenu
extends CanvasLayer

const MENU_META := "mech_menu_meta"

@onready var main_menu_tab_container: TabContainer = %MainMenuTabContainer
@onready var home_menu: VBoxContainer = %HomeMenu
@onready var descriptions_container: VBoxContainer = %DescriptionsContainer

@onready var key_building_button: Button = %KeyBuildingButton
@onready var ghosts_button: Button = %GhostsButton
@onready var misc_button: Button = %MiscButton

@onready var restart_encounter_button: Button = %RestartEncounterButton

var _enabled: bool = false
var _menu_settings_map: Dictionary


func _ready() -> void:
	_connect_signals()
	return_to_home()
	hide_menu()


func show_menu() -> void:
	show()


func hide_menu() -> void:
	hide()


func return_to_home() -> void:
	_set_current_tab(0)
	home_menu.get_child(0).grab_focus.call_deferred()


# TODO: Have menu priority for listing order?
func add_menu_option(menu: MechanicOptions) -> void:
	# Set up the menu button to open the sub menu
	var menu_title := menu.get_menu_title()
	var menu_button := Button.new()
	menu_button.text = menu_title + " >"
	menu_button.theme_type_variation = "MenuSelectButton"
	menu_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	menu_button.custom_minimum_size = Vector2(0, 100)
	var tab_index := main_menu_tab_container.get_child_count()
	menu_button.pressed.connect(_set_current_tab.bind(tab_index, menu))
	home_menu.add_child(menu_button)
	home_menu.move_child(%SubMenuPlaceholders, tab_index) # FIXME: Hack for placeholders
	
	# Menu description settings
	var settings_panel := PanelContainer.new()
	settings_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var settings_vbox := VBoxContainer.new()
	var settings_title := Label.new()
	settings_title.text = menu_title
	settings_title.theme_type_variation = "HeaderMedium"
	var settings_description := RichTextLabel.new()
	settings_description.bbcode_enabled = true
	settings_description.fit_content = true
	settings_description.deselect_on_focus_loss_enabled = false
	settings_description.drag_and_drop_selection_enabled = false
	settings_description.add_theme_font_size_override("normal_font_size", 25)
	settings_vbox.add_child(settings_title)
	settings_vbox.add_child(settings_description)
	settings_panel.add_child(settings_vbox)
	descriptions_container.add_child(settings_panel)
	descriptions_container.move_child(%DescriptionPlaceholders, tab_index)
	menu.ready.connect(_get_menu_settings_on_ready.bind(menu, tab_index)) # Kinda hacky...
	
	_menu_settings_map[tab_index] = settings_description # Map this so we can find it later
	
	# Connect some signals
	menu.navigated_back.connect(return_to_home)
	menu.settings_updated.connect(_update_settings_for_menu.bind(tab_index))
	
	# Add a back button above the sub-menu
	var back_button := Button.new()
	back_button.text = "< Back"
	back_button.pressed.connect(return_to_home)
	
	# Add the sub-menu to the tab container
	var sub_menu_container := VBoxContainer.new()
	sub_menu_container.add_child(back_button)
	sub_menu_container.add_child(menu)
	main_menu_tab_container.add_child(sub_menu_container)


func _connect_signals() -> void:
	#key_building_button.pressed.connect(_set_current_tab.bind(2))
	#ghosts_button.pressed.connect(_set_current_tab.bind(2))
	#misc_button.pressed.connect(_set_current_tab.bind(2))
	restart_encounter_button.pressed.connect(_on_restart_encounter_pressed)


func _get_menu_settings_on_ready(menu: MechanicOptions, menu_index: int) -> void:
	var settings := menu.get_mechanics_state_description()
	_update_settings_for_menu(settings, menu_index)


func _update_settings_for_menu(settings: Dictionary, menu_index: int) -> void:
	var rich_settings_label: RichTextLabel = _menu_settings_map[menu_index]
	var settings_text := ""
	for setting: String in settings:
		if not settings_text.is_empty():
			settings_text += "\n"
		settings_text += "  %s: %s" % [setting, settings[setting]]
	
	rich_settings_label.text = "[ul] %s [/ul]" % settings_text


func _set_current_tab(tab_number: int, menu: Control = null) -> void:
	main_menu_tab_container.current_tab = tab_number
	if is_instance_valid(menu) and menu.has_method("focus_first_item"):
		menu.focus_first_item()


func _on_restart_encounter_pressed() -> void:
	GlobalSignals.emit_encounter_resetting()
