extends Button

export (int) var int_nivel

func _ready():
	if int_nivel <= Global.datos.nivel_actual:
		self.disabled = false
	else:
		self.disabled = true
