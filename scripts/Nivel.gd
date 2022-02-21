extends Node

export (int) var nivel_int
export (int) var sig_nivel_int

func _ready():
	get_tree().paused = true
	
	# Reproducimos la canción (si es que todavía no está reproduciendose)
	Global.reproducir_musica(nivel_int)
