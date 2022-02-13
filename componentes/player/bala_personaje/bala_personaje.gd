extends KinematicBody2D

var motion = Vector2(0, 0)
var GRAVEDAD = 1000

func _ready():
	set_process(true)

func _process(delta):
	motion.y = -GRAVEDAD
	move_and_slide(motion, Vector2(0, -1))
