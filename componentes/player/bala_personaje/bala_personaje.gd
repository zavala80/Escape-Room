extends Area2D

var GRAVEDAD = 1000
var tiempoDestruccion = 5.0

func _ready():
	self.connect("area_entered", self, "_area_entered")
	# Cuando la bala se salga de la pantalla, se autodestruirá
	$VisibilityNotifier2D.connect("screen_exited", self, "_autodestruir_bala")
	set_process(true)

func _process(delta):
	global_position.y += -GRAVEDAD * delta

func _area_entered(area):
	if area.get_parent().is_in_group("enemigo"):
		area.get_parent().morir()
		self.queue_free()

func _autodestruir_bala():
	self.queue_free()
