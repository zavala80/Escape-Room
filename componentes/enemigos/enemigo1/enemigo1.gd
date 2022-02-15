extends KinematicBody2D

var provocado = false
var bala_enemigo = preload("res://componentes/enemigos/bala_enemigo.tscn")
var particulas_explosion = preload("res://componentes/muertes/particula_personaje_muerte.tscn")
var velocidad_bala = 500
onready var timer = get_node("Timer")
var tiempoDeEnfriamientoDeDisparo = 0.5  
var angulo = 90
var esta_vivo = true

func _ready():
	$area_provocadora.connect("body_entered", self, "_dentro_del_area")
	$area_provocadora.connect("body_exited", self, "_fuera_del_area")
	$enemigo_collider.connect("body_entered", self, "_colisioned_body")
	timer.connect("timeout", self, "_disparar")
	timer.set_wait_time(tiempoDeEnfriamientoDeDisparo)
	set_process(true)

func _process(delta):
	if (provocado && esta_vivo):
		# Observamos al player
		var player = get_tree().get_root().get_node("Nivel/Player")
		self.look_at(Vector2(player.global_position.x, player.global_position.y))
		self.rotation = deg2rad(self.rotation_degrees + angulo)
	

func _dentro_del_area(body):
	if body.name == "Player":
		provocado = true
		timer.start()

func _fuera_del_area(body):
	if body.name == "Player":
		provocado = false
		timer.stop()

func _colisioned_body(body):
	if (body.is_in_group("bala_personaje")):
		morir()
	print(body.name)
	pass

func _disparar():
	# Lanzamos disparos
	var balas_container = self.get_node("balas")
	var bala = bala_enemigo.instance()
	balas_container.add_child(bala)
	var objetivo = get_tree().root.get_node("Nivel/Player")
	bala.position = $boca.global_position
	bala.apply_impulse(Vector2(), Vector2(velocidad_bala, 0).rotated(deg2rad(self.rotation_degrees + -angulo)))


func morir():
	$Sprite.visible = false
	if (esta_vivo):
		esta_vivo = false
		var timer = Timer.new()
		self.add_child(timer)
		var explosion = particulas_explosion.instance()
		self.add_child(explosion)
		timer.connect("timeout", self, "eliminar_enemigo")
		timer.set_wait_time(explosion.lifetime / 2)
		explosion.set_one_shot(true)
		timer.start()
		$Sprite.visible = false

func eliminar_enemigo():
	print("eliminado")
	self.queue_free()


