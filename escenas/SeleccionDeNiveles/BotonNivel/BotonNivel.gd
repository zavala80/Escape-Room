extends Button

export (int) var int_nivel
export (String) var redirigir_escena

func _ready():
	self.connect("button_up", self, "_cambiar_escena")
	if int_nivel <= Global.datos.nivel_actual:
		self.disabled = false
	else:
		self.disabled = true
		self.modulate.a = 0.7

func _cambiar_escena():
	if (redirigir_escena && !self.disabled):
		get_tree().change_scene(redirigir_escena)
