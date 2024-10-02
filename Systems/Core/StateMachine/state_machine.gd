class_name StateMachine
extends Node

@export var initial_state: State
var _current_state: State


func _ready():
	_current_state = initial_state


func process_state(delta: float):
	var new_state = _current_state.update(delta)
	if new_state != null and is_instance_valid(new_state):
		print("state transition to: ", new_state)
		transition_to(new_state, delta)


func transition_to(state: State, delta: float):
	_current_state.exit(delta)
	_current_state = state
	_current_state.enter(delta)


func get_current_state() -> State:
	return _current_state
