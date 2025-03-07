class_name TeamDissection
extends Node3D

signal statue_shapes_updated(left: EffectLibrary.SHAPE_3D_TYPES, middle: EffectLibrary.SHAPE_3D_TYPES, right: EffectLibrary.SHAPE_3D_TYPES)

const SHAPE_RESOLVER: ShapeResolver = preload("res://encounters/verity/shapes/3d_shapes/shape_resolver.tres")

# TODO: Refactor maybe? lol
@onready var shape_spawner: ShapeSpawner = %ShapeSpawner

@onready var player_one_spawn: Marker3D = %PlayerOneSpawn
@onready var player_two_spawn: Marker3D = %PlayerTwoSpawn
@onready var player_three_spawn: Marker3D = %PlayerThreeSpawn
@onready var player_four_spawn: Marker3D = %PlayerFourSpawn
@onready var player_five_spawn: Marker3D = %PlayerFiveSpawn
@onready var player_six_spawn: Marker3D = %PlayerSixSpawn

@onready var left_shape_spawn: Marker3D = %LeftShapeSpawn
@onready var center_shape_spawn: Marker3D = %CenterShapeSpawn
@onready var right_shape_spawn: Marker3D = %RightShapeSpawn

@onready var left_statue: Statue3D = %LeftStatue
@onready var middle_statue: Statue3D = %CenterStatue
@onready var right_statue: Statue3D = %RightStatue

@onready var player_one_statue: StatueGhost = %PlayerOneStatue
@onready var player_two_statue: StatueGhost = %PlayerTwoStatue
@onready var player_three_statue: StatueGhost = %PlayerThreeStatue
@onready var player_four_statue: StatueGhost = %PlayerFourStatue
@onready var player_five_statue: StatueGhost = %PlayerFiveStatue
@onready var player_six_statue: StatueGhost = %PlayerSixStatue

var _circle_used := false
var _triangle_used := false
var _square_used := false
var _first_primed_statue: Statue3D
var _second_primed_statue: Statue3D
var _left_key_shape: EffectLibrary.SHAPE_2D_TYPES
var _middle_key_shape: EffectLibrary.SHAPE_2D_TYPES
var _right_key_shape: EffectLibrary.SHAPE_2D_TYPES


func _ready() -> void:
	left_statue.received_effects.connect(_on_left_statue_received_effects)
	middle_statue.received_effects.connect(_on_center_statue_received_effects)
	right_statue.received_effects.connect(_on_right_statue_received_effects)
	GlobalSignals.encounter_resetting.connect(_on_encounter_restarted)


func initalize_fresh(use_random := false) -> void:
	spawn_shape_set()
	if use_random:
		set_random_solo_room_shapes()
		set_statues_with_random_shapes()


func get_player_spawns() -> Array[Marker3D]:
	return [
		player_one_spawn,
		player_two_spawn,
		player_three_spawn,
		player_four_spawn,
		player_five_spawn,
		player_six_spawn,
	]


func set_key_2d_shapes(left: EffectLibrary.SHAPE_2D_TYPES, middle: EffectLibrary.SHAPE_2D_TYPES, right: EffectLibrary.SHAPE_2D_TYPES) -> void:
	_left_key_shape = left
	_middle_key_shape = middle
	_right_key_shape = right


func set_statue_3d_shapes(left: EffectLibrary.SHAPE_3D_TYPES, middle: EffectLibrary.SHAPE_3D_TYPES, right: EffectLibrary.SHAPE_3D_TYPES) -> void:
	left_statue.create_and_hold_3d_shape(left)
	middle_statue.create_and_hold_3d_shape(middle)
	right_statue.create_and_hold_3d_shape(right)


func set_random_solo_room_shapes() -> void:
	var shapes_list := [
		EffectLibrary.SHAPE_2D_TYPES.CIRCLE,
		EffectLibrary.SHAPE_2D_TYPES.SQUARE,
		EffectLibrary.SHAPE_2D_TYPES.TRIANGLE,
	]
	shapes_list.shuffle()
	_left_key_shape = shapes_list[0]
	_middle_key_shape = shapes_list[1]
	_right_key_shape = shapes_list[2]
	print("Keys to match are: %s | %s | %s" % [_left_key_shape, _middle_key_shape, _right_key_shape])


func set_statues_with_random_shapes() -> void:
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
	
	if first_3d_shape >= 0 and second_3d_shape >= 0 and third_3d_shape >= 0:
		left_statue.create_and_hold_3d_shape(first_3d_shape)
		middle_statue.create_and_hold_3d_shape(second_3d_shape)
		right_statue.create_and_hold_3d_shape(third_3d_shape)
	else:
		printerr("shapes got fucked")


func check_statues_against_keys() -> void:
	var left_match := false
	var middle_match := false
	var right_match := false
	if not left_statue.current_shape_has(_left_key_shape):
		#print("Left statue matches key!")
		left_match = true
	
	if not right_statue.current_shape_has(_right_key_shape):
		#print("Right statue matches key!")
		middle_match = true
	
	if not middle_statue.current_shape_has(_middle_key_shape):
		#print("Middle statue matches key!")
		right_match = true
	
	if left_match and middle_match and right_match:
		print("All statues match! Dissection complete!")
		#dissection_complete.emit()


func spawn_shape_set() -> void:
	spawn_circle()
	spawn_triangle()
	spawn_square()


func resolve_shape_state() -> void:
	# If all 3 shapes are gone, spawn a new set
	if _circle_used and _triangle_used and _square_used:
		# TODO: Eventually this may be a "challenge"
		await get_tree().create_timer(5).timeout
		spawn_shape_set()


func spawn_circle() -> void:
	# Left
	var new_circle := shape_spawner.create_new_2d_shape(EffectLibrary.SHAPE_2D_TYPES.CIRCLE)
	left_shape_spawn.add_child(new_circle)
	new_circle.picked_up.connect(_register_circle_consumed)
	new_circle.despawned.connect(_register_circle_consumed)
	_circle_used = false


func spawn_triangle() -> void:
	# Middle
	var new_triangle := shape_spawner.create_new_2d_shape(EffectLibrary.SHAPE_2D_TYPES.TRIANGLE)
	center_shape_spawn.add_child(new_triangle)
	new_triangle.picked_up.connect(_register_triangle_consumed)
	new_triangle.despawned.connect(_register_triangle_consumed)
	_triangle_used = false


func spawn_square() -> void:
	# Right
	var new_square := shape_spawner.create_new_2d_shape(EffectLibrary.SHAPE_2D_TYPES.SQUARE)
	right_shape_spawn.add_child(new_square)
	new_square.picked_up.connect(_register_square_consumed)
	new_square.despawned.connect(_register_square_consumed)
	_square_used = false


func handle_primed_statue(statue: Statue3D) -> void:
	if not is_instance_valid(_first_primed_statue):
		_first_primed_statue = statue
	else:
		# Swap statue shapes
		_second_primed_statue = statue
		var first_primed_effect := _first_primed_statue.get_primed_shape()
		var second_primed_effect := _second_primed_statue.get_primed_shape()
		_first_primed_statue.alter_3d_shape(first_primed_effect, second_primed_effect)
		_second_primed_statue.alter_3d_shape(second_primed_effect, first_primed_effect)
		_first_primed_statue = null
		_second_primed_statue = null
		# TODO: Resolve if 3d shapes match key(s)
		statue_shapes_updated.emit(left_statue.current_held_shape.effect.shape, middle_statue.current_held_shape.effect.shape, right_statue.current_held_shape.effect.shape)
		#check_statues_against_keys()


func _register_circle_consumed() -> void:
	_circle_used = true
	resolve_shape_state()


func _register_triangle_consumed() -> void:
	_triangle_used = true
	resolve_shape_state()


func _register_square_consumed() -> void:
	_square_used = true
	resolve_shape_state()


func _on_left_statue_received_effects(_effects: Array[EffectData]) -> void:
	handle_primed_statue(left_statue)


func _on_center_statue_received_effects(_effects: Array[EffectData]) -> void:
	handle_primed_statue(middle_statue)


func _on_right_statue_received_effects(_effects: Array[EffectData]) -> void:
	handle_primed_statue(right_statue)


func _on_encounter_restarted() -> void:
	var left_shapes := left_shape_spawn.get_children()
	var center_shapes := center_shape_spawn.get_children()
	var right_shapes := right_shape_spawn.get_children()
	for left_shape: Node in left_shapes:
		left_shape.queue_free()
	for center_shape: Node in center_shapes:
		center_shape.queue_free()
	for right_shape: Node in right_shapes:
		right_shape.queue_free()
