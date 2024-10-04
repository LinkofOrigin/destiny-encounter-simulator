class_name PlayerCharacter
extends CharacterBody3D

@onready var input_handler: InputHandlerComponent = $InputHandlerComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var state_machine: StateMachine = $StateMachine


func _ready():
	$MeshInstance3D.visible = false # Hide the player character model for 1st person view


func _physics_process(delta: float):
	_handle_camera(delta)
	state_machine.process_state(delta)


func _handle_camera(delta: float):
	input_handler.handle_camera_movement(delta)
