extends KinematicBody2D

var provocado = false

func _ready():
	$area_provocadora.connect("body_entered", self, "_body_entered")
	set_process(true)

func _process(delta):
	if (provocado):
		var player = get_tree().get_root().get_node("Nivel/Player")
		self.look_at(Vector2(player.global_position.x, player.global_position.y))

func _body_entered(body):
	if body.name == "Player":
		provocado = true

