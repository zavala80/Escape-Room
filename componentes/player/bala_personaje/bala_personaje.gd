extends KinematicBody2D

var motion = Vector2(0, 0)
var GRAVEDAD = 1000
var tiempoDestruccion = 5.0

func _ready():
	var timer = Timer.new()
	self.add_child(timer)
	timer.set_wait_time(tiempoDestruccion)
	timer.connect("timeout", self, "_autodestruir_bala")
	timer.start()
	$Area2D.connect("body_entered", self, "_body_entered")
	set_process(true)

func _process(delta):
	motion.y = -GRAVEDAD
	move_and_slide(motion, Vector2(0, -1))

func _body_entered(body):
	if body.name != "Player":
		if body.is_in_group("enemigo"):
			print("Es un enemigo")
	pass

func _autodestruir_bala():
	self.queue_free()
