class_name EffectRow
extends HBoxContainer

signal expired(effect: Effect)

@export var effect: Effect

@onready var time_label: Label = %TimeRemaining
@onready var icon_texture: TextureRect = %Icon
@onready var text_label: Label = %Text


func _ready() -> void:
	if effect.data.icon != null:
		icon_texture.texture = effect.data.icon
	
	if not effect.data.name.is_empty():
		text_label.text = effect.data.name
	
	
	if effect.data.expiration_time <= 0:
		time_label.visible_characters = 0
	
	effect.tree_exiting.connect(_on_effect_exiting_tree)


func _process(_delta: float) -> void:
	var new_time: String = _format_time_for_label(effect.timer.time_left)
	time_label.text = new_time


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


func _on_effect_exiting_tree() -> void:
	queue_free()
