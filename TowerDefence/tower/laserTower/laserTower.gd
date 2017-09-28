extends "res://tower/tower.gd"

var tarGegPos

func _init():
	botTex = load("res://tower/laserTower/LaserTowerBase.png")
	topTex = load("res://tower/laserTower/LaserTowerGun.png")
	shape = load("res://tower/laserTower/shape.tres")

func _ready():
	dmg = 40
	energyCost = 8
	cost = 100
	set_draw_behind_parent(false)

func _draw():
	if tarGeg != null && tarGegPos != null && level.energy >= energyCost:
		#draw_set_transform(Vector2(0,0), -((tarGegPos-get_pos()).angle_to(Vector2(1,0))), Vector2(1,1))
		#draw_rect(Rect2(Vector2(0,-3), Vector2(get_pos().distance_to(tarGegPos) ,3)), Color(0.8, 0, 0.4, 0.32))
		#draw_rect(Rect2(Vector2(0,-1), Vector2(get_pos().distance_to(tarGegPos) ,1)), Color(0, 0.7, 1))
		draw_line(Vector2(0,0), tarGegPos - get_pos(), Color(0.8, 0, 0.4, 0.32), 6)
		draw_line(Vector2(0,0), tarGegPos - get_pos(), Color(0, 0.7, 1), 1)


func _process(delta):
	if level.energy >= energyCost:
		refreshRot()
		if tarGeg != null:
			tarGegPos = tarGeg.get_pos()
			tarGeg.dealDMG(dmg * delta)
	update()