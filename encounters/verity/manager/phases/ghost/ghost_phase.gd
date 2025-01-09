class_name GhostPhase
extends EncounterPhase




func _enter_behavior() -> void:
	# TODO: Generate the set of 6 players statues?
	# TODO: Randomly pick the players to become ghosts and then "ghost" them
	pick_ghost_players()


func _exit_behavior() -> void:
	pass


# TODO: Trigger at start. Randomly pick players to be "ghost-ed"
func pick_ghost_players() -> void:
	pass


# TODO: Trigger when all players are successfully revived
func swap_to_key_building_phase() -> void:
	pass


# TODO: Trigger if all players die
func swap_to_wipe_phase() -> void:
	pass
