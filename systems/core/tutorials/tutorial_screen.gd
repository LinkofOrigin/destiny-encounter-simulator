class_name TutorialScreen
extends Control

const SCREEN_Z_INDEX := 10

var element_to_highlight: Control

var _element_prev_visibility: bool
var _element_prev_z_index: int
var _element_prev_layer: int


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	hidden.connect(_on_hidden)
	z_index = SCREEN_Z_INDEX
	z_as_relative = true


func _on_show_behavior() -> void:
	if is_instance_valid(element_to_highlight):
		_element_prev_visibility = element_to_highlight.visible
		_element_prev_z_index = element_to_highlight.z_index
		element_to_highlight.show()
		element_to_highlight.z_index = self.z_index + 1


func _on_hide_behavior() -> void:
	if is_instance_valid(element_to_highlight) and _element_prev_visibility != null and _element_prev_z_index != null:
		element_to_highlight.visible = _element_prev_visibility
		element_to_highlight.z_index = _element_prev_z_index


func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		_on_show_behavior()


func _on_hidden() -> void:
	if not is_visible_in_tree():
		_on_hide_behavior()
