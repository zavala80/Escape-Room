extends Node

onready var creditos = $Control/CenterContainer
var GRAVEDAD = 50
onready var timer = $Timer
onready var tween = $Tween

func _ready():
	timer.set_wait_time(34)
	timer.connect("timeout", self, "_iniciar_tween")
	timer.start()
	set_process(true)

func _process(delta):
	creditos.rect_position.y -= GRAVEDAD * delta
	
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()

func _iniciar_tween():
	tween.connect("tween_all_completed", self, "_cambiar_escena")
	tween.interpolate_property($musica, "volume_db", $musica.get_volume_db(), -80, 3.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

func _cambiar_escena():
	get_tree().change_scene("res://escenas/MainMenu.tscn")
