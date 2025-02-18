class_name VerityManager
extends EncounterManager

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
	
	_current_phase = freeroam_phase
	_current_phase.enter()


func _process(delta: float) -> void:
	_current_phase.process(delta)


func _handle_phase_swap(phase: EncounterPhase) -> void:
	_current_phase.exit()
	_current_phase = phase
	_current_phase.enter()


func _on_encounter_starting() -> void:
	_is_running = true


func _on_encounter_resetting() -> void:
	_is_running = true
	_handle_phase_swap(freeroam_phase)


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
