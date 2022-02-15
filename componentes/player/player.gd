extends KinematicBody2D

var motion = Vector2(0, 0) # Motion inicial del personaje
const VELOCIDAD = 250 # Velocidad del personaje
var puede_caminar = true
var bala_personaje = preload("res://componentes/player/bala_personaje/bala_personaje.tscn")
var particulas_muerte = preload("res://componentes/muertes/particula_personaje_muerte.tscn")
var esta_vivo = true
var inmortal = false
var vidas = 3
var termino_el_juego = false
var GRAVEDAD = 200

func _ready():
	Global.player = self
	$AnimationPlayer.connect("animation_finished", self, "_termino_animacion")
	set_process(true)
	
func _process(delta):
	if (vidas > 0):
		# Inputs del teclado
		administrar_inputs()
		
		# Movimiento del personaje
		move_and_slide(motion, Vector2(0, -1))
	else:
		esta_vivo = false
		morir()

func administrar_inputs():
	# Movimiento horizontal y vertical
	motion.x = (
		int(Input.is_action_pressed("ui_right")
		|| Input.is_action_pressed("ui_d"))
		- int(Input.is_action_pressed("ui_left")
		|| Input.is_action_pressed("ui_a"))) * VELOCIDAD
#	motion.y = (int(Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_s")) - int(Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_w"))) * VELOCIDAD
	motion.y = -GRAVEDAD
	
	# Limitamos el espacio donde se puede mover el personaje
	if self.position.x < 0:
		self.position.x = 0
	elif self.position.x > 1024:
		self.position.x = 1024
	
	# Disparar
	if Input.is_action_just_pressed("ui_z"):
		var balas_container = Global.balas
		var bala = bala_personaje.instance()
		bala.set_name("bala_personaje")
		balas_container.add_child(bala)
		bala.global_position.x = $boca.global_position.x
		bala.global_position.y = $boca.global_position.y
	
	# Reinicio del nivel
	if Input.is_action_just_released("ui_restart"):
		reiniciar_nivel()

func lastimar():
	if (!inmortal):
		inmortal = true
		vidas = vidas - 1
		if vidas != 0:
			realizar_animacion("lastimado")

func realizar_animacion(animacion):
	if animacion == "lastimado":
		$AnimationPlayer.play("lastimado")
	pass

func _termino_animacion(animacion):
	if animacion == "lastimado":
		inmortal = false

func morir():
	if (!termino_el_juego):
		termino_el_juego = true
		var timer = Timer.new()
		self.add_child(timer)
		timer.connect("timeout", self, "reiniciar_nivel")
		timer.wait_time = 1
		timer.start()
		var muerte_particulas = particulas_muerte.instance()
		self.add_child(muerte_particulas)
		$Sprite.visible = false

func reiniciar_nivel():
	get_tree().reload_current_scene()


