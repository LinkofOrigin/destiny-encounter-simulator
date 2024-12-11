class_name Effect
extends Node

signal expired

@export var data: EffectData
@onready var timer: Timer = $Timer


func _ready() -> void:
	assert(data != null, "EffectData can not be null!")
	
	if data.expiration_time > 0:
		timer.wait_time = data.expiration_time
		timer.start()


func pause_timer() -> void:
	timer.paused = true


func resume_timer() -> void:
	timer.paused = false


func refresh_timer() -> void:
	if data.expiration_time > 0:
		timer.wait_time = data.expiration_time


func _on_timer_timeout() -> void:
	expired.emit()
	queue_free()
