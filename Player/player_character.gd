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
	if new_rotation != Vector2(0,0):
		#print("rotate: ", new_rotation)
		pass
	
	_apply_look_rotation(new_rotation.x, new_rotation.y)


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


func _apply_look_rotation(horizontal_rotation: float, vertical_rotation: float):
	rotate_y(horizontal_rotation)
	camera.rotate_x(vertical_rotation)
	
	rotation.y = fmod(rotation.y, 2 * PI) # Don't let the rotation go up/down forever and hit a number storage boundary
	camera.rotation.x = clamp(camera.rotation.x, MIN_CAMERA_DOWN, MAX_CAMERA_UP) # Prevent looking past straight up or down


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_motion := input_handler.get_mouse_motion_vector_from_event(event as InputEventMouseMotion)
		_apply_look_rotation(mouse_motion.x, mouse_motion.y)
