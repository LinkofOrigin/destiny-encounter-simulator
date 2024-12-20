class_name DoubleJumpingState
extends State

@export_category("State Dependencies")
@export var grounded: GroundedState

@export_category("Functional Dependencies")
@export var input: InputHandlerComponent
@export var movement: MovementComponent


func enter(delta: float) -> void:
	var movement_vector := input.get_movement_vector()
	movement.move_in_direction(delta, movement_vector, true)


func exit(_delta: float) -> void:
	pass


@warning_ignore("untyped_declaration")
func update(delta: float):
	if movement.is_touching_floor():
		return grounded
	
	var movement_vector := input.get_movement_vector()
	movement.move_in_direction(delta, movement_vector, false)
