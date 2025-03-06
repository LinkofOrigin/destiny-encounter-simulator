class_name InputHandlerComponent
extends Node

signal interaction_progress(percent: float)
signal interaction_complete

const MAX_CAMERA_UP: float = PI / 2.0
const MIN_CAMERA_DOWN: float = PI / -2.0

@export_category("Input Dependencies")
@export var camera: Camera3D

@export_category("Input Options")
@export_range(1, 100, 1) var camera_speed: float = 30
@export var inverted_camera_y: bool = true

var _interaction_allowed: bool = true
var _current_interaction_time: float = 0.0
var _input_lock: bool = false
var _show_hints_on_input: bool = false


func _ready() -> void:
	GlobalSignals.player_allowed_interaction.connect(_on_player_allowed_interaction_changed)
	GlobalSignals.player_hint_display_on_input.connect(_on_player_hint_display_on_input)
	GlobalSignals.restricted_input_changed.connect(_on_restricted_input_changed)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func get_movement_vector() -> Vector2:
	if MenuManager.is_paused():
		return Vector2(0,0)
	return _get_raw_movement_vector().rotated(camera.rotation.y * -1)


func get_camera_movement_vector(delta: float) -> Vector2:
	if MenuManager.is_paused():
		return Vector2(0,0)
	var camera_vector := get_camera_vector()
	camera_vector *= camera_speed * delta / 10
	return camera_vector


func get_camera_vector() -> Vector2:
	# Note that this vector is a weird order because we map each joystick axis to a different axis in 3D space
	var joystick_camera_vector := Input.get_vector(
			InputActions.Camera.JOY_LEFT,
			InputActions.Camera.JOY_RIGHT,
			InputActions.Camera.JOY_UP,
			InputActions.Camera.JOY_DOWN,
			) * -1
	if inverted_camera_y:
		joystick_camera_vector.y *= -1
	
	return joystick_camera_vector


func handle_interaction(delta: float, time_to_complete: float) -> void:
	if MenuManager.is_paused() or not _interaction_allowed:
		_current_interaction_time = 0
		interaction_progress.emit(0)
		release_interact_lock()
		return
	
	var progress_percent := clampf(_current_interaction_time / time_to_complete, 0, 1) * 100 # Percentage
	if Input.is_action_pressed(InputActions.Player.INTERACT) and not _input_lock:
		_current_interaction_time += delta
		if _current_interaction_time >= time_to_complete:
			#print("player finished interacting!")
			_current_interaction_time = 0
			interaction_complete.emit()
			_input_lock = true # Prevent repeated interactions without first releasing the button
		else:
			interaction_progress.emit(progress_percent)
	elif Input.is_action_just_released(InputActions.Player.INTERACT):
		# reset the current interaction time
		_current_interaction_time = 0
		interaction_progress.emit(0)
		release_interact_lock()


func release_interact_lock() -> void:
	_input_lock = false
	_current_interaction_time = 0


func jump_button_just_pressed() -> bool:
	if MenuManager.is_paused():
		return false
	
	return Input.is_action_just_pressed(InputActions.Player.JUMP)


func get_mouse_motion_vector_from_event(event: InputEventMouseMotion) -> Vector2:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return Vector2(0,0)
	return Vector2(event.screen_relative.x, event.screen_relative.y) * -1 * 0.003


func _get_raw_movement_vector() -> Vector2:
	return Input.get_vector(InputActions.Player.MOVE_LEFT, InputActions.Player.MOVE_RIGHT, InputActions.Player.MOVE_FORWARD, InputActions.Player.MOVE_BACKWARD)


func _unhandled_input(event: InputEvent) -> void:
	if MenuManager.is_paused():
		return
	
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		# TODO: Should this be here? Probly not? Hack? (commented for now...)
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pass
	elif event is InputEventMouseButton and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if _show_hints_on_input:
		if event.is_action_pressed("SecondaryFire"):
			PlayerHudManager.show_hint_display()
		elif event.is_action_released("SecondaryFire"):
			PlayerHudManager.hide_hint_display()


func _on_player_allowed_interaction_changed(allowed: bool) -> void:
	_interaction_allowed = allowed


func _on_player_hint_display_on_input(display: bool) -> void:
	_show_hints_on_input = display


func _on_restricted_input_changed(restricted: bool) -> void:
	set_process(not restricted)
	set_process_input(not restricted)
	set_process_unhandled_input(not restricted)
	set_physics_process(not restricted)
