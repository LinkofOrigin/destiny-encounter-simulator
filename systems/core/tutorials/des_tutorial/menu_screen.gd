extends TutorialScreen

var _prev_menu_layer: int
var _prev_menu_visibility: bool


func _on_show_behavior() -> void:
	super._on_show_behavior()
	_prev_menu_layer = MenuManager.player_menu.layer
	_prev_menu_visibility = MenuManager.player_menu.visible
	MenuManager.player_menu.layer = get_canvas_layer_node().layer
	MenuManager.player_menu.show()


func _on_hide_behavior() -> void:
	super._on_hide_behavior()
	MenuManager.player_menu.layer = _prev_menu_layer
	MenuManager.player_menu.visible = _prev_menu_visibility
