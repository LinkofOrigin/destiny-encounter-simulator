class_name EncounterMechanic
extends Node

signal complete 	## The mechanic is in a "done" state, but could be undone
signal incomplete	## The mechanic is not in a "done" state, but could still be completed
signal successful	## The mechanic is fully done and has nothing more to evaluate
signal failed		## The mechanic is fully failed and a fail state should be triggered (eg. a "wipe")

var modifiers: Array

var enabled: bool = true
var _complete: bool = false:
	get = is_complete
var _done: bool = false:
	get = is_done


func initialize_and_start() -> void:
	pass


func pause() -> void:
	pass


func resume() -> void:
	pass


func enable() -> void:
	enabled = true


func disable() -> void:
	enabled = false


func is_complete() -> bool:
	return _complete


func is_done() -> bool:
	return _done


func _emit_complete() -> void:
	_complete = true
	complete.emit()


func _emit_incomplete() -> void:
	_complete = false
	incomplete.emit()


func _emit_successful() -> void:
	_done = true
	successful.emit()


func _emit_failed() -> void:
	_done = false
	failed.emit()
