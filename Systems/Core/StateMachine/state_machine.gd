class_name StateMachine
extends Node


var _states: Array[State]
var _current_state: State


func _ready():
	# Add all child states to our state list
	for child_state in get_children():
		if child_state is State:
			_states.push_back(child_state)


func get_current_state() -> State:
	return _current_state


func transition_to(state: State):
	_current_state.transition_out()
	_current_state = state
	_current_state.transition_in()
