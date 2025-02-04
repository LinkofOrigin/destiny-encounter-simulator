extends Node3D

## Simple script just to show wall and ceiling geometry when playing, allows them to be hidden in the editor
func _ready() -> void:
	for child: Node3D in $LevelBox.get_children():
		child.show()
