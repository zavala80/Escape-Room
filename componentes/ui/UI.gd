extends Control

onready var texto_inicial = $CenterContainer/Vamos
onready var texto_ganador = $CenterContainer/Ganaste
var timer

func _ready():
	Global.UI = self
	cambiar_texto("¡Vamos!")
	texto_inicial.visible = false
	var animacion = texto_inicial.get_node("AnimationPlayer")
	animacion.connect("animation_finished", self, "_animacion_terminada")
	animacion.play("mostrar_y_desaparecer")

func _animacion_terminada(animacion):
	if animacion == "mostrar_y_desaparecer":
		get_tree().paused = false

func cambiar_texto(texto):
	texto_inicial.text = texto

func texto_ganador():
	texto_ganador.visible = true
