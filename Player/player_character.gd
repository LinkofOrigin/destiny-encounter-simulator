class_name PlayerCharacter
extends CharacterBody3D

signal can_interact(interactable: InteractableComponent)
signal can_not_interact
signal interact_progress_made(current_progress: float)
signal interaction_complete

const MAX_CAMERA_UP: float = PI / 2.0
const MIN_CAMERA_DOWN: float = PI / -2.0

@onready var input_handler: InputHandlerComponent = $InputHandlerComponent
@onready var camera: Camera3D = $Camera3D
@onready var movement_component: MovementComponent = $MovementComponent
@onready var state_machine: StateMachine = $StateMachine
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var interactable_detector: InteractableDetector = $InteractableDetector
@onready var effect_manager: EffectManager = $EffectManager


var _can_interact: bool = false
var _active_interactable: InteractableComponent


func _ready() -> void:
	interactable_detector.can_interact_with.connect(_on_can_interact_with)
	interactable_detector.can_not_interact.connect(_on_can_not_interact)
	input_handler.interaction_complete.connect(_on_input_handler_interact_complete)
	input_handler.interaction_progress.connect(_on_input_handler_interaction_progress)


func _process(delta: float) -> void:
	if _can_interact and is_instance_valid(_active_interactable):
		# use input handler to interact
		input_handler.handle_interaction(delta, _active_interactable.interact_time)


func _physics_process(delta: float) -> void:
	_handle_camera(delta)
	state_machine.process_state(delta)


func _handle_camera(delta: float) -> void:
	var new_rotation := input_handler.get_camera_movement_vector(delta)
	if new_rotation != Vector2(0,0):
		#print("rotate: ", new_rotation)
		pass
	
	_apply_look_rotation(new_rotation.x, new_rotation.y)


func _on_input_handler_interaction_progress(percent: float) -> void:
	interact_progress_made.emit(percent)
	GlobalSignals.emit_player_interact_progress_made(percent)


func _on_input_handler_interact_complete() -> void:
	_active_interactable.complete_interaction(effect_manager)
	interaction_complete.emit()
	GlobalSignals.emit_player_interaction_complete(_active_interactable)


func _on_can_interact_with(interactable: InteractableComponent) -> void:
	#print("player can interact!")
	if interactable.check_interact_condition(effect_manager):
		_can_interact = true
		_active_interactable = interactable
		can_interact.emit(interactable)
		GlobalSignals.emit_player_can_interact(interactable)


func _on_can_not_interact() -> void:
	#print("player can NOT interact!")
	_can_interact = false
	input_handler.release_interact_lock()
	_active_interactable = null
	can_not_interact.emit()
	GlobalSignals.emit_player_can_not_interact()


func _apply_look_rotation(horizontal_rotation: float, vertical_rotation: float) -> void:
	rotate_y(horizontal_rotation)
	camera.rotate_x(vertical_rotation)
	
	rotation.y = fmod(rotation.y, 2 * PI) # Don't let the rotation go up/down forever and hit a number storage boundary
	camera.rotation.x = clamp(camera.rotation.x, MIN_CAMERA_DOWN, MAX_CAMERA_UP) # Prevent looking past straight up or down


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_motion := input_handler.get_mouse_motion_vector_from_event(event as InputEventMouseMotion)
		_apply_look_rotation(mouse_motion.x, mouse_motion.y)
