class_name PlayerCharacter
extends CharacterBody3D

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var _lateral_acceleration: float = 70
@export var _vertical_acceleration: float = 5
@export var _max_lateral_speed: float = 10
@export var _max_vertical_speed: float = 60
var _can_ground_jump: bool = true
var _can_double_jump: bool = true

var _camera_speed: float = 2 * PI
var _use_inverted_camera: bool = true

func _ready():
	$MeshInstance3D.visible = false


func _physics_process(delta: float):
	_handle_movement(delta)
	_handle_camera(delta)


func _handle_movement(delta: float):
	# Apply gravity first
	velocity.y -= gravity * delta
	
	var movement_vector: Vector2 = Input.get_vector(InputActions.Player.MOVE_LEFT, InputActions.Player.MOVE_RIGHT, InputActions.Player.MOVE_FORWARD, InputActions.Player.MOVE_BACKWARD)
	
	if movement_vector != Vector2(0,0):
		# Accelerate
		velocity.x = move_toward(velocity.x, movement_vector.x * _max_lateral_speed, _lateral_acceleration * delta)
		velocity.z = move_toward(velocity.z, movement_vector.y * _max_lateral_speed, _lateral_acceleration * delta)
	else:
		# Decelerate
		velocity.x = move_toward(velocity.x, 0, _lateral_acceleration * delta)
		velocity.z = move_toward(velocity.z, 0, _lateral_acceleration * delta)
	
	var vertical_speed: float = delta * -1
	if is_on_floor():
		_can_ground_jump = true
		_can_double_jump = true
	
	if Input.is_action_just_pressed(InputActions.Player.JUMP):
		if _can_ground_jump:
			_can_ground_jump = false
			velocity.y = _vertical_acceleration
		elif _can_double_jump:
			_can_double_jump = false
			velocity.y += _vertical_acceleration
	
	move_and_slide()


func _handle_camera(delta: float):
	var camera_vector = Input.get_vector(InputActions.Camera.JOY_LEFT, InputActions.Camera.JOY_RIGHT, InputActions.Camera.JOY_UP, InputActions.Camera.JOY_DOWN)
	if _use_inverted_camera:
		camera_vector.y *= 1
	
	$Camera3D.rotate_y(camera_vector.x * _camera_speed)
	$Camera3D.rotate_x(camera_vector.y * _camera_speed)


func _unhandled_input(event: InputEvent):
	pass
