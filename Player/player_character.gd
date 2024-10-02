class_name PlayerCharacter
extends CharacterBody3D

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var _lateral_acceleration: float = 70
@export var _vertical_acceleration: float = 5
@export var _max_lateral_speed: float = 10
@export var _max_vertical_speed: float = 60
var _can_ground_jump: bool = true
var _can_double_jump: bool = true

@export_range(1, 200, 1) var _camera_speed: float = 65
const MAX_CAMERA_Y: float = PI / 2.0
const MIN_CAMERA_Y: float = PI / -2.0
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
	movement_vector = movement_vector.rotated($Camera3D.rotation.y * -1)
	
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
			velocity.y += _vertical_acceleration
		elif _can_double_jump:
			_can_double_jump = false
			velocity.y += _vertical_acceleration
	
	print("camera rotate: %s -- velocity: %s" % [$Camera3D.rotation.y, velocity])
	move_and_slide()


func _handle_camera(delta: float):
	var camera_vector = Input.get_vector(InputActions.Camera.JOY_UP, InputActions.Camera.JOY_DOWN, InputActions.Camera.JOY_RIGHT, InputActions.Camera.JOY_LEFT)
	if not _use_inverted_camera:
		camera_vector.x *= -1
	
	camera_vector *= _camera_speed / 1000
	camera_vector.x = clampf(camera_vector.x, MIN_CAMERA_Y, MAX_CAMERA_Y)
	
	var new_x_rotation = clampf($Camera3D.rotation.x + camera_vector.x, MIN_CAMERA_Y, MAX_CAMERA_Y)
	var new_y_rotation = fmod($Camera3D.rotation.y + camera_vector.y, 2*PI)
	
	var new_rotation = Vector3(new_x_rotation, new_y_rotation, $Camera3D.rotation.z)
	$Camera3D.rotation = new_rotation


func _unhandled_input(event: InputEvent):
	pass
