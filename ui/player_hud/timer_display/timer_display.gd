class_name TimerDisplay
extends Control

signal time_expired

const LOW_TIME_THRESHOLD = 10

@onready var timer: Timer = %Timer
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var text_container: HBoxContainer = %TextContainer
@onready var time_label: Label = %TimeLabel
@onready var text_label: Label = %TextLabel

var _text_is_flashing := false


func _ready() -> void:
	hide()
	timer.timeout.connect(_on_timer_timeout)


func _process(delta: float) -> void:
	if not timer.is_stopped():
		time_label.text = _create_text_from_time(timer.time_left)
		if timer.time_left < LOW_TIME_THRESHOLD and not _text_is_flashing:
			_enable_low_time_indicator()
			_text_is_flashing = true
		elif _text_is_flashing and timer.time_left > LOW_TIME_THRESHOLD:
			_disable_low_time_indicator()
			_text_is_flashing = false


func show_with_time_and_text(new_time: float, new_text: String) -> void:
	set_time(new_time)
	set_text(new_text)
	show()


func set_time(time: float) -> void:
	if not timer.is_stopped():
		timer.stop()
	timer.start(time)


func set_text(text: String) -> void:
	text_label.text = text


func stop_and_hide() -> void:
	timer.stop()
	hide()


func _enable_low_time_indicator() -> void:
	animation_player.play("flash_text")


func _disable_low_time_indicator() -> void:
	animation_player.pause()
	animation_player.seek(0)
	text_container.modulate = Color(1,1,1,1)


func _on_timer_timeout() -> void:
	time_expired.emit()


func _create_text_from_time(time: float) -> String:
	var total_seconds: int = time # Not concerned with microseconds
	var minutes := total_seconds / 60
	var seconds := total_seconds % 60
	
	var padded_minutes: String = str(minutes)
	var padded_seconds: String = str(seconds).lpad(2, "0")
	
	var duration_string := "%s:%s" % [padded_minutes, padded_seconds]
	return duration_string
