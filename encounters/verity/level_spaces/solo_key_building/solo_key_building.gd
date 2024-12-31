class_name SoloKeyBuilding
extends Node3D

signal left_statue_received_effects(effects: Array[EffectData])
signal center_statue_received_effects(effects: Array[EffectData])
signal right_statue_received_effects(effects: Array[EffectData])

@onready var left_shape_spawn: Marker3D = %LeftShapeSpawn
@onready var center_shape_spawn: Marker3D = %CenterShapeSpawn
@onready var right_shape_spawn: Marker3D = %RightShapeSpawn
@onready var shape_spawner: ShapeSpawner = %ShapeSpawner
@onready var left_statue: Statue = %LeftStatue
@onready var center_statue: Statue = %CenterStatue
@onready var right_statue: Statue = %RightStatue


func _ready() -> void:
	spawn_circle()
	spawn_triangle()
	spawn_square()
	
	left_statue.received_effects.connect(_on_left_statue_received_effects)
	center_statue.received_effects.connect(_on_center_statue_received_effects)
	right_statue.received_effects.connect(_on_right_statue_received_effects)


func spawn_circle():
	# Left
	var new_circle := shape_spawner.spawn_new_shape_at_location(ShapeSpawner.SHAPES.CIRCLE, left_shape_spawn.global_position)
	new_circle.picked_up.connect(_on_circle_picked_up)


func spawn_triangle():
	# Middle
	var new_triangle := shape_spawner.spawn_new_shape_at_location(ShapeSpawner.SHAPES.TRIANGLE, center_shape_spawn.global_position)
	new_triangle.picked_up.connect(_on_triangle_picked_up)


func spawn_square():
	# Right
	var new_square := shape_spawner.spawn_new_shape_at_location(ShapeSpawner.SHAPES.SQUARE, right_shape_spawn.global_position)
	new_square.picked_up.connect(_on_square_picked_up)


func _on_circle_picked_up():
	await get_tree().create_timer(3).timeout
	spawn_circle()


func _on_triangle_picked_up():
	await get_tree().create_timer(3).timeout
	spawn_triangle()


func _on_square_picked_up():
	await get_tree().create_timer(3).timeout
	spawn_square()


func _on_left_statue_received_effects(effects: Array[EffectData]):
	print("solo room received effects in left statue!")
	left_statue_received_effects.emit(effects)


func _on_center_statue_received_effects(effects: Array[EffectData]):
	print("solo room received effects in center statue!")
	center_statue_received_effects.emit(effects)


func _on_right_statue_received_effects(effects: Array[EffectData]):
	print("solo room received effects in right statue!")
	right_statue_received_effects.emit(effects)
