class_name Tutorial
extends CanvasLayer

signal finished

var tab_container: TabContainer


func _ready() -> void:
	if not is_instance_valid(tab_container):
		var found_containers := find_children("*", "TabContainer", false)
		if not found_containers.is_empty():
			if is_instance_valid(found_containers[0]) and found_containers[0] is TabContainer:
				tab_container = found_containers[0]
			else:
				printerr("Failed to find tab container child for Tutorial!")


func start() -> void:
	_disable_other_inputs()
	tab_container.current_tab = 0
	show() # Ensure the tutorial displays


func step_forward() -> void:
	var stepped := tab_container.select_next_available()
	if not stepped:
		finish()


func step_back() -> void:
	var stepped := tab_container.select_previous_available()
	if not stepped:
		pass


func finish() -> void:
	_enable_other_inputs()
	queue_free.call_deferred()
	finished.emit()


func _disable_other_inputs() -> void:
	GlobalSignals.emit_restricted_input_changed(true)


func _enable_other_inputs() -> void:
	GlobalSignals.emit_restricted_input_changed(false)
