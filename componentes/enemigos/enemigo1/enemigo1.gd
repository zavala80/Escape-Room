extends KinematicBody2D


var provocado = false
var bala_enemigo = preload("res://componentes/enemigos/bala_enemigo.tscn")
var velocidad_bala = 500
onready var timer = get_node("Timer")
var tiempoDeEnfriamientoDeDisparo = 0.5  
var angulo = 90

func _ready():
	$area_provocadora.connect("body_entered", self, "_body_entered")
	$area_provocadora.connect("body_exited", self, "_body_exited")
	timer.connect("timeout", self, "_disparar")
	timer.set_wait_time(tiempoDeEnfriamientoDeDisparo)
	set_process(true)

func _process(delta):
	if (provocado):
		# Observamos al player
		var player = get_tree().get_root().get_node("Nivel/Player")
		self.look_at(Vector2(player.global_position.x, player.global_position.y))
		self.rotation = deg2rad(self.rotation_degrees + angulo)
	

func _body_entered(body):
	if body.name == "Player":
		provocado = true
		timer.start()

func _body_exited(body):
	if body.name == "Player":
		provocado = false
		timer.stop()

func _disparar():
	# Lanzamos disparos
	var balas_container = self.get_node("balas")
	var bala = bala_enemigo.instance()
	balas_container.add_child(bala)
	var objetivo = get_tree().root.get_node("Nivel/Player")
	bala.position = $boca.global_position
	bala.apply_impulse(Vector2(), Vector2(velocidad_bala, 0).rotated(deg2rad(self.rotation_degrees + -angulo)))
