class_name InteractableComponent
extends Node3D

var _interaction_zone: InteractionZone
var _interaction_target: InteractionTarget


func _ready():
	for area: Area3D in get_children():
		if area is InteractionZone:
			_interaction_zone = area
		elif area is InteractionTarget:
			_interaction_target = area
	
	# TODO: Change this to be @tool script logic or something
	assert(_interaction_zone != null, "Interaction Zone is not set")
	assert(_interaction_target != null, "Interaction Target is not set")
	
	# TODO: Consider making the child classes emit a signal for player specifically
	_interaction_zone.body_entered.connect(_on_zone_body_entered)
	_interaction_zone.body_exited.connect(_on_zone_body_exited)


func _on_zone_body_entered(body: Node3D):
	print("interaction zone entered!")
	GlobalSignals.body_entered_interaction_zone.emit(body, _interaction_zone)


func _on_zone_body_exited(body: Node3D):
	print("interaction zone exited!")
	GlobalSignals.body_exited_interaction_zone.emit(body, _interaction_zone)
