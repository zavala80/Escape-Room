extends Button

export (String) var escena_a_cambiar
export (bool) var salir

func _ready():
	self.connect("button_up", self, "_cambiar_escena")

func _cambiar_escena():
	if !salir:
		get_tree().change_scene(escena_a_cambiar)
	else:
		get_tree().quit()
