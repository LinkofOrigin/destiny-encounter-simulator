class_name FadeAndSpawn
extends EncounterMechanic

signal players_moved
# TODO: Should these be moved to the HUD nodes and made global?
signal screen_fade_out_finished
signal screen_fade_in_finished

var players: Array[PlayerCharacter]
var player_spawns: Array[Marker3D]


func move_players_to_spawns() -> void:
	if players.is_empty():
		printerr("Players not set for fade and respawn!")
	if player_spawns.is_empty():
		printerr("Player spawns not set for fade and respawn!")
	if players.size() != player_spawns.size():
		# TODO: This may change to just a single player per networked instance...?
		print("Count of players and spawns don't match! Players: %s | Spawns: %s" % [players.size(), player_spawns.size()])
	
	for index: int in range(players.size()):
		var spawn_location := player_spawns[index]
		if is_instance_valid(spawn_location):
			var player_to_move := players[index]
			player_to_move.global_position = spawn_location.global_position
	
	players_moved.emit()


func fade_screen_out() -> void:
	PlayerHudManager.fade_screen_out(_on_screen_fade_out_finished)


func fade_screen_in() -> void:
	PlayerHudManager.fade_screen_in(_on_screen_fade_in_finished)


func _on_screen_fade_out_finished() -> void:
	screen_fade_out_finished.emit()


func _on_screen_fade_in_finished() -> void:
	screen_fade_in_finished.emit()
