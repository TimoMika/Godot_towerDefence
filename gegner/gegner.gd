
extends PathFollow2D

# member variables here, example:
# var a=2
# var b="textvar"
var offset = 0
onready var curve_length = get_parent().get_curve().get_baked_length()
export var speed = 50
export var dmg = 1
func _ready():
	set_process(true)

func _process(delta):
	offset += delta * speed
	set_offset(offset)
#	print(offset)
#	print(get_parent().get_curve().get_baked_length())
	if curve_length < offset:
		#make demage
		#global.lives -= dmg
		free()