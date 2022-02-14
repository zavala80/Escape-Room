extends RigidBody2D

func _ready():
	$Area2D.connect("body_entered", self, "_body_entered")

func _body_entered(body):
	if body.name == "Player":
		var player = get_tree().root.get_node("Nivel/Player")
		print(player)
		player.lastimar()
