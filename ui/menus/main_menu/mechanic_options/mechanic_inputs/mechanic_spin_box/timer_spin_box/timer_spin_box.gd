class_name TimerSpinBox
extends SpinBox


func increment() -> void:
	set_value(value + 1)


func decrement() -> void:
	set_value(value - 1)


func arrow_step_up() -> void:
	set_value(value + custom_arrow_step)


func arrow_step_down() -> void:
	set_value(value - custom_arrow_step)


func process_shortcut(event: InputEvent) -> bool:
	var processed := false
	if event.is_action_pressed("MenuOptionDecrease"):
		arrow_step_down()
		processed = true
	elif event.is_action_pressed("MenuOptionIncrease"):
		arrow_step_up()
		processed = true
	
	return processed


func _gui_input(event: InputEvent) -> void:
	var processed := process_shortcut(event)
	if processed:
		accept_event()
		return
	
	if event.is_action_pressed("ui_up"):
		increment()
		accept_event()
	elif event.is_action_pressed("ui_down"):
		decrement()
		accept_event()
	elif event.is_action_pressed("MenuBack"):
		# TODO: Cancel changes, then Signal?
		release_focus()
	elif event.is_action_pressed("ui_accept"):
		# TODO: Save changes, then signal?
		release_focus()
