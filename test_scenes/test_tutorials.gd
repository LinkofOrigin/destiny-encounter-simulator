@tool
extends Control

@export_tool_button("Toggle Hud") var toggle_hud := toggle_hud_in_tutorial
@export_tool_button("Toggle Menu") var toggle_menu := toggle_menu_in_tutorial
@export_range(0, 100, 1) var current_tab := 0:
	set = _set_current_tab

@export var test_hud: PlayerHUD
@export var test_menu: PlayerMenu
@export var test_tutorial: Tutorial


func _ready() -> void:
	if not Engine.is_editor_hint():
		test_hud.hide()
		test_menu.hide()
	test_tutorial.start.call_deferred()


func toggle_hud_in_tutorial() -> void:
	if test_hud.layer == test_tutorial.layer:
		# Hide
		test_hud.layer = test_tutorial.layer - 1
		test_hud.hide()
	else:
		# Show
		test_hud.layer = test_tutorial.layer
		test_hud.show()


func toggle_menu_in_tutorial() -> void:
	if test_menu.layer == test_tutorial.layer:
		# Hide
		test_menu.layer = test_tutorial.layer - 1
		test_menu.hide()
	else:
		# Show
		test_menu.layer = test_tutorial.layer
		test_menu.show()


func _set_current_tab(tab_index: int) -> void:
	if is_inside_tree() and is_instance_valid(test_tutorial):
		current_tab = tab_index
		test_tutorial.tab_container.current_tab = current_tab
