class_name OptionContainer
extends PanelContainer

signal cancel_pressed

@export var target_control: Control
@export var shortcut_indicator_container: Container

var _normal_stylebox := get_theme_stylebox("panel")
var _focused_stylebox := get_theme_stylebox("focused", "PanelContainer")


func _init() -> void:
	focus_mode = FOCUS_ALL


func _ready() -> void:
	if not is_instance_valid(target_control):
		var children := find_children("*", "Control", true)
		for child: Control in children:
			if child.focus_mode != Control.FOCUS_NONE:
				target_control = child
				break
	if is_instance_valid(target_control):
		target_control.focus_exited.connect(grab_focus)
		
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	if is_instance_valid(shortcut_indicator_container):
		shortcut_indicator_container.hide()


func _draw() -> void:
	if has_focus():
		_set_to_focused_variation()
	else:
		_set_to_normal()


func _set_to_focused_variation() -> void:
	_draw_stylebox(_focused_stylebox)


func _set_to_normal() -> void:
	_draw_stylebox(_normal_stylebox)


func _draw_stylebox(stylebox: StyleBox) -> void:
	var rect := Rect2(Vector2(0,0), size)
	draw_style_box(stylebox, rect)


func _gui_input(event: InputEvent) -> void:
	# If "shortcut", pass to inner element to process
	if is_instance_valid(target_control) and target_control.has_method("process_shortcut"):
		var processed: bool = target_control.process_shortcut(event)
		if processed:
			accept_event()
			return
	
	# If "selected", pass focus to inner element
	if event.is_action_pressed("ui_accept") and is_instance_valid(target_control):
		target_control.grab_focus()
	
	# If "back" navigation, send signal(?) for parent
	if event.is_action_pressed("MenuBack"):
		cancel_pressed.emit()


func _on_focus_entered() -> void:
	if is_instance_valid(shortcut_indicator_container):
		shortcut_indicator_container.show()


func _on_focus_exited() -> void:
	if is_instance_valid(shortcut_indicator_container):
		shortcut_indicator_container.hide()
