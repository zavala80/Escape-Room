extends KinematicBody2D

var motion = Vector2(0, 0) # Motion inicial del personaje
const VELOCIDAD = 250 # Velocidad del personaje
var puede_caminar = true
var bala_personaje = preload("res://componentes/player/bala_personaje/bala_personaje.tscn")

func _ready():
	set_process(true)
	
func _process(delta):
	# Inputs del teclado
	administrar_inputs()
	
	# Movimiento del personaje
	move_and_slide(motion, Vector2(0, -1))

func administrar_inputs():
	# Movimiento horizontal y vertical
	motion.x = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))) * VELOCIDAD
	motion.y = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))) * VELOCIDAD
	
	# Limitamos el espacio donde se puede mover el personaje
	if self.position.x < 0:
		self.position.x = 0
	elif self.position.x > 1024:
		self.position.x = 1024
	
	if Input.is_action_just_pressed("ui_z"):
		var root = get_tree().get_root().get_node("Nivel/balas")
		var bala = bala_personaje.instance()
		root.add_child(bala)
		bala.global_position.x = $boca.global_position.x
		bala.global_position.y = $boca.global_position.y
		print("disparo del player")
	
	# Reinicio del nivel
	if Input.is_action_just_released("ui_restart"):
		get_tree().reload_current_scene()
	
