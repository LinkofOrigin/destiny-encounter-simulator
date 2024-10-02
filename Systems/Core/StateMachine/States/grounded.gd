class_name GroundedState
extends State

@export_category("State Dependencies")
@export var jumping: JumpingState

@export_category("Functional Dependencies")
@export var input: InputHandlerComponent
@export var movement: MovementComponent

func enter(delta: float):
	pass


func exit(delta: float):
	pass


func update(delta: float):
	if input.jump_button_just_pressed():
		return jumping
	
	var movement_vector = input.get_movement_vector()
	movement.move_in_direction(delta, movement_vector, false)
