class_name MechanicOptionButton
extends OptionButton


func _ready() -> void:
	focus_entered.connect(show_popup)
	item_selected.connect(_item_selected)


func select_next_item() -> void:
	selected = (selected + 1) % (item_count)
	while is_item_disabled(selected) or is_item_separator(selected):
		selected = (selected + 1) % (item_count)
		if selected >= item_count:
			selected = 0


func select_prev_item() -> void:
	selected -= 1
	if selected < 0:
		selected = item_count - 1
	while is_item_disabled(selected) or is_item_separator(selected):
		selected -= 1
		if selected < 0:
			selected = item_count - 1


func process_shortcut(event: InputEvent) -> bool:
	var processed := false
	if event.is_action_pressed("MenuOptionDecrease"):
		select_prev_item()
		processed = true
	elif event.is_action_pressed("MenuOptionIncrease"):
		select_next_item()
		processed = true
	
	if processed:
		item_selected.emit(selected)
	return processed


func get_settings_text() -> String:
	return get_item_text(selected)


func _gui_input(event: InputEvent) -> void:
	var processed := process_shortcut(event)
	if processed:
		accept_event()
		return
	
	if event.is_action_pressed("MenuBack"):
		# TODO: Cancel changes, then Signal?
		release_focus()


func _item_selected(_item_index: int) -> void:
	release_focus()
