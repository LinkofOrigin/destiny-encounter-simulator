class_name DissectingKeysMechanic
extends EncounterMechanic

signal key_shapes_set(left: EffectLibrary.SHAPE_2D_TYPES, middle: EffectLibrary.SHAPE_2D_TYPES, right: EffectLibrary.SHAPE_2D_TYPES)
signal shapes_matches_updated(left_match: bool, middle_match: bool, right_match: bool)
signal statue_shapes_updated(left: EffectLibrary.SHAPE_3D_TYPES, middle: EffectLibrary.SHAPE_3D_TYPES, right: EffectLibrary.SHAPE_3D_TYPES)

const DISSECTION_OPTIONS = preload("res://encounters/verity/mechanics/dissecting_keys/dissection_options/dissection_options.tscn")
const DISSECTION_STATE = preload("res://ui/player_hud/location_display/location_state/dissection/dissection_state.tscn")
const SHAPE_RESOLVER: ShapeResolver = preload("res://encounters/verity/shapes/3d_shapes/shape_resolver.tres")

@onready var timer: Timer = %Timer
@onready var timer_duration: float = timer.wait_time
var left_key: EffectLibrary.SHAPE_2D_TYPES
var middle_key: EffectLibrary.SHAPE_2D_TYPES
var right_key: EffectLibrary.SHAPE_2D_TYPES

var team_dissection: TeamDissection:
	set = set_team_dissection


func _ready() -> void:
	GlobalSignals.encounter_resetting.connect(_on_encounter_resetting)
	timer.timeout.connect(_on_timer_timeout)
	register_menu_option()


func initialize_and_start() -> void:
	assert(is_instance_valid(team_dissection), "Dissecting keys mechanic didn't get a valid dissection instance!")

	# TODO: Determine starting players
	# TODO: Register hud state for dissection players only
	var fresh_dissection_display: DissectionState = DISSECTION_STATE.instantiate()
	fresh_dissection_display.set_dissecting_keys_mechanic(self)
	PlayerHudManager.load_location_state_display(fresh_dissection_display)
	
	initialize_shapes()
	
	if timer_enabled():
		PlayerHudManager.set_timer_for_display(timer)
		PlayerHudManager.show_timer()
		timer.start(timer_duration)
	else:
		PlayerHudManager.hide_timer()


func register_menu_option() -> void:
	# TODO: Instantiate and connect signals? Change return signature
	var dissection_options: DissectionOptions = DISSECTION_OPTIONS.instantiate()
	dissection_options.timer_value_changed.connect(_on_timer_value_changed)
	MenuManager.register_menu_option(dissection_options)


func set_timer_duration(duration: float) -> void:
	timer_duration = duration


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
		left_key = random_key_shape
		middle_key = keys_to_shuffle.pop_front()
		right_key = keys_to_shuffle.pop_front()
	elif random_matching_key_index == 1:
		middle_key = random_key_shape
		left_key = keys_to_shuffle.pop_front()
		right_key = keys_to_shuffle.pop_front()
	else:
		right_key = random_key_shape
		left_key = keys_to_shuffle.pop_front()
		middle_key = keys_to_shuffle.pop_front()
	
	if left_key == middle_key or middle_key == right_key or left_key == right_key:
		assert(false, "matching keys!!!")
	
	team_dissection.set_key_2d_shapes(left_key, middle_key, right_key)
	
	key_shapes_set.emit(left_key, middle_key, right_key)


# TODO: Trigger at start. Pick random players and send to solo room?
# - May leave to another mechanic node, eg. FadeAndSpawn or another type
func teleport_players_to_solo_rooms() -> void:
	pass


func set_team_dissection(new_team_dissection: TeamDissection) -> void:
	team_dissection = new_team_dissection
	team_dissection.statue_shapes_updated.connect(_on_dissection_statues_updated)


func handle_dissection_statue_change(left: EffectLibrary.SHAPE_3D_TYPES, middle: EffectLibrary.SHAPE_3D_TYPES, right: EffectLibrary.SHAPE_3D_TYPES) -> void:
	var left_match := false
	var middle_match := false
	var right_match := false
	
	var left_shapes := SHAPE_RESOLVER.determine_2d_shapes(left)
	if not left_shapes.has(left_key):
		#print("Left statue matches key!")
		left_match = true
	
	var middle_shapes := SHAPE_RESOLVER.determine_2d_shapes(middle)
	if not middle_shapes.has(middle_key):
		#print("Middle statue matches key!")
		middle_match = true
	
	var right_shapes := SHAPE_RESOLVER.determine_2d_shapes(right)
	if not right_shapes.has(right_key):
		#print("Right statue matches key!")
		right_match = true
	
	statue_shapes_updated.emit(left, middle, right)
	shapes_matches_updated.emit(left_match, middle_match, right_match)
	
	if left_match and middle_match and right_match:
		print("All statues match! Dissection complete!")
		_complete = true
		_emit_complete()
	else:
		_complete = false
		_emit_incomplete()


func timer_enabled() -> bool:
	return timer.wait_time > 0


# TODO: Trigger when the phase timer expires, should trigger wipe phase
func _on_timer_timeout() -> void:
	print("Dissection timer expired!")
	_emit_failed()


func _on_dissection_statues_updated(left_statue_shape: EffectLibrary.SHAPE_3D_TYPES, middle_statue_shape: EffectLibrary.SHAPE_3D_TYPES, right_statue_shape: EffectLibrary.SHAPE_3D_TYPES) -> void:
	handle_dissection_statue_change(left_statue_shape, middle_statue_shape, right_statue_shape)


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
	#print("Shapes for Dissection: %s | %s | %s" % [first_3d_shape, second_3d_shape, third_3d_shape])
	return [first_3d_shape, second_3d_shape, third_3d_shape]


func _on_timer_value_changed(new_time: float) -> void:
	set_timer_duration(new_time)


func _on_encounter_resetting() -> void:
	timer.stop()
