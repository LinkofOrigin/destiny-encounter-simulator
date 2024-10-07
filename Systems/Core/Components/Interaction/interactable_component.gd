class_name InteractableComponent
extends Node3D

@export_category("Interaction Settings")
@export var input_icon: Texture2D = preload("res://addons/controller_icons/assets/xboxseries/x.png")
@export var prompt_text: String = "INTERACT"
## Time in seconds to complete interaction
@export_range(0.2, 5.0, 0.1) var interact_time: float = 1.0

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
