class_name HintDisplaySettings
extends MenuButton

signal updated(show_statue_shapes: bool, show_shape_logic: bool, show_key_matches: bool)

@onready var popup: PopupMenu = get_popup()


func _ready() -> void:
	focus_entered.connect(_on_focused)
	popup.hide_on_checkable_item_selection = false
	popup.hide_on_item_selection = false
	popup.index_pressed.connect(_on_item_selected)
	popup.window_input.connect(_process_popup_input)


func _on_focused() -> void:
	show_popup()


func _on_item_selected(index: int) -> void:
	popup.toggle_item_checked(index)
	_emit_updated()


func _emit_updated() -> void:
	var show_statue_shapes := popup.is_item_checked(0)
	var show_shape_logic := popup.is_item_checked(1)
	var show_key_matches := popup.is_item_checked(2)
	updated.emit(show_statue_shapes, show_shape_logic, show_key_matches)


func _process_popup_input(event: InputEvent) -> void:
	if event.is_action_pressed("MenuBack"):
		popup.hide()
		release_focus()
