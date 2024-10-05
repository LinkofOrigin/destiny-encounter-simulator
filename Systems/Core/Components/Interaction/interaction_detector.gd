class_name InteractionDetector
extends RayCast3D

signal target_entered(target: InteractionTarget)
signal target_exited

var _currently_colliding: bool = false


func _physics_process(delta: float) -> void:
	if not _currently_colliding and is_colliding():
		var colliding_target := get_collider() as InteractionTarget
		target_entered.emit(colliding_target)
		_currently_colliding = true
	elif _currently_colliding and not is_colliding():
		target_exited.emit()
		_currently_colliding = false
