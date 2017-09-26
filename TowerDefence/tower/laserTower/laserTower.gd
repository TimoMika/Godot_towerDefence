extends "res://tower/tower.gd"

var tarGegPos

func _init():
	botTex = load("res://tower/laserTower/LaserTowerBase.png")
	topTex = load("res://tower/laserTower/LaserTowerGun.png")
	shape = load("res://tower/laserTower/shape.tres")

func _ready():
	dmg = 50
	set_draw_behind_parent(false)

func _draw():
	if tarGeg != null && tarGegPos != null && level.energy >= energyCost:
		draw_line(Vector2(0,0), tarGegPos - get_pos(), Color(0.8, 0, 0.4, 0.32), 6)
		draw_line(Vector2(0,0), tarGegPos - get_pos(), Color(0, 0.7, 1), 1)

func _process(delta):
	if level.energy >= energyCost:
		refreshRot()
		if tarGeg != null:
			tarGegPos = tarGeg.get_pos()
			tarGeg.dealDMG(dmg * delta)
	update()