extends Node

var player
var balas

func _ready():
	pass

func viewport_size():
	var width = ProjectSettings.get_setting("display/window/size/width")
	var height = ProjectSettings.get_setting("display/window/size/height")
	return Vector2(width, height)
