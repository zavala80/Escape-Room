extends Node

var UI
var player
var balas
var ruta_archivo = "user://datos_guardados.txt"
var config_inicial = {
	"nivel_actual": 1,
}
var datos

func _ready():
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
	else:
		guardar_partida(config_inicial)

func guardar_partida(datos_a_guardar):
	var file = File.new()
	file.open(ruta_archivo, File.WRITE)
	file.store_line(to_json(datos_a_guardar))
	file.close()
	datos = datos_a_guardar
	return datos_a_guardar
