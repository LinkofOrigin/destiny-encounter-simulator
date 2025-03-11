class_name VerityManager
extends EncounterManager

# TODO: Move this higher up when more encounters exist
const DES_TUTORIAL = preload("res://systems/core/tutorials/des_tutorial/des_tutorial.tscn")

@export var team_dissection: TeamDissection
@export var left_solo_room: SoloKeyBuilding
@export var middle_solo_room: SoloKeyBuilding
@export var right_solo_room: SoloKeyBuilding
@onready var freeroam_phase: FreeroamPhase = %FreeroamPhase
@onready var key_building_phase: KeyBuildingPhase = %KeyBuildingPhase
@onready var ghost_phase: GhostPhase = %GhostPhase
@onready var wipe_phase: WipePhase = %WipePhase

var _current_phase: EncounterPhase


func _ready() -> void:
	_initial_setup()
	_handle_initial_tutorial()


func _process(delta: float) -> void:
	if is_instance_valid(_current_phase):
		_current_phase.process(delta)


func _set_initial_phase() -> void:
	_current_phase = freeroam_phase
	_current_phase.enter()


func _handle_phase_swap(phase: EncounterPhase) -> void:
	_current_phase.exit()
	_current_phase = phase
	_current_phase.enter()


func _on_encounter_starting() -> void:
	_is_running = true


func _on_encounter_resetting() -> void:
	_is_running = false # TODO: ??
	_handle_phase_swap(freeroam_phase)


func _handle_initial_tutorial() -> void:
	var tutorial := DES_TUTORIAL.instantiate()
	tutorial.finished.connect(_set_initial_phase)
	get_tree().root.add_child.call_deferred(tutorial)
	tutorial.start.call_deferred()


func _initial_setup() -> void:
	# Signals
	GlobalSignals.encounter_starting.connect(_on_encounter_starting)
	GlobalSignals.encounter_resetting.connect(_on_encounter_resetting)
	
	# Freefroam
	freeroam_phase.swap_to_phase.connect(_handle_phase_swap)
	
	# Key Building
	key_building_phase.swap_to_phase.connect(_handle_phase_swap)
	key_building_phase.team_dissection = team_dissection
	key_building_phase.left_solo_room = left_solo_room
	key_building_phase.middle_solo_room = middle_solo_room
	key_building_phase.right_solo_room = right_solo_room
	
	# Ghosts
	ghost_phase.swap_to_phase.connect(_handle_phase_swap)
	
	# Wipe
	wipe_phase.swap_to_phase.connect(_handle_phase_swap)
	var players: Array[PlayerCharacter]
	players.assign(self.get_tree().get_nodes_in_group("Player"))
	wipe_phase.set_players(players)
	wipe_phase.set_player_spawns(team_dissection.get_player_spawns())
