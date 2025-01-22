class_name TeamDissection
extends Node3D

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
@onready var center_statue: Statue3D = %CenterStatue
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

func _ready() -> void:
	spawn_shape_set()
	
	left_statue.received_effects.connect(_on_left_statue_received_effects)
	center_statue.received_effects.connect(_on_center_statue_received_effects)
	right_statue.received_effects.connect(_on_right_statue_received_effects)


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


func _register_circle_consumed() -> void:
	_circle_used = true
	resolve_shape_state()


func _register_triangle_consumed() -> void:
	_triangle_used = true
	resolve_shape_state()


func _register_square_consumed() -> void:
	_square_used = true
	resolve_shape_state()


func _on_left_statue_received_effects(effects: Array[EffectData]) -> void:
	print("dissection room received effects in left statue!")


func _on_center_statue_received_effects(effects: Array[EffectData]) -> void:
	print("dissection room received effects in center statue!")


func _on_right_statue_received_effects(effects: Array[EffectData]) -> void:
	print("dissection room received effects in right statue!")
