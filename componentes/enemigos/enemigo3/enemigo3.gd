extends RigidBody2D

var GRAVEDAD = 1
var provocado = false
var bala_enemigo = preload("res://componentes/enemigos/bala_enemigo.tscn")
var particulas_explosion = preload("res://componentes/muertes/particula_personaje_muerte.tscn")
var velocidad_bala = 400
onready var timer = get_node("Timer")
var tiempoDeEnfriamientoDeDisparo = 1.0
var angulo = 90
var anguloDisparo = 90
var esta_vivo = true
onready var path = get_parent().get_parent()

func _ready():
	$area_provocadora.connect("body_entered", self, "_dentro_del_area")
	$area_provocadora.connect("body_exited", self, "_fuera_del_area")
	$enemigo_collider.connect("body_entered", self, "_colisioned_body")
	$VisibilityNotifier2D.connect("screen_exited", self, "eliminar_enemigo")
	timer.connect("timeout", self, "_disparar")
	timer.set_wait_time(tiempoDeEnfriamientoDeDisparo)
	set_process(true)

func _process(delta):
	print(self.global_position.x)
	if (provocado && esta_vivo):
		gravity_scale = 3.4
		applied_force = Vector2(Global.player.global_position.x - self.position.x, -100)

func _dentro_del_area(body):
	if body.name == Global.player.name:
		provocado = true
		timer.start()

func _fuera_del_area(body):
	if body.name == Global.player.name:
		provocado = false
		timer.stop()

func _colisioned_body(body):
	if (body.is_in_group("bala_personaje")):
		morir()
	if body.name == Global.player.name:
		Global.player.lastimar()

func _disparar():
	# Lanzamos disparos
	var balas_container = Global.balas
	var bala1 = bala_enemigo.instance()
	balas_container.add_child(bala1)
	bala1.position = $boca1.global_position
	bala1.apply_impulse(Vector2(), Vector2(velocidad_bala, 0).rotated(deg2rad(90)))

func morir():
	$Sprite.visible = false
	if (esta_vivo):
		# Eliminamos las áreas
		$enemigo_collider.queue_free()
		$area_provocadora.queue_free()
		
		# Detenemos el timer inicial (el que hace que dispare balas)
		timer.stop()
		
		# Destruimos al enemigo
		esta_vivo = false
		var timer_muerte = Timer.new()
		self.add_child(timer_muerte)
		var explosion = particulas_explosion.instance()
		self.add_child(explosion)
		timer_muerte.connect("timeout", self, "eliminar_enemigo")
		timer_muerte.set_wait_time(explosion.lifetime / 2)
		explosion.set_one_shot(true)
		timer_muerte.start()
		$Sprite.visible = false
		if !$fx_muerte.playing:
			$fx_muerte.play()

func eliminar_enemigo():
	self.queue_free()
