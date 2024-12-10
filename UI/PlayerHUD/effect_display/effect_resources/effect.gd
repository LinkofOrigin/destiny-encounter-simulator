class_name Effect
extends Resource

@export var icon: Texture2D
@export var text: String
@export var expiration_time: float
@export var priority: int  ## Higher number is higher priority


func _init() -> void:
	resource_local_to_scene = true
