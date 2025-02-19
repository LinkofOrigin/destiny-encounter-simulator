class_name WipePhase
extends EncounterPhase

const TIME_BEFORE_WIPE := 7
const FADE_HOLD_TIME := 4

@export var freeroam_phase: FreeroamPhase

@onready var fade_and_spawn: FadeAndSpawn = $FadeAndSpawn


func _enter_behavior() -> void:
	print("entering wipe phase")
	GlobalSignals.emit_player_interaction_allowed(false)
	fade_and_spawn.fade_screen_out()


func _exit_behavior() -> void:
	GlobalSignals.emit_player_interaction_allowed(true)


func set_players(players: Array[PlayerCharacter]) -> void:
	fade_and_spawn.players = players


func set_player_spawns(player_spawns: Array[Marker3D]) -> void:
	fade_and_spawn.player_spawns = player_spawns


func swap_to_freeroam() -> void:
	GlobalSignals.emit_encounter_resetting()
	_emit_swap_to_phase(freeroam_phase)


func _on_players_moved() -> void:
	fade_and_spawn.fade_screen_in()


func _on_screen_fade_out_finished() -> void:
	fade_and_spawn.move_players_to_spawns()


func _on_screen_fade_in_finished() -> void:
	swap_to_freeroam()


func _connect_signals() -> void:
	fade_and_spawn.players_moved.connect(_on_players_moved)
	fade_and_spawn.screen_fade_out_finished.connect(_on_screen_fade_out_finished)
	fade_and_spawn.screen_fade_in_finished.connect(_on_screen_fade_in_finished)
