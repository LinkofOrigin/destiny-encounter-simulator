class_name EffectRow
extends HBoxContainer

signal expired(effect: Effect)

@export var effect: Effect

@onready var time_label: Label = %TimeRemaining
@onready var icon_texture: TextureRect = %Icon
@onready var text_label: Label = %Text
@onready var timer: Timer = %Timer


func _ready() -> void:
	if effect.icon != null:
		icon_texture.texture = effect.icon
	
	if not effect.text.is_empty():
		text_label.text = effect.text
	
	
	if effect.expiration_time > 0:
		timer.wait_time = effect.expiration_time
		timer.start()
	else:
		time_label.visible_characters = 0


func _process(_delta: float) -> void:
	var new_time: String = _format_time_for_label(timer.time_left)
	time_label.text = new_time


func pause_timer() -> void:
	timer.paused = true


func resume_timer() -> void:
	timer.paused = false


func refresh_timer() -> void:
	if effect.expiration_time > 0:
		timer.wait_time = effect.expiration_time


func _format_time_for_label(seconds: float) -> String:
	@warning_ignore("integer_division")
	var minutes := seconds / 60
	var remaining_seconds := int(seconds) % 60
	
	var minutes_text := str(minutes)
	var seconds_text := str(remaining_seconds).lpad(2, "0")
	
	var format: String = "%s:%s"
	
	return format % [minutes_text, seconds_text]


func _on_timer_timeout() -> void:
	expired.emit(effect)
