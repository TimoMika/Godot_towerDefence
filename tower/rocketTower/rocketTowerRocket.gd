
extends Sprite

onready var dmg = get_parent().dmg
onready var expRad = get_parent().expRad
onready var speed = get_parent().speed
var tarGeg
var tarGegPath

func _ready():
	tarGeg = get_parent().tarGeg
	tarGegPath = tarGeg.get_path()
	set_process(true)
	get_node("RocketArea2D").connect("area_enter",self,"collided")


func _process(delta):
	if tarGeg != null && get_tree().get_root().has_node(tarGegPath):
		var angle = get_angle_to(tarGeg.get_pos())
		if angle > 0.2:
			angle = 0.2
		elif angle < -0.2:
			angle = -0.2

		rotate(angle)
#		look_at(tarGeg.get_pos())
	else:
		findNewGeg()
		rotate(PI/120)

	move_local_y(speed*delta)

func findNewGeg():
	tarGeg = null
	var gegDist = 10000
	for g in get_parent().get_parent().get_node("Path").get_children():
		if g.health.get_value() > 0:
			var toGeg = g.get_pos()-(get_pos() + get_parent().get_pos())
			if (toGeg).length() < gegDist:
				tarGeg = g
				tarGegPath = g.get_path()

func collided(area):
	if area.get_parent().get_type() == "PathFollow2D":
		for g in get_parent().get_parent().get_node("Path").get_children():
#			if g.health.get_value() > 0:
			var toGeg = g.get_pos()-(get_pos() + get_parent().get_pos())
			print("Dist to " + g.get_name() + " is ", toGeg.length())
			if (toGeg).length() < expRad:
				g.dealDMG(dmg)
				queue_free()