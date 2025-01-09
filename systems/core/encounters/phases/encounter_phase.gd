class_name EncounterPhase
extends Node

signal swap_to_phase(phase: EncounterPhase)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func enter() -> void:
	_enter_behavior()
	process_mode = Node.PROCESS_MODE_INHERIT


func exit() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	_exit_behavior()


func _emit_swap_to_phase(phase: EncounterPhase) -> void:
	swap_to_phase.emit(phase)


## To be overriden by child classes
func _enter_behavior() -> void:
	pass


## To be overriden by child classes
func _exit_behavior() -> void:
	pass


## To be overriden by child classes
func process(_delta: float) -> void:
	pass
