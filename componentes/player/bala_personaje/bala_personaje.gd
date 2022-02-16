extends Area2D

var GRAVEDAD = 1000
var tiempoDestruccion = 5.0

func _ready():
	var timer = Timer.new()
	self.add_child(timer)
	timer.set_wait_time(tiempoDestruccion)
	timer.connect("timeout", self, "_autodestruir_bala")
	timer.start()
	#$Area2D.connect("body_entered", self, "_body_entered")
	self.connect("area_entered", self, "_area_entered")
	set_process(true)

func _process(delta):
	global_position.y += -GRAVEDAD * delta

func _body_entered(body):
	print(body.name)
	if body.name != Global.player.name:
		if body.is_in_group("enemigo"):
			print("Es un enemigo")
	pass

func _area_entered(area):
	if area.get_parent().is_in_group("enemigo"):
		area.get_parent().morir()
		self.queue_free()

func _autodestruir_bala():
	self.queue_free()
