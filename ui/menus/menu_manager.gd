# class_name MenuManager
extends CanvasGroup

@onready var player_menu: PlayerMenu = %PlayerMenu

var paused := false


func is_paused() -> bool:
	return paused


func pause_and_display_menu() -> void:
	paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE # TODO: Control via input manager?
	player_menu.return_to_home()
	player_menu.show_menu()


func unpause_and_hide_menu(is_controller: bool = false) -> void:
	player_menu.hide_menu()
	if not is_controller:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # TODO: Control via input manager?
	paused = false


func register_menu_option(menu: MechanicOptions) -> void:
	player_menu.add_menu_option(menu)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu"):
		if paused:
			var is_controller_input := event is InputEventJoypadButton
			unpause_and_hide_menu(is_controller_input)
		else:
			pause_and_display_menu()
