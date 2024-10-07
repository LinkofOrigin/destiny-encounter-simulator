class_name PlayerCharacter
extends CharacterBody3D

const MAX_CAMERA_UP: float = PI / 2.0
const MIN_CAMERA_DOWN: float = PI / -2.0

@onready var input_handler: InputHandlerComponent = $InputHandlerComponent
@onready var camera: Camera3D = $Camera3D
@onready var movement_component: MovementComponent = $MovementComponent
@onready var state_machine: StateMachine = $StateMachine
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var interactable_detector: InteractableDetector = $InteractableDetector
@onready var player_hud: PlayerHUD = $PlayerHud

var _can_interact: bool = false
var _active_interactable: InteractableComponent


func _ready():
	mesh_instance.visible = false # Hide the player character model for 1st person view
	
	interactable_detector.can_interact_with.connect(_on_can_interact_with)
	interactable_detector.can_not_interact.connect(_on_can_not_interact)


func _process(delta: float) -> void:
	if _can_interact:
		# use input handler to interact
		var current_progress := input_handler.handle_interaction(delta, _active_interactable.interact_time)
		player_hud.set_interact_progress(current_progress)


func _physics_process(delta: float):
	_handle_camera(delta)
	state_machine.process_state(delta)


func _handle_camera(delta: float):
	var new_rotation := input_handler.get_camera_movement_vector(delta)
	
	var new_turn_rotation = fmod(rotation.y + (new_rotation.x * -1), 2 * PI)
	var new_camera_rotation = clamp(camera.rotation.x + new_rotation.y, MIN_CAMERA_DOWN, MAX_CAMERA_UP)
	
	rotation.y = new_turn_rotation 
	camera.rotation.x = new_camera_rotation


func _on_can_interact_with(interactable: InteractableComponent) -> void:
	print("player can interact!")
	_can_interact = true
	_active_interactable = interactable
	player_hud.display_interact_prompt_for_interactable(interactable)


func _on_can_not_interact() -> void:
	print("player can NOT interact!")
	_can_interact = false
	_active_interactable = null
	player_hud.hide_interact_prompt()
