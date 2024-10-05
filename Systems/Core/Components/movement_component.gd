class_name MovementComponent
extends Node

@export_category("Movement Options")
@export var lateral_acceleration: float = 70
@export var max_lateral_velocity: float = 10
@export var vertical_acceleration: float = 5
@export var max_vertical_velocity: float = 60

@onready var parent: Node3D = get_parent()
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	pass


func move_in_direction(delta: float, direction: Vector2, with_jump: bool = false):
	var new_velocity = parent.velocity
	new_velocity.y -= gravity * delta
	direction = direction.rotated(parent.rotation.y * -1)
	
	if direction != Vector2(0,0):
		# Accelerate
		new_velocity.x = move_toward(new_velocity.x, direction.x * max_lateral_velocity, lateral_acceleration * delta)
		new_velocity.z = move_toward(new_velocity.z, direction.y * max_lateral_velocity, lateral_acceleration * delta)
	else:
		# Decelerate
		new_velocity.x = move_toward(new_velocity.x, 0, lateral_acceleration * delta)
		new_velocity.z = move_toward(new_velocity.z, 0, lateral_acceleration * delta)
	
	if with_jump:
		new_velocity.y = vertical_acceleration
	
	parent.velocity = new_velocity
	
	parent.move_and_slide()


func is_touching_floor():
	return parent.is_on_floor()
