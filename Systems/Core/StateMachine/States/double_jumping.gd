class_name DoubleJumpingState
extends State

@export_category("State Dependencies")
@export var grounded: GroundedState

@export_category("Functional Dependencies")
@export var input: InputHandlerComponent
@export var movement: MovementComponent


func enter(delta: float):
	var movement_vector = input.get_movement_vector()
	movement.move_in_direction(delta, movement_vector, true)


func exit(delta: float):
	pass


func update(delta: float):
	if movement.just_touched_floor():
		return grounded
	
	var movement_vector = input.get_movement_vector()
	movement.move_in_direction(delta, movement_vector, false)
