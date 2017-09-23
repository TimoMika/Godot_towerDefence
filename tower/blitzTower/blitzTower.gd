
extends "res://tower/tower.gd"

var tarGegPos
var rotSpeed = 0.9
var cover
var coverTex

func _init():
	botTex = load("res://tower/blitzTower/BlitzTowerBase.png")
	topTex = load("res://tower/blitzTower/BlitzTowerBlitze.png")
	shape = load("res://tower/blitzTower/shape.tres")
	coverTex = load("res://tower/blitzTower/BlitzTowerCover.png")

func _ready():
	cover = Sprite.new()
	bot.add_child(cover)
	cover.set_texture(coverTex)
	dmg = 50
	set_draw_behind_parent(false)

func _draw():
	if tarGeg != null && level.energy >= energyCost:
		var malen = true
		var pos = Vector2(get_pos().x, get_pos().y)
		var posAlt = Vector2(get_pos().x, get_pos().y)
		var ende = 17
		var blitzLaenge = 17
		
		while malen:
			pos.x = pos.x + (tarGegPos.x - pos.x) / pos.distance_to(tarGegPos) * randf() * blitzLaenge
			pos.y = pos.y + (tarGegPos.y - pos.y) / pos.distance_to(tarGegPos) * randf() * blitzLaenge

			draw_line(posAlt - get_pos(), pos - get_pos(), Color(0.12, 0.4, 1, 0.4), 4)
			draw_line(posAlt - get_pos(), pos - get_pos(), Color(0.12, 0.9, 1), 1)

			if pos.distance_to(tarGegPos) < ende :
				malen = false
				draw_line(tarGegPos - get_pos(), pos - get_pos(), Color(0.12, 0.9, 1), 1)

			posAlt = pos

func _process(delta):
	if level.energy >= energyCost:
		refreshRot()
		if tarGeg != null:
			tarGegPos = tarGeg.get_pos()
			tarGeg.dealDMG(dmg * delta)
	update()

func refreshRot():
	tarGeg = null
	top.rotate(rotSpeed)
	for g in get_parent().get_node("Path").get_children():
		if g.health.get_value() > 0:
			var toGeg = g.get_pos()-get_pos()
			if (toGeg).length() < schootRange:
				tarGeg = g
				break