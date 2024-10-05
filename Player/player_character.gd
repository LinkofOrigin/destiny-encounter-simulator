class_name PlayerCharacter
extends CharacterBody3D

const MAX_CAMERA_UP: float = PI / 2.0
const MIN_CAMERA_DOWN: float = PI / -2.0

@onready var input_handler: InputHandlerComponent = $InputHandlerComponent
@onready var camera: Camera3D = $Camera3D
@onready var movement_component: MovementComponent = $MovementComponent
@onready var state_machine: StateMachine = $StateMachine
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var interaction_detector: InteractionDetector = $InteractionDetector

var _in_interaction_zone: bool = false
var _looking_at_interaction_target: bool = false


func _ready():
	GlobalSignals.body_entered_interaction_zone.connect(_on_interaction_zone_entered)
	GlobalSignals.body_exited_interaction_zone.connect(_on_interaction_zone_exited)
	mesh_instance.visible = false # Hide the player character model for 1st person view


func _process(delta: float) -> void:
	# FIXME: remove after testing
	#input_handler.handle_interaction(delta)
	if _can_interact():
		# use input handler to interact
		#print("player can interact!")
		input_handler.handle_interaction(delta)


func _physics_process(delta: float):
	_handle_camera(delta)
	state_machine.process_state(delta)


func _handle_camera(delta: float):
	var new_rotation = input_handler.get_camera_movement_vector(delta)
	
	var new_turn_rotation = fmod(rotation.y + (new_rotation.x * -1), 2 * PI)
	var new_camera_rotation = clamp(camera.rotation.x + new_rotation.y, MIN_CAMERA_DOWN, MAX_CAMERA_UP)
	
	rotation.y = new_turn_rotation 
	camera.rotation.x = new_camera_rotation


func _can_interact() -> bool:
	return _in_interaction_zone and _looking_at_interaction_target


func _on_interaction_detector_target_entered(_target: InteractionTarget) -> void:
	print("detector found target!")
	_looking_at_interaction_target = true


func _on_interaction_detector_target_exited() -> void:
	print("detector left target!")
	_looking_at_interaction_target = false


func _on_interaction_zone_entered(body: Node3D, zone: InteractionZone) -> void:
	if (body as PlayerCharacter) == self:
		_in_interaction_zone = true


func _on_interaction_zone_exited(body: Node3D, zone: InteractionZone) -> void:
	if (body as PlayerCharacter) == self:
		_in_interaction_zone = false
