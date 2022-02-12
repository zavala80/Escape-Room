extends Button

func _ready():
	self.connect("button_up", self, "_salir")

func _salir():
	get_tree().quit()
