@tool
class_name DebugTeleporter
extends Area3D

@export var teleport_location: Marker3D
@export var text_indicator: String = "PORTAL":
	set = set_text_indicator

@onready var label_indicator: Label3D = %LabelIndicator


func _ready() -> void:
	label_indicator.text = text_indicator
	
	if not Engine.is_editor_hint():
		if not is_instance_valid(teleport_location):
			var children := find_children("*", "Marker3D")
			assert(not children.is_empty(), "No location for teleporter!")
			teleport_location = children.pop_front()
	


func teleport_body(body: Node3D):
	print("teleporting player!")
	body.global_position = teleport_location.global_position
	body.rotation = teleport_location.rotation


func set_text_indicator(new_text: String):
	text_indicator = new_text
	if is_instance_valid(label_indicator):
		label_indicator.text = text_indicator


func _on_body_entered(body: Node3D) -> void:
	if is_instance_of(body, PlayerCharacter):
		teleport_body(body)
