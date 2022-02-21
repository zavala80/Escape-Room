extends Sprite

var escalas = [Vector2(0, 0), Vector2(20, 20)]
var rotaciones = [0, 200]

func _ready():
	self.position = Vector2(Global.viewport_size().x / 2, Global.viewport_size().y / 2)
	self.rotation_degrees = rotaciones[0]
	achicar()

func achicar():
	$Tween.interpolate_property(self, "scale", escalas[1], escalas[0], 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "rotation_degrees", rotaciones[0], rotaciones[1], 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()

func engrandecer():
	$Tween.interpolate_property(self, "scale", escalas[0], escalas[1], 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "rotation_degrees", rotaciones[1], rotaciones[0], 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
