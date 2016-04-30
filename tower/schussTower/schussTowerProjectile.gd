
extends Sprite

export var dmg = 10
export var speed = 160
func _ready():
	
	set_process(true)
	get_node("Area2D").connect("area_enter",self,"collided")
func _process(delta):
	move_local_x(speed*delta)

func collided(area):
	if area.get_parent().get_type() == "PathFollow2D":
		area.get_parent().dealDMG(dmg)
		queue_free()