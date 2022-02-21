extends KinematicBody2D

var provocado = false
var bala_enemigo = preload("res://componentes/enemigos/bala_enemigo.tscn")
var particulas_explosion = preload("res://componentes/muertes/particula_personaje_muerte.tscn")
var velocidad_bala = 400
onready var timer = get_node("Timer")
var tiempoDeEnfriamientoDeDisparo = 0.25
var angulo = 90
var anguloDisparo = 90
var esta_vivo = true
var vidas = 60
var vida_ui
var size_x_vidas
onready var path = get_parent()

func _ready():
	Global.jefe_final = self
	
	# Obtenemos la UI de los corazones y su medida individual
	if Global.UI:
		vida_ui = Global.UI.get_node("Vida_jefe")
		size_x_vidas = vida_ui.rect_size.x / vidas
	
	# Actualizamos la UI
	actualizar_ui()
	
	$area_provocadora.connect("body_entered", self, "_dentro_del_area")
	$area_provocadora.connect("body_exited", self, "_fuera_del_area")
	$enemigo_collider.connect("body_entered", self, "_colisioned_body")
	$VisibilityNotifier2D.connect("screen_exited", self, "eliminar_enemigo")
	timer.connect("timeout", self, "_disparar")
	timer.set_wait_time(tiempoDeEnfriamientoDeDisparo)
	set_process(true)

func _process(delta):
	if (provocado && esta_vivo):
		if path is PathFollow2D:
			path.set_offset(path.get_offset() + 350 * delta)

func _dentro_del_area(body):
	if body.name == Global.player.name:
		provocado = true
		timer.start()

func _fuera_del_area(body):
	if body.name == Global.player.name:
		provocado = false
		timer.stop()

func _colisioned_body(body):
	if body.name == Global.player.name:
		Global.player.lastimar()

func _disparar():
	# Lanzamos disparos
	var balas_container = Global.balas
	var bala1 = bala_enemigo.instance()
	var bala2 = bala_enemigo.instance()
	balas_container.add_child(bala1)
	balas_container.add_child(bala2)
	bala1.position = $boca1.global_position
	bala2.position = $boca2.global_position
	bala1.apply_impulse(Vector2(), Vector2(velocidad_bala, 0).rotated(deg2rad(90)))
	bala2.apply_impulse(Vector2(), Vector2(velocidad_bala, 0).rotated(deg2rad(90)))

func actualizar_ui():
	# Indicamos la cantidad de vidas iniciales que tenemos
	if (Global.UI):
		vida_ui.rect_size.x = size_x_vidas * vidas

func lastimar():
	vidas = vidas - 1
	if vidas != 0:
		$fx_lastimado.play()
	else:
		morir()
		Global.termino_el_juego()
	
	actualizar_ui()

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
