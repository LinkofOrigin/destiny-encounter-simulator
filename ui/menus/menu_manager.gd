# class_name MenuManager
extends CanvasGroup

@onready var player_menu: PlayerMenu = %PlayerMenu

var paused := false


func is_paused() -> bool:
	return paused


func pause_and_display_menu() -> void:
	paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player_menu.show()


func unpause_and_hide_menu() -> void:
	player_menu.hide()
	paused = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu"):
		if paused:
			unpause_and_hide_menu()
		else:
			pause_and_display_menu()
