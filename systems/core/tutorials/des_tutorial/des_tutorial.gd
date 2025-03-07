extends Tutorial

@onready var tutorial_page_label: Label = %TutorialPageLabel

var _prev_mouse_state: Input.MouseMode

func start() -> void:
	super.start()
	# Hide the global menu and HUD stuff
	hide_menu_and_hud()
	tab_container.current_tab = 0
	tab_container.tab_changed.connect(_on_tab_changed)
	set_page_label()
	_prev_mouse_state = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func finish() -> void:
	super.finish()
	PlayerHudManager.player_hud.show()
	MenuManager.player_menu.hide()
	Input.mouse_mode = _prev_mouse_state


func set_page_label() -> void:
	tutorial_page_label.text = "Page %s/%s" % [tab_container.current_tab + 1, tab_container.get_tab_count()]


func hide_menu_and_hud() -> void:
	PlayerHudManager.player_hud.hide()
	MenuManager.player_menu.hide()


func _on_tab_changed(tab_index: int) -> void:
	set_page_label()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MenuOptionDecrease"):
		step_back()
	elif event.is_action_pressed("MenuOptionIncrease"):
		step_forward()
