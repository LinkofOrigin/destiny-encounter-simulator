class_name GroundedState
extends State

@export_category("State Dependencies")
@export var jumping: JumpingState

@export_category("Functional Dependencies")
@export var input: InputHandlerComponent
@export var movement: MovementComponent


func enter(_delta: float) -> void:
	pass


func exit(_delta: float) -> void:
	pass


@warning_ignore("untyped_declaration")
func update(delta: float):
	if input.jump_button_just_pressed() or not movement.is_touching_floor():
		return jumping
	
	var movement_vector := input.get_movement_vector()
	movement.move_in_direction(delta, movement_vector, false)
