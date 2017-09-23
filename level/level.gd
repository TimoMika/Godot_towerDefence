
extends Node

#var shapeChecker = RectangleShape2D.new()
var packedTower = load("res://tower/tower.tscn")
var packedBuilding = load("res://Buildings/building.tscn")

var generatorScript = load("res://Buildings/generator/generator.gd")

var schussTowerScript = load("res://tower/schussTower/schussTower.gd")
var schussTowerBuildHelp = load("res://tower/schussTower/schussTowerBuildHelp.png")
var laserTowerScript = load("res://tower/laserTower/laserTower.gd")
var blitzTowerScript = load("res://tower/blitzTower/blitzTower.gd")
var rocketTowerScript = load("res://tower/rocketTower/rocketTower.gd")

onready var buildHelp = get_node("BuildHelp")

var lives = 0
var maxLives = 100
var money = 0
var energy = 0
var maxEnergy = 100
var towerType = 1

func _ready():
	set_process_input(true)
	set_process(true)
	
	loadLvl(get_node("/root/global").getMapNum(),1)
	
	changeMoney(1000)
	changeEnergy(100)
	changeLives(100)
	
func _input(event):
	build_tower(event)
	build_building(event)
	
func _process(delta):
	if not buildHelp.is_hidden():
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			buildHelp.set_pos(get_viewport().get_mouse_pos())
		else:
			print("baue")
			buildHelp.set_hidden(true)

	changeEnergy(1*delta)

func build_tower(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.button_index == BUTTON_LEFT && event.is_pressed():

		var t = packedTower.instance()
		if towerType == 0:
			t.set_script(laserTowerScript)
		if towerType == 1:
			t.set_script(schussTowerScript)
		if towerType == 2:
			t.set_script(blitzTowerScript)
		if towerType == 3:
			t.set_script(rocketTowerScript)

		if not Col_in_UIshape_List(event.pos,t.get_node("shape").get_shape()) && money >= t.cost:
			changeMoney(-t.cost)
			t.set_pos(event.pos)
			add_child(t)

func build_building(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.button_index == BUTTON_RIGHT && event.is_pressed():
		var b = packedBuilding.instance()
		b.set_script(generatorScript)
		if not Col_in_UIshape_List(event.pos,b.get_node("shape").get_shape()) && money >= b.cost:
			changeMoney(-b.cost)
			b.set_pos(event.pos)
			add_child(b)

func Col_in_UIshape_List(pos,shape):
	for node in get_tree().get_nodes_in_group("UIshapes"):
#		print("transform ",node.get_parent().get_transform())
#		print("selfmade ",Matrix32(0,pos))
#		print( node.get_shape().collide(Matrix32(0,pos),shape,node.get_parent().get_transform()) )
#		print(shape.get_extents())
#		print("Node: ", node)
		if node.get_shape().collide(Matrix32(0,pos),shape,node.get_parent().get_transform()):
			return true
			
	for guiNode in get_tree().get_nodes_in_group("Gui_item"):
#		print("Gui Node: ", guiNode)
		var guiShape = RectangleShape2D.new()
		guiShape.set_extents(guiNode.get_rect().size)
		if guiShape.collide(Matrix32(0,pos),shape,guiNode.get_transform()):
			return true
		
	return false

func loadLvl(mapNumber,lvNumber):
	#setup Background
	var bg = load("res://level/Lv" + str(mapNumber) + "/BackLv" + str(mapNumber) + ".png")
	get_node("Sprite").set_texture(bg)
	#setup the path/gegnerspawner
	var path = get_node("Path")
	path.map = mapNumber
	path.lv = lvNumber
	var curve = load("res://level/Lv" + str(mapNumber) + "/curveMap" + str(mapNumber) + ".tres")
	path.set_curve(curve)
	
	#place Sprite for Ziel at right spot with right rotation
	var sprite_Ziel = get_node("Sprite_ziel")
	#var zielDir = Vector2((curve.get_point_pos(curve.get_point_count() - 2).x - curve.get_point_pos(curve.get_point_count() - 1).x), (curve.get_point_pos(curve.get_point_count() - 2).y - curve.get_point_pos(curve.get_point_count() - 1).y))
	var zielDir = Vector2(getNodePos(curve, 2) - getNodePos(curve, 1))
	zielDir = zielDir.normalized()
	sprite_Ziel.set_rot(zielDir.angle_to(Vector2(-1, 0)))
	print(zielDir)
	var posZielX = (getNodePos(curve, 1).x + (zielDir.x * (sprite_Ziel.get_texture().get_width()/2)) +3)
	var posZielY = (getNodePos(curve, 1).y + (zielDir.y * (sprite_Ziel.get_texture().get_width()/2)) +2)
	sprite_Ziel.set_pos(Vector2(posZielX, posZielY))
	
	#make collision for path
	for i in range(curve.get_point_count() - 1):
		var p = curve.get_point_pos(i)
		var pNext = curve.get_point_pos(i + 1)
		var shape = RectangleShape2D.new()
		if abs(p.x - pNext.x) > abs(p.y - pNext.y):
			shape.set_extents(Vector2((abs(p.x - pNext.x)/2) + 22,22))
		else:
			shape.set_extents(Vector2(22,(abs(p.y - pNext.y)/2) + 22))
		var shapeNode = CollisionShape2D.new()
		shapeNode.set_shape(shape)
		shapeNode.add_to_group("UIshapes")
		
		var node2D = Node2D.new()
		node2D.add_child(shapeNode)
		node2D.set_pos((p+pNext)*0.5)
		add_child(node2D)
	path.curve_loaded()

func getNodePos(curve, offset):
	return curve.get_point_pos(curve.get_point_count() - offset)

func changeMoney(val):
	money += val
	get_node("MoneyLabel").set_text("Money: " + str(money))
	
func changeEnergy(val):
	energy += val
	if energy > maxEnergy:
		energy = maxEnergy
	var value = float(energy)/float(maxEnergy)
	get_node("EnergyBar").set_value(value)
	
func changeLives(val):
	lives += val
	if lives > maxLives:
		lives = maxLives
	var value = float(lives)/float(maxLives)
	print(value)
	get_node("liveBar").set_value(value)

func _on_LaserTowerButton_pressed():
	towerType = 0
	print("Laser Tower")

func _on_SchussTowerButton_pressed():
	buildHelp.set_texture(schussTowerBuildHelp)
	buildHelp.set_hidden(false)
	towerType = 1
	print("SchussTower")


func _on_BlitzTowerButton_pressed():
	towerType = 2
	print("BlitzTower")

func _on_RocketTowerButton_pressed():
	towerType = 3
	print("RocketTower")
