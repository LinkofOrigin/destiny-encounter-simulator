class_name WipePhase
extends EncounterPhase



func _enter_behavior() -> void:
	# TODO: Fade to black and reset, swap to freeroam
	swap_to_freeroam()


func _exit_behavior() -> void:
	pass


func swap_to_freeroam() -> void:
	#swap_to_phase.emit()
	pass
