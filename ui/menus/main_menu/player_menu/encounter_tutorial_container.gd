class_name EncounterPanelContainer
extends PanelContainer

@onready var hide_encounter_tutorial_button: Button = %HideEncounterTutorialButton
@onready var encounter_tutorial_tab_container: TabContainer = %EncounterTutorialTabContainer
@onready var change_tab_indicator: VBoxContainer = %ChangeTabIndicator
@onready var scroll_indicator: VBoxContainer = %ScrollIndicator

var rich_text_label: RichTextLabel


func _ready() -> void:
	hide_encounter_tutorial_button.pressed.connect(_on_hide_encounter_tutorial_button_pressed)
	if encounter_tutorial_tab_container.get_tab_count() <= 1:
		change_tab_indicator.hide()
	var rich_text_labels := find_children("*", "RichTextLabel", true)
	for label in rich_text_labels:
		if label is RichTextLabel:
			# TODO: rework this file to grab the label based on the current tab as index to child nodes
			rich_text_label = label # Just grab the first one for now
			break


func _process(delta: float) -> void:
	if encounter_tutorial_tab_container.has_focus():
		var scroll_strength := Input.get_axis("JoystickCameraUp", "JoystickCameraDown")
		rich_text_label.get_v_scroll_bar().value += ceili(scroll_strength * 4.5)


func show_extra_menu() -> void:
	show()
	encounter_tutorial_tab_container.grab_focus()


func hide_extra_menu() -> void:
	hide()
	release_focus()


func _on_hide_encounter_tutorial_button_pressed() -> void:
	hide_extra_menu()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MenuOptionIncrease"):
		encounter_tutorial_tab_container.current_tab = (encounter_tutorial_tab_container.current_tab + 1) % encounter_tutorial_tab_container.get_tab_count()
	elif event.is_action_pressed("MenuOptionDecrease"):
		if encounter_tutorial_tab_container.current_tab == 0:
			encounter_tutorial_tab_container.current_tab = encounter_tutorial_tab_container.get_tab_count() - 1
		else:
			encounter_tutorial_tab_container.current_tab -= 1
