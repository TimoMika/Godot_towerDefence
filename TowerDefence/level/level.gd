extends Node

#var shapeChecker = RectangleShape2D.new()
var packedTower = load("res://tower/tower.tscn")
var packedBuilding = load("res://buildings/building.tscn")

var generatorScript = load("res://buildings/generator/generator.gd")
var generatorBuildHelp = load("res://buildings/generator/Generator.png")

var schussTowerScript = load("res://tower/schussTower/schussTower.gd")
var schussTowerBuildHelp = load("res://tower/schussTower/SchussTowerBuildHelp.png")
var laserTowerScript = load("res://tower/laserTower/laserTower.gd")
var laserTowerBuildHelp = load("res://tower/laserTower/LaserTowerBuildHelp.png")
var blitzTowerScript = load("res://tower/blitzTower/blitzTower.gd")
var blitzTowerBuildHelp = load("res://tower/blitzTower/BlitzTowerBuildHelp.png")
var rocketTowerScript = load("res://tower/rocketTower/rocketTower.gd")
var rocketTowerBuildHelp = load("res://tower/rocketTower/RocketTowerBuildHelp.png")

onready var buildHelp = get_node("BuildHelp")
onready var buildHelpShape = get_node("BuildHelp/BuildHelpShape")

var lives = 0
var maxLives = 100
var money = 0
var energy = 0
var maxEnergy = 100
var buildType = 1

func _ready():
	set_process_input(true)
	set_process(true)
	
	loadLvl(get_node("/root/global").getMapNum(),1)
	
	changeMoney(1000)
	changeEnergy(100)
	changeLives(100)
	
func _input(event):
	build(event)

func _process(delta):
	if not buildHelp.is_hidden():
		#if Input.is_mouse_button_pressed(BUTTON_LEFT):
		buildHelp.set_pos(get_viewport().get_mouse_pos())
		if Col_in_UIshape_List((get_viewport().get_mouse_pos()),buildHelpShape.get_shape()):
			buildHelp.set_modulate(Color(2,1,1))
		else:
			buildHelp.set_modulate(Color(1,2,1))
			#print("baue")
			#buildHelp.set_hidden(true)

	changeEnergy(1*delta)

func build(event):
	if !buildHelp.is_hidden() && event.type == InputEvent.MOUSE_BUTTON && event.button_index == BUTTON_LEFT && event.is_pressed():
		if buildType > 0:
			build_tower(event)
		elif buildType < 0:
			build_building(event)

func build_tower(event):
		var t = packedTower.instance()
		if buildType == 1:
			t.set_script(laserTowerScript)
		if buildType == 2:
			t.set_script(schussTowerScript)
		if buildType == 3:
			t.set_script(blitzTowerScript)
		if buildType == 4:
			t.set_script(rocketTowerScript)

		if not Col_in_UIshape_List(event.pos,t.get_node("shape").get_shape()) && money >= t.cost:
			changeMoney(-t.cost)
			t.set_pos(event.pos)
			add_child(t)
			buildHelp.set_hidden(true)


func build_building(event):
		var b = packedBuilding.instance()
		if buildType == -1:
			b.set_script(generatorScript)
		if not Col_in_UIshape_List(event.pos,b.get_node("shape").get_shape()) && money >= b.cost:
			changeMoney(-b.cost)
			b.set_pos(event.pos)
			add_child(b)
			buildHelp.set_hidden(true)

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
	buildHelp.set_texture(laserTowerBuildHelp)
	buildHelpShape.set_shape(load("res://tower/laserTower/shape.tres"))
	buildHelp.set_hidden(false)
	buildType = 1
	print("Laser Tower")

func _on_SchussTowerButton_pressed():
	buildHelp.set_texture(schussTowerBuildHelp)
	buildHelpShape.set_shape(load("res://tower/schussTower/shape.tres"))
	buildHelp.set_hidden(false)
	buildType = 2
	print("SchussTower")


func _on_BlitzTowerButton_pressed():
	buildHelp.set_texture(blitzTowerBuildHelp)
	buildHelpShape.set_shape(load("res://tower/blitzTower/shape.tres"))
	buildHelp.set_hidden(false)
	buildType = 3
	print("BlitzTower")

func _on_RocketTowerButton_pressed():
	buildHelp.set_texture(rocketTowerBuildHelp)
	buildHelpShape.set_shape(load("res://tower/rocketTower/shape.tres"))
	buildHelp.set_hidden(false)
	buildType = 4
	print("RocketTower")

func _on_GeneratorButton_pressed():
	buildHelp.set_texture(generatorBuildHelp)
	buildHelpShape.set_shape(load("res://buildings/generator/shape.tres"))
	buildHelp.set_hidden(false)
	buildType = -1
	print("Generator")