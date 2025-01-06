extends Node3D

@onready var statues_3d: Node3D = %Statues3D
@onready var statues_2d: Node3D = %Statues2D

var test_3d_shapes: Array[EffectLibrary.SHAPE_3D_TYPES]= [
	EffectLibrary.SHAPE_3D_TYPES.SPHERE,
	EffectLibrary.SHAPE_3D_TYPES.CUBE,
	EffectLibrary.SHAPE_3D_TYPES.PYRAMID,
	EffectLibrary.SHAPE_3D_TYPES.CYLINDER,
	EffectLibrary.SHAPE_3D_TYPES.CONE,
	EffectLibrary.SHAPE_3D_TYPES.PRISM,
]

var test_2d_shapes: Array[EffectLibrary.SHAPE_2D_TYPES] = [
	EffectLibrary.SHAPE_2D_TYPES.CIRCLE,
	EffectLibrary.SHAPE_2D_TYPES.TRIANGLE,
	EffectLibrary.SHAPE_2D_TYPES.SQUARE,
]

var first_primed_statue_effect: Shape2DEffectData
var first_primed_statue: int


func _ready() -> void:
	var all_3d_statues := statues_3d.find_children("*", "Statue3D")
	var curr_shape_index := 0
	for statue: Statue in all_3d_statues:
		statue.create_and_hold_3d_shape(test_3d_shapes[curr_shape_index])
		statue.received_effects.connect(_3d_statue_primed_with.bind(curr_shape_index))
		curr_shape_index += 1
	
	var all_2d_statues := statues_2d.find_children("*", "Statue2D")
	curr_shape_index = 0
	for statue: Statue in all_2d_statues:
		statue.create_and_hold_2d_shape(test_2d_shapes[curr_shape_index])
		curr_shape_index += 1


func _3d_statue_primed_with(effects: Array[EffectData], statue_index: int) -> void:
	if effects.size() == 1:
		var effect_received: EffectData = effects.pop_front()
		print("statue ", statue_index, " received effect ", effect_received.name)
		if first_primed_statue_effect == null:
			first_primed_statue_effect = effect_received as Shape2DEffectData
			first_primed_statue = statue_index
		else:
			print("two statues have been primed!")
			var second_effect_data := effect_received as Shape2DEffectData
			swap_shapes_for_statues(first_primed_statue, statue_index, first_primed_statue_effect, second_effect_data)
	else:
		printerr("statue received multiple effects...")


func swap_shapes_for_statues(first_statue_index: int, second_statue_index: int, first_shape: Shape2DEffectData, second_shape: Shape2DEffectData) -> void:
	var first_statue: Statue3D = statues_3d.get_children()[first_statue_index]
	var second_statue: Statue3D = statues_3d.get_children()[second_statue_index]
	first_statue.alter_3d_shape(first_shape, second_shape)
	second_statue.alter_3d_shape(second_shape, first_shape)
