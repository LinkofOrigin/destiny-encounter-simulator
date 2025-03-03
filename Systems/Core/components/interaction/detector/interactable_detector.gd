class_name InteractableDetector
extends Node3D

signal can_interact_with(interactable: InteractableComponent)
signal can_not_interact()

@export var camera_parent_for_target: Camera3D

@onready var target_detector: RayCast3D = $TargetDetector
@onready var zone_detector: RayCast3D = $ZoneDetector

var _target_colliding: bool = false
var _zone_colliding: bool = false
var _target_interactable: InteractableComponent
var _zone_interactable: InteractableComponent


func _ready() -> void:
	if is_instance_valid(camera_parent_for_target):
		remove_child(target_detector)
		camera_parent_for_target.add_child(target_detector)


func _physics_process(_delta: float) -> void:
	var colliding_with_target := _check_for_target()
	var colliding_with_zone := _check_for_zone()
	
	# If one of them changed...
	if _target_colliding != colliding_with_target or _zone_colliding != colliding_with_zone:
		# If both detectors are colliding...
		if colliding_with_target and colliding_with_zone:
			# If the parent interactables are the same object...
			if _target_interactable == _zone_interactable:
				can_interact_with.emit(_target_interactable)
		# If both were colliding and now one isn't...
		elif (_target_colliding and _zone_colliding) and (not colliding_with_target or not colliding_with_zone):
			can_not_interact.emit()
	
		_target_colliding = colliding_with_target
		_zone_colliding = colliding_with_zone


func _check_for_target() -> bool:
	if target_detector.is_colliding():
		var colliding_object := target_detector.get_collider() as InteractionTarget
		if is_instance_valid(colliding_object):
			_target_interactable = colliding_object.find_parent("InteractableComponent") as InteractableComponent
			#print("player connected with target!")
			return true
	
	return false


func _check_for_zone() -> bool:
	if zone_detector.is_colliding():
		var colliding_object := zone_detector.get_collider() as InteractionZone
		if is_instance_valid(colliding_object):
			_zone_interactable = colliding_object.find_parent("InteractableComponent") as InteractableComponent
			#print("player connected with zone!")
			return true
	
	return false
