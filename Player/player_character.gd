class_name PlayerCharacter
extends CharacterBody3D

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var input_handler: InputHandlerComponent = $InputHandlerComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var state_machine: StateMachine = $StateMachine

@export var _lateral_acceleration: float = 70
@export var _vertical_acceleration: float = 5
@export var _max_lateral_speed: float = 10
var _can_ground_jump: bool = true
var _can_double_jump: bool = true

@export_range(1, 100, 1) var _camera_speed: float = 30
const MAX_CAMERA_Y: float = PI / 2.0
const MIN_CAMERA_Y: float = PI / -2.0
var _use_inverted_camera: bool = true


func _ready():
	$MeshInstance3D.visible = false # Hide the player character model for 1st person view


func _physics_process(delta: float):
	_handle_camera(delta)
	state_machine.process_state(delta)


func _handle_movement(delta: float):
	var movement_vector = input_handler.get_movement_vector()
	
	if is_on_floor():
		_can_ground_jump = true
		_can_double_jump = true
	
	var should_jump = false
	if Input.is_action_just_pressed(InputActions.Player.JUMP):
		if _can_ground_jump:
			_can_ground_jump = false
			should_jump = true
		elif _can_double_jump:
			_can_double_jump = false
			should_jump = true
	
	movement_component.move_in_direction(delta, movement_vector, should_jump)


func _handle_camera(delta: float):
	input_handler.handle_camera_movement(delta)
