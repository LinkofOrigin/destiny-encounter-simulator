class_name FullShapeRefContainer
extends PanelContainer

@onready var hide_shape_ref_button: Button = %HideShapeRefButton


func _ready() -> void:
	hide_shape_ref_button.pressed.connect(_on_button_pressed)


func show_reference_menu() -> void:
	show()
	hide_shape_ref_button.grab_focus.call_deferred()


func hide_shape_ref() -> void:
	hide()


func _on_button_pressed() -> void:
	hide_shape_ref()
