class_name VerityManager
extends EncounterManager

@onready var freeroam_phase: FreeroamPhase = %FreeroamPhase
@onready var key_building_phase: KeyBuildingPhase = %KeyBuildingPhase
@onready var ghost_phase: GhostPhase = %GhostPhase
@onready var wipe_phase: WipePhase = %WipePhase


var _current_phase: EncounterPhase
# Register modifiers
# Maintain list of modifiers
# - Each modifier may be a standalone Node that can enforce its own rules

# Needs mechanics, the core functions that the encounter is built upon
# - Mechanics need to be enabled or disabled, as well as started, stopped, or reset

func _ready() -> void:
	freeroam_phase.swap_to_phase.connect(_handle_phase_swap)
	key_building_phase.swap_to_phase.connect(_handle_phase_swap)
	ghost_phase.swap_to_phase.connect(_handle_phase_swap)
	wipe_phase.swap_to_phase.connect(_handle_phase_swap)
	
	_current_phase = freeroam_phase
	_current_phase.enter()


func _process(delta: float) -> void:
	_current_phase.process(delta)


func _handle_phase_swap(phase: EncounterPhase) -> void:
	_current_phase.exit()
	_current_phase = phase
	_current_phase.enter()


# FIXME: THIS MAY GET REMOVED / MOVED TO PHASES ----------------------------

## Loads up the physical play space and lets the player explore freely.
## This is the state the player is in while setting up their modifiers and such.
func load_freeroam() -> void:
	pass


## This will take any registered mechanics and modifiers, initialize settings,
## and start the encounter. Should also reset all encounter states and "spawn" the player
## at a given location if needed
func initialize() -> void:
	pass


## This will actually start the encounter by starting timers, kicking off mechanics, etc.
func start() -> void:
	pass

# FIXME: THIS MAY GET REMOVED / MOVED TO PHASES ----------------------------
