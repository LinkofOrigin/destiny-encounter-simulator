class_name InputHandlerComponent
extends Node

const MAX_CAMERA_UP: float = PI / 2.0
const MIN_CAMERA_DOWN: float = PI / -2.0

@export_category("Input Dependencies")
@export var camera: Camera3D

@export_category("Input Options")
@export_range(1, 100, 1) var camera_speed: float = 30
@export var inverted_camera_y: bool = true





func get_movement_vector() -> Vector2:
	return _get_raw_movement_vector().rotated(camera.rotation.y * -1)


func get_camera_vector() -> Vector2:
	var camera_vector = Input.get_vector(
			InputActions.Camera.JOY_UP,
			InputActions.Camera.JOY_DOWN,
			InputActions.Camera.JOY_RIGHT,
			InputActions.Camera.JOY_LEFT)
	if not inverted_camera_y:
		camera_vector.x *= -1
	return camera_vector


func handle_camera_movement(delta: float):
	# Note that this vector is a weird order because we map each joystick axis to a different axis in 3D space
	var camera_vector = get_camera_vector()
	camera_vector *= camera_speed * delta / 10
	
	var new_x_rotation = clampf(camera.rotation.x + camera_vector.x, MIN_CAMERA_DOWN, MAX_CAMERA_UP)
	var new_y_rotation = fmod(camera.rotation.y + camera_vector.y, 2 * PI)
	
	var new_rotation = Vector3(new_x_rotation, new_y_rotation, camera.rotation.z)
	camera.rotation = new_rotation


func jump_button_just_pressed() -> bool:
	return Input.is_action_just_pressed(InputActions.Player.JUMP)

func _get_raw_movement_vector() -> Vector2:
	return Input.get_vector(InputActions.Player.MOVE_LEFT, InputActions.Player.MOVE_RIGHT, InputActions.Player.MOVE_FORWARD, InputActions.Player.MOVE_BACKWARD)
