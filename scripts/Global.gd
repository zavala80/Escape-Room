extends Node

var nivel
var UI
var player
var jefe_final
var enemigos
var balas
var ruta_archivo = "user://datos_guardados.txt"
var config_inicial = {
	"nivel_actual": 1,
}
var datos

var musica = AudioStreamPlayer.new()
var canciones = {
	"menu": "res://musica/menu.wav",
	"nivel_1": "res://musica/nivel1.wav",
	"nivel_2": "res://musica/nivel2.wav",
	"nivel_3": "res://musica/jefe_final.wav",
}
var tween_cancion = Tween.new()

func _ready():
	musica.pause_mode = PAUSE_MODE_PROCESS
	musica.name = "musica"
	tween_cancion.pause_mode = PAUSE_MODE_PROCESS
	
	self.add_child(musica)
	self.add_child(tween_cancion)
	
	cargar_datos()

func viewport_size():
	var width = ProjectSettings.get_setting("display/window/size/width")
	var height = ProjectSettings.get_setting("display/window/size/height")
	return Vector2(width, height)

func cargar_datos():
	var file = File.new()
	if file.file_exists(ruta_archivo):
		file.open(ruta_archivo, File.READ)
		datos = parse_json(file.get_line())
		file.close()
		return datos
	else:
		guardar_partida(config_inicial)

func guardar_partida(datos_a_guardar):
	var file = File.new()
	file.open(ruta_archivo, File.WRITE)
	file.store_line(to_json(datos_a_guardar))
	file.close()
	datos = datos_a_guardar
	return datos_a_guardar

func reproducir_musica(nivel_nombre):
	if musica:
		if nivel_nombre == "menu":
			if musica.stream:
				print(musica.stream.resource_path)
				if musica.stream.resource_path != canciones.menu:
					musica.set_stream(load(canciones.menu))
			else:
				musica.set_stream(load(canciones.menu))
		if nivel_nombre == "nivel_1":
			musica.set_stream(load(canciones.nivel_1))
		if nivel_nombre == "nivel_2":
			musica.set_stream(load(canciones.nivel_2))
		if nivel_nombre == "jefe_final":
			musica.set_stream(load(canciones.nivel_3))
		
		# Si no hay música reproduciendose, que automáticamente inicie la canción
		if !musica.is_playing():
			musica.play()

func toggle_musica(status):
	if status:
		musica.play()
	else:
		musica.stop()

func termino_el_juego():
	# Eliminamos las balas y los enemigos que quedaron flotando
	if Global.balas:
		var balas_container = Global.balas
		if balas_container.get_child_count() > 0:
			balas_container.queue_free()
	if Global.enemigos:
		var enemigos_container = Global.enemigos
		if enemigos_container.get_child_count() > 0:
			enemigos_container.queue_free()
	
	# Slienciamos poco a poco la música de fondo
	tween_cancion.interpolate_property(musica, "volume_db", musica.get_volume_db(), -80, 2.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween_cancion.connect("tween_all_completed", self, "_cancion_de_salida")
	tween_cancion.start()
	
	# Pausamos el juego por un momento
	get_tree().paused = true

func _cancion_de_salida():
	# Reproducimos la música de victoria
	player.get_node("bgm_victoria").connect("finished", self, "_presalida_del_nivel")
	player.get_node("bgm_victoria").play()
	
	# Mostramos el texto que indica que el jugador ha ganado
	Global.UI.texto_ganador()

func _presalida_del_nivel():
	toggle_musica(false)
	musica.volume_db = 1.0
	
	# Escribimos en el archivo de datos del juego
	var siguiente_nivel = player.get_parent().sig_nivel_int
	if (cargar_datos().nivel_actual < siguiente_nivel):
		var nuevos_datos = {
			"nivel_actual": siguiente_nivel
		}
		guardar_partida(nuevos_datos)
	
	get_tree().paused = false
	if !nivel.pelea_jefe:
		get_tree().change_scene("res://escenas/SeleccionDeNiveles/SeleccionDeNiveles.tscn")
	else:
		get_tree().change_scene("res://escenas/niveles/Creditos/Creditos.tscn")
