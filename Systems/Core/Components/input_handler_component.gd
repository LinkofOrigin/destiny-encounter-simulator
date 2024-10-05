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
var _time_to_complete_interaction: float = 1.0


func get_movement_vector() -> Vector2:
	return _get_raw_movement_vector().rotated(camera.rotation.y * -1)


func get_camera_movement_vector(delta: float) -> Vector2:
	var camera_vector = get_camera_vector()
	camera_vector *= camera_speed * delta / 10
	return camera_vector


func get_camera_vector() -> Vector2:
	# Note that this vector is a weird order because we map each joystick axis to a different axis in 3D space
	var camera_vector = Input.get_vector(
			InputActions.Camera.JOY_LEFT,
			InputActions.Camera.JOY_RIGHT,
			InputActions.Camera.JOY_UP,
			InputActions.Camera.JOY_DOWN,
			)
	if not inverted_camera_y:
		camera_vector.y *= -1
	return camera_vector


func handle_interaction(delta: float):
	if Input.is_action_pressed(InputActions.Player.INTERACT):
		_current_interaction_time += delta
		if _current_interaction_time >= _time_to_complete_interaction:
			print("player finished interacting!")
			interaction_complete.emit()
	elif _current_interaction_time > 0:
		# reset the current interaction time
		_current_interaction_time = 0


func jump_button_just_pressed() -> bool:
	return Input.is_action_just_pressed(InputActions.Player.JUMP)


func _get_raw_movement_vector() -> Vector2:
	return Input.get_vector(InputActions.Player.MOVE_LEFT, InputActions.Player.MOVE_RIGHT, InputActions.Player.MOVE_FORWARD, InputActions.Player.MOVE_BACKWARD)
