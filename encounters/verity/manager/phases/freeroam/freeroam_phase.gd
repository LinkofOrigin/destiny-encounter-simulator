class_name FreeroamPhase
extends EncounterPhase

const TIME_TO_START_ENCOUNTER := 3.2 # FIXME: probly should be elsewhere

@export var key_building_phase: KeyBuildingPhase

var curr_time_pass: float


func _enter_behavior() -> void:
	# TODO: Enable teleporting between rooms?
	print("entering freeroam")
	curr_time_pass = 0


func _exit_behavior() -> void:
	# TODO: Display black screen, let key building resolve and remove screen?
	# TODO: Remove teleporters?
	pass


func process(delta: float) -> void:
	if MenuManager.is_paused():
		GlobalSignals.emit_encounter_start_progress(0)
		return
	
	if Input.is_action_pressed("AltMenu"):
		curr_time_pass += delta
	else:
		curr_time_pass = 0
	# TODO: Make this a mechanic node?
	GlobalSignals.emit_encounter_start_progress(curr_time_pass / TIME_TO_START_ENCOUNTER)
	
	if curr_time_pass >= TIME_TO_START_ENCOUNTER:
		swap_to_key_building()


# TODO: Would trigger off a menu option
func reload_with_settings() -> void:
	# TODO: Spawn players at locations in dissection room
	pass


# TODO: May also trigger off of a statue interaction in the dissection level
func swap_to_key_building() -> void:
	_emit_swap_to_phase(key_building_phase)
