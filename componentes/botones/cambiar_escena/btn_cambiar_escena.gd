extends Button

export (String) var escena_a_cambiar

func _ready():
	self.connect("button_up", self, "_cambiar_escena")

func _cambiar_escena():
	get_tree().change_scene(escena_a_cambiar)
