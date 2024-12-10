class_name EffectDisplay
extends MarginContainer

@onready var effect_list: VBoxContainer = %EffectList

@onready var effect_row_packed := preload("res://UI/PlayerHUD/effect_display/effect_row/effect_row.tscn")

var effect_row_mapping: Dictionary

# Threading variables
var thread: Thread
var mutex: Mutex
var semaphore: Semaphore
var exit_thread := false

var effect_queue: Array[Effect] ## Holds a list of effects that need to be instantiated for the display, to be processed by the child thread
var prepared_effects: Array[EffectRow] ## Holds a list of EffectRow objects ready to be added to the tree

func _ready() -> void:
	mutex = Mutex.new()
	semaphore = Semaphore.new()
	exit_thread = false
	
	thread = Thread.new()
	thread.start(_thread_function)


func _process(delta: float) -> void:
	var prepared_effect: EffectRow
	mutex.lock()
	if not prepared_effects.is_empty():
		prepared_effect = prepared_effects.pop_front()
	mutex.unlock()
	
	if is_instance_valid(prepared_effect):
		effect_list.add_child(prepared_effect)


func add_effect(effect: Effect) -> void:
	mutex.lock()
	effect_queue.push_back(effect)
	mutex.unlock()
	
	semaphore.post()


func remove_effect(effect: Effect) -> void:
	mutex.lock()
	var row_to_remove: EffectRow = effect_row_mapping[effect]
	if is_instance_valid(row_to_remove):
		effect_row_mapping.erase(effect)
		row_to_remove.queue_free()
	mutex.unlock()


func _on_effect_expired(effect: Effect) -> void:
	remove_effect(effect)


# Semaphore and threading logic

func _thread_function() -> void:
	while true:
		# Check if there are any effects in the queue
		# If there are none, the semaphore will wait
		# If is at least one, the thread will instantiate a new EffectRow
		var effect_to_create: Effect
		mutex.lock()
		if effect_queue.is_empty():
			mutex.unlock()
			semaphore.wait()
		else:
			effect_to_create = effect_queue.pop_front()
		mutex.unlock()
		
		if effect_to_create != null:
			var new_effect_row: EffectRow = effect_row_packed.instantiate()
			new_effect_row.effect = effect_to_create
			new_effect_row.expired.connect(_on_effect_expired)
			mutex.lock()
			effect_row_mapping[new_effect_row.effect] = new_effect_row
			prepared_effects.push_back(new_effect_row)
			mutex.unlock()
		
		mutex.lock()
		var should_exit := exit_thread
		mutex.unlock()
		
		if should_exit:
			break


func _exit_tree() -> void:
	mutex.lock()
	exit_thread = true
	mutex.unlock()
	
	# Tell the semaphore to run, then wait for the thread to be done
	semaphore.post()
	thread.wait_to_finish()
	
	print("Effect Display thread cleaned up! Exiting...")
