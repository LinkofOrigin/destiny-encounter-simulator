class_name TeamDissection
extends Node3D

# TODO: Refactor maybe? lol
@onready var player_one_spawn: Marker3D = %PlayerOneSpawn
@onready var player_two_spawn: Marker3D = %PlayerTwoSpawn
@onready var player_three_spawn: Marker3D = %PlayerThreeSpawn
@onready var player_four_spawn: Marker3D = %PlayerFourSpawn
@onready var player_five_spawn: Marker3D = %PlayerFiveSpawn
@onready var player_six_spawn: Marker3D = %PlayerSixSpawn
@onready var left_shape_spawn: Marker3D = %LeftShapeSpawn
@onready var center_shape_spawn: Marker3D = %CenterShapeSpawn
@onready var right_shape_spawn: Marker3D = %RightShapeSpawn
@onready var left_statue: Statue = %LeftStatue
@onready var center_statue: Statue = %CenterStatue
@onready var right_statue: Statue = %RightStatue
@onready var player_one_statue: Statue = %PlayerOneStatue
@onready var player_two_statue: Statue = %PlayerTwoStatue
@onready var player_three_statue: Statue = %PlayerThreeStatue
@onready var player_four_statue: Statue = %PlayerFourStatue
@onready var player_five_statue: Statue = %PlayerFiveStatue
@onready var player_six_statue: Statue = %PlayerSixStatue
@onready var shape_spawner: ShapeSpawner = %ShapeSpawner

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
	var new_circle := shape_spawner.spawn_new_shape_at_location(ShapeSpawner.SHAPES.CIRCLE, left_shape_spawn.global_position)
	new_circle.picked_up.connect(_register_circle_consumed)
	new_circle.despawned.connect(_register_circle_consumed)
	_circle_used = false


func spawn_triangle() -> void:
	# Middle
	var new_triangle := shape_spawner.spawn_new_shape_at_location(ShapeSpawner.SHAPES.TRIANGLE, center_shape_spawn.global_position)
	new_triangle.picked_up.connect(_register_triangle_consumed)
	new_triangle.despawned.connect(_register_triangle_consumed)
	_triangle_used = false


func spawn_square() -> void:
	# Right
	var new_square := shape_spawner.spawn_new_shape_at_location(ShapeSpawner.SHAPES.SQUARE, right_shape_spawn.global_position)
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
