class_name KeyBuildingPhase
extends EncounterPhase

signal key_shapes_set(left: EffectLibrary.SHAPE_2D_TYPES, middle: EffectLibrary.SHAPE_2D_TYPES, right: EffectLibrary.SHAPE_2D_TYPES)
signal left_statue_matches_key(matches: bool)
signal middle_statue_matches_key(matches: bool)
signal right_statue_matches_key(matches: bool)
signal statue_shapes_updated(left: EffectLibrary.SHAPE_3D_TYPES, middle: EffectLibrary.SHAPE_3D_TYPES, right: EffectLibrary.SHAPE_3D_TYPES)
signal dissection_complete

const DISSECTION_STATE = preload("res://ui/player_hud/location_display/location_state/dissection/dissection_state.tscn")
const SHAPE_RESOLVER: ShapeResolver = preload("res://encounters/verity/shapes/3d_shapes/shape_resolver.tres")

@export var ghost_phase: GhostPhase
@export var wipe_phase: WipePhase

@onready var dissecting_keys_mechanic: DissectingKeysMechanic = $DissectingKeysMechanic
var team_dissection: TeamDissection:
	set = set_team_dissection
var left_solo_room: SoloKeyBuilding
var middle_solo_room: SoloKeyBuilding
var right_solo_room: SoloKeyBuilding

var _left_key: EffectLibrary.SHAPE_2D_TYPES
var _middle_key: EffectLibrary.SHAPE_2D_TYPES
var _right_key: EffectLibrary.SHAPE_2D_TYPES
var _dissection_matches_keys: bool = false


## Entered by a player interacting with a statue in the dissection room while in Freeroam
## (TODO: manually via menu for now... will eventually change to match actual encounter, menu shortcut is nice tho)
func _enter_behavior() -> void:
	print("entering key building phase")
	GlobalSignals.emit_encounter_starting()
	
	# Will spawn 2D shapes on floor
	team_dissection.initalize_fresh()
	dissecting_keys_mechanic.initialize_and_start()


func _exit_behavior() -> void:
	# TODO: Remove timer? At least stop and hide
	pass


func _on_dissecting_complete() -> void:
	print("dissection is in a complete state!")


func _on_dissecting_incomplete() -> void:
	print("dissection is NOT complete!")


# TODO: Trigger when all solo players successfully escape
func swap_to_ghost_phase() -> void:
	_emit_swap_to_phase(wipe_phase)


# TODO: Trigger when no solo rooms have players or too few revives, etc.
func swap_to_wipe_phase() -> void:
	pass


func set_team_dissection(dissection: TeamDissection) -> void:
	team_dissection = dissection
	dissecting_keys_mechanic.set_team_dissection(team_dissection)


func _connect_signals() -> void:
	dissecting_keys_mechanic.complete.connect(_on_dissecting_complete)
	dissecting_keys_mechanic.incomplete.connect(_on_dissecting_incomplete)
	dissecting_keys_mechanic.failed.connect(swap_to_wipe_phase)
