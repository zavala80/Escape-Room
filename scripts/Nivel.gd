extends Node

export (bool) var pausa_inicial
export (int) var nivel_int
export (String) var nivel_nombre
export (int) var sig_nivel_int
export (bool) var pelea_jefe

func _ready():
	Global.nivel = self
	
	# Reproducimos la canción (si es que todavía no está reproduciendose)
	Global.reproducir_musica(nivel_nombre)
	
	if pausa_inicial:
		get_tree().paused = true
	
