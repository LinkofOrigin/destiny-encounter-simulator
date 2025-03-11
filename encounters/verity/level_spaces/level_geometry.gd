extends Node3D


## Simple script just to show wall and ceiling geometry when playing, allows them to be hidden in the editor
func _ready() -> void:
	for child: Node3D in find_children("*", "Node3D", true):
		child.show()
