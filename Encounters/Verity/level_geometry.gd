extends Node3D

## Simple script just to show wall and ceiling geometry when playing, allows them to be hidden in the editor
func _ready():
	for child: Node3D in $LevelBox.get_children():
		child.visible = true
