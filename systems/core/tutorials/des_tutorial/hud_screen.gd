extends TutorialScreen

const SPHERE_EFFECT = preload("res://systems/core/components/effect_management/effect_resources/shapes/3d_shapes/sphere_effect.tres")
const EFFECT = preload("res://systems/core/components/effect_management/effect_nodes/effect.tscn")
const TEST_STATE = preload("res://systems/core/tutorials/des_tutorial/test_state.tscn")

var _prev_hud_layer: int
var _prev_hud_visibility: bool
var _example_effect: Effect

@onready var interactable_component: InteractableComponent = $InteractableComponent
var tutorial_state: LocationState


func _ready() -> void:
	super._ready()
	tutorial_state = TEST_STATE.instantiate()
	PlayerHudManager.load_location_state_display(tutorial_state)


func _on_show_behavior() -> void:
	super._on_show_behavior()
	_prev_hud_layer = PlayerHudManager.player_hud.layer
	_prev_hud_visibility = PlayerHudManager.player_hud.visible
	PlayerHudManager.player_hud.layer = get_canvas_layer_node().layer
	PlayerHudManager.player_hud.show()
	_example_effect = EFFECT.instantiate()
	_example_effect.data = SPHERE_EFFECT
	add_child(_example_effect)
	PlayerHudManager.player_hud.add_effect(_example_effect)
	PlayerHudManager.player_hud.display_interact_prompt_for_interactable(interactable_component)
	PlayerHudManager.player_hud.show_location_state(true)
	PlayerHudManager.show_timer()


func _on_hide_behavior() -> void:
	super._on_hide_behavior()
	PlayerHudManager.player_hud.layer = _prev_hud_layer
	PlayerHudManager.player_hud.visible = _prev_hud_visibility
	_example_effect.queue_free()
	PlayerHudManager.player_hud.hide_interact_prompt()
	PlayerHudManager.player_hud.hide_location_state()
	PlayerHudManager.hide_timer()
