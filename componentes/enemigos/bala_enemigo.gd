extends RigidBody2D

var tiempoDestruccion = 5.0

func _ready():
	var timer = Timer.new()
	self.add_child(timer)
	timer.set_wait_time(tiempoDestruccion)
	timer.connect("timeout", self, "_autodestruir_bala")
	timer.start()
	$Area2D.connect("body_entered", self, "_body_entered")

func _body_entered(body):
	if body.name == "Player":
		var player = get_tree().root.get_node("Nivel/Player")
		player.lastimar()

func _autodestruir_bala():
	self.queue_free()


