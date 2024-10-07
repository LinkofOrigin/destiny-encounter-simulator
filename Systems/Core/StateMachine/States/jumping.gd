class_name JumpingState
extends State

@export_category("State Dependencies")
@export var grounded: GroundedState
@export var double_jump: DoubleJumpingState

@export_category("Functional Dependencies")
@export var input: InputHandlerComponent
@export var movement: MovementComponent


func enter(delta: float):
	var movement_vector := input.get_movement_vector()
	var should_jump := false
	if input.jump_button_just_pressed():
		should_jump = true
	
	movement.move_in_direction(delta, movement_vector, should_jump)


func exit(_delta: float):
	pass


func update(delta: float):
	if input.jump_button_just_pressed():
		return double_jump
	elif movement.is_touching_floor():
		return grounded
	
	var movement_vector := input.get_movement_vector()
	movement.move_in_direction(delta, movement_vector, false)
