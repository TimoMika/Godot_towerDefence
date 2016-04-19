
extends PathFollow2D

# member variables here, example:
# var a=2
# var b="textvar"
var offset = 0
var speed = 50

func _ready():
	set_process(true)

func _process(delta):
	offset += delta*speed
	set_offset(offset)
	print(offset)