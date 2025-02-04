class_name KeyBuildingPhase
extends EncounterPhase

signal key_shapes_set(left: EffectLibrary.SHAPE_2D_TYPES, middle: EffectLibrary.SHAPE_2D_TYPES, right: EffectLibrary.SHAPE_2D_TYPES)
signal left_statue_matches_key(matches: bool)
signal middle_statue_matches_key(matches: bool)
signal right_statue_matches_key(matches: bool)
signal statue_shapes_updated(left: EffectLibrary.SHAPE_3D_TYPES, middle: EffectLibrary.SHAPE_3D_TYPES, right: EffectLibrary.SHAPE_3D_TYPES)
signal dissection_complete

const DISSECTION_STATE = preload("res://ui/player_hud/location_display/location_state/dissection/dissection_state.tscn")

@export var ghost_phase: GhostPhase
@export var wipe_phase: WipePhase

const SHAPE_RESOLVER: ShapeResolver = preload("res://encounters/verity/shapes/3d_shapes/shape_resolver.tres")

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
## (TODO: manually for now... may change)
func _enter_behavior() -> void:
	print("entering key building phase")
	GlobalSignals.emit_encounter_starting()
	
	# Will spawn 2D shapes on floor
	team_dissection.initalize_fresh()
	# TODO: Fix this reference to decouple
	var fresh_dissection_display: DissectionState = DISSECTION_STATE.instantiate()
	PlayerHudManager.load_location_state_display(fresh_dissection_display)
	
	# TODO: Randomly assign starting statue states (2d and 3d)
	initialize_shapes()
	
	# TODO: Randomly select solo players
	#teleport_players_to_solo_rooms()


func _exit_behavior() -> void:
	# TODO: Remove timer? At least stop and hide
	pass


func initialize_shapes() -> void:
	# Take list of 3d shape compositions and shuffle
	var statue_shapes := _create_random_statue_shapes()
	if statue_shapes[0] >= 0 and statue_shapes[1] >= 0 and statue_shapes[2] >= 0:
		# Set those for 3d statue shapes
		team_dissection.set_statue_3d_shapes(statue_shapes[0], statue_shapes[1], statue_shapes[2])
		statue_shapes_updated.emit(statue_shapes[0], statue_shapes[1], statue_shapes[2])
	else:
		printerr("shapes got fucked")
		return
	
	# Get random index for a key shape to be matching
	var keys_to_shuffle := [EffectLibrary.SHAPE_2D_TYPES.CIRCLE, EffectLibrary.SHAPE_2D_TYPES.SQUARE, EffectLibrary.SHAPE_2D_TYPES.TRIANGLE]
	var random_matching_key_index := randi_range(0, 2)
	var random_matching_shape_index := randi_range(0,1)
	var random_statue_shape: EffectLibrary.SHAPE_3D_TYPES = statue_shapes[random_matching_key_index]
	var comprising_shapes := SHAPE_RESOLVER.determine_2d_shapes(random_statue_shape)
	var random_key_shape: EffectLibrary.SHAPE_2D_TYPES = comprising_shapes[random_matching_shape_index]
	# - TODO: bonus: do again for a second key shape to match
	keys_to_shuffle.erase(random_key_shape)
	keys_to_shuffle.shuffle()
	# Take a 2d shape from that respective 3d shape and set as key shape
	# - TODO: bonus: do the same for second key shape
	# Shuffle remaining key shapes and set them
	if random_matching_key_index == 0:
		_left_key = random_key_shape
		_middle_key = keys_to_shuffle.pop_front()
		_right_key = keys_to_shuffle.pop_front()
	elif random_matching_key_index == 1:
		_middle_key = random_key_shape
		_left_key = keys_to_shuffle.pop_front()
		_right_key = keys_to_shuffle.pop_front()
	else:
		_right_key = random_key_shape
		_left_key = keys_to_shuffle.pop_front()
		_right_key = keys_to_shuffle.pop_front()
	
	team_dissection.set_key_2d_shapes(_left_key, _middle_key, _right_key)
	GlobalSignals.emit_encounter_state_updated({
		"keys": [_left_key, _middle_key, _right_key],
		"statue_shapes": [statue_shapes[0], statue_shapes[1], statue_shapes[2]]
	})


# TODO: Trigger at start. Pick random players and send to solo room
func teleport_players_to_solo_rooms() -> void:
	pass


# TODO: Trigger when 3d statue shapes are swapped
func handle_dissection_statue_change(left: EffectLibrary.SHAPE_3D_TYPES, middle: EffectLibrary.SHAPE_3D_TYPES, right: EffectLibrary.SHAPE_3D_TYPES) -> void:
	var left_match := false
	var middle_match := false
	var right_match := false
	
	var left_shapes := SHAPE_RESOLVER.determine_2d_shapes(left)
	if not left_shapes.has(_left_key):
		#print("Left statue matches key!")
		left_match = true
	left_statue_matches_key.emit(left_match)
	
	var middle_shapes := SHAPE_RESOLVER.determine_2d_shapes(middle)
	if not middle_shapes.has(_middle_key):
		#print("Middle statue matches key!")
		middle_match = true
	middle_statue_matches_key.emit(middle_match)
	
	var right_shapes := SHAPE_RESOLVER.determine_2d_shapes(right)
	if not right_shapes.has(_right_key):
		#print("Right statue matches key!")
		right_match = true
	right_statue_matches_key.emit(right_match)
	
	statue_shapes_updated.emit(left, middle, right)
	
	if left_match and middle_match and right_match:
		print("All statues match! Dissection complete!")
		_dissection_matches_keys = true
		dissection_complete.emit()
	else:
		_dissection_matches_keys = false
	
	GlobalSignals.emit_encounter_state_updated({
		"statue_shapes": [left, middle, right],
		"key_matches": [left_match, middle_match, right_match],
	})


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


func _create_random_statue_shapes() -> Array[EffectLibrary.SHAPE_3D_TYPES]:
	var shapes_list := [
		EffectLibrary.SHAPE_2D_TYPES.CIRCLE,
		EffectLibrary.SHAPE_2D_TYPES.CIRCLE,
		EffectLibrary.SHAPE_2D_TYPES.SQUARE,
		EffectLibrary.SHAPE_2D_TYPES.SQUARE,
		EffectLibrary.SHAPE_2D_TYPES.TRIANGLE,
		EffectLibrary.SHAPE_2D_TYPES.TRIANGLE,
	]
	# TODO: Need to ensure that 3d shapes can't spawn already matching key
	shapes_list.shuffle()
	var first_3d_shape := SHAPE_RESOLVER.determine_3d_shape(shapes_list[0], shapes_list[1])
	var second_3d_shape := SHAPE_RESOLVER.determine_3d_shape(shapes_list[2], shapes_list[3])
	var third_3d_shape := SHAPE_RESOLVER.determine_3d_shape(shapes_list[4], shapes_list[5])
	print("Shapes for Dissection: %s | %s | %s" % [first_3d_shape, second_3d_shape, third_3d_shape])
	return [first_3d_shape, second_3d_shape, third_3d_shape]


func _on_statue_shapes_updated(left: EffectLibrary.SHAPE_3D_TYPES, middle: EffectLibrary.SHAPE_3D_TYPES, right: EffectLibrary.SHAPE_3D_TYPES) -> void:
	handle_dissection_statue_change(left, middle, right)


func set_team_dissection(dissection: TeamDissection) -> void:
	team_dissection = dissection
	if not team_dissection.statue_shapes_updated.is_connected(_on_statue_shapes_updated):
		team_dissection.statue_shapes_updated.connect(_on_statue_shapes_updated)
