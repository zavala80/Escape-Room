extends Node2D

func _ready():
	if Global.musica.is_playing():
		Global.toggle_musica(false)
