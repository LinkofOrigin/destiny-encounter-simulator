class_name EncounterPhase
extends Node

signal swap_to_phase(phase: EncounterPhase)

var mechanics: Array[EncounterMechanic]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	_connect_signals()


func enter() -> void:
	_enter_behavior()
	process_mode = Node.PROCESS_MODE_INHERIT


func exit() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	_exit_behavior()


## To be overriden by child classes
func process(_delta: float) -> void:
	pass


## To be overriden by child classes
func _enter_behavior() -> void:
	pass


## To be overriden by child classes
func _exit_behavior() -> void:
	pass


## To be overriden by child classes
func _connect_signals() -> void:
	pass


func _emit_swap_to_phase(phase: EncounterPhase) -> void:
	swap_to_phase.emit(phase)
