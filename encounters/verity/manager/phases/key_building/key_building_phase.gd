class_name KeyBuildingPhase
extends EncounterPhase

var team_dissection: TeamDissection
var left_solo_room: SoloKeyBuilding
var middle_solo_room: SoloKeyBuilding
var right_solo_room: SoloKeyBuilding

## Entered by a player interacting with a statue in the dissection room while in Freeroam
## (TODO: manually for now... may change)
func _enter_behavior() -> void:
	# TODO: Randomly select solo players
	# TODO: Randomly assign starting statue states (2d and 3d)
	# TODO: teleport players
	print("entering key building phase")
	GlobalSignals.emit_encounter_starting()
	teleport_players_to_solo_rooms()
	team_dissection.initalize_fresh()


func _exit_behavior() -> void:
	# TODO: Remove timer? At least stop and hide
	pass


# TODO: Trigger at start. Pick random players and send to solo room
func teleport_players_to_solo_rooms() -> void:
	pass


# TODO: Trigger when 3d statue shapes are swapped
func handle_dissection_statue_change() -> void:
	pass


# TODO: Evaluate when a solo player picks up a new shape and is holding 2 shapes,
# 		Determine if the "wall" should have collision disabled
func check_if_solo_player_can_escape() -> void:
	pass


# TODO: Trigger when the phase timer expires, should trigger wipe phase
func _on_phase_timer_timeout() -> void:
	pass


# TODO: Trigger when all solo players successfully escape
func swap_to_ghost_phase() -> void:
	pass


# TODO: Trigger when no solo rooms have players or too few revives, etc.
func swap_to_wipe_phase() -> void:
	pass
