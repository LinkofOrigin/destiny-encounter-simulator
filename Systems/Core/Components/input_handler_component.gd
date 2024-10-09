class_name InputHandlerComponent
extends Node

signal interaction_complete

const MAX_CAMERA_UP: float = PI / 2.0
const MIN_CAMERA_DOWN: float = PI / -2.0

@export_category("Input Dependencies")
@export var camera: Camera3D

@export_category("Input Options")
@export_range(1, 100, 1) var camera_speed: float = 30
@export var inverted_camera_y: bool = true

var _current_interaction_time: float = 0.0
var _input_lock: bool = false


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	


func get_movement_vector() -> Vector2:
	return _get_raw_movement_vector().rotated(camera.rotation.y * -1)


func get_camera_movement_vector(delta: float) -> Vector2:
	var camera_vector = get_camera_vector()
	camera_vector *= camera_speed * delta / 10
	return camera_vector


func get_camera_vector() -> Vector2:
	# Note that this vector is a weird order because we map each joystick axis to a different axis in 3D space
	var joystick_camera_vector = Input.get_vector(
			InputActions.Camera.JOY_LEFT,
			InputActions.Camera.JOY_RIGHT,
			InputActions.Camera.JOY_UP,
			InputActions.Camera.JOY_DOWN,
			) * -1
	if inverted_camera_y:
		joystick_camera_vector.y *= -1
	
	return joystick_camera_vector


func handle_interaction(delta: float, time_to_complete: float) -> float:
	if Input.is_action_pressed(InputActions.Player.INTERACT) and not _input_lock:
		_current_interaction_time += delta
		if _current_interaction_time >= time_to_complete:
			print("player finished interacting!")
			interaction_complete.emit()
			_input_lock = true # Prevent repeated interactions without first releasing the button
	elif Input.is_action_just_released(InputActions.Player.INTERACT):
		# reset the current interaction time
		_current_interaction_time = 0
		_input_lock = false
	
	return clampf(_current_interaction_time / time_to_complete, 0, 1) * 100 # Percentage


func jump_button_just_pressed() -> bool:
	return Input.is_action_just_pressed(InputActions.Player.JUMP)


func get_mouse_motion_vector_from_event(event: InputEventMouseMotion) -> Vector2:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return Vector2(0,0)
	return Vector2(event.screen_relative.x, event.screen_relative.y) * -1 * 0.003


func _get_raw_movement_vector() -> Vector2:
	return Input.get_vector(InputActions.Player.MOVE_LEFT, InputActions.Player.MOVE_RIGHT, InputActions.Player.MOVE_FORWARD, InputActions.Player.MOVE_BACKWARD)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("Menu"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
