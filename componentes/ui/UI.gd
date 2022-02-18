extends Control

onready var texto_inicial = $VBoxContainer/RichTextLabel
var timer

func _ready():
	Global.UI = self
	texto_inicial.visible = false
	var animacion = texto_inicial.get_node("AnimationPlayer")
	animacion.connect("animation_finished", self, "_animacion_terminada")
	animacion.play("mostrar_y_desaparecer")

func _animacion_terminada(animacion):
	if animacion == "mostrar_y_desaparecer":
		get_tree().paused = false
