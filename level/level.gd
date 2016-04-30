
extends Node

#var shapeChecker = RectangleShape2D.new()
onready var packedTower = load("res://tower/tower.tscn")
var lives = 100
var money = 100
var energy = 100

func _ready():
	set_process_input(true)
	loadLvl(1,1)
	changeMoney(0)
func _input(event):
	build_tower(event)



func build_tower(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.button_index == BUTTON_LEFT && event.is_pressed():
		var t = packedTower.instance()
		if not Col_in_UIshape_List(event.pos,t.get_node("shape").get_shape()) && money >= t.cost:
			changeMoney(-t.cost)
			t.set_pos(event.pos)
			add_child(t)
			t.get_node("shape").add_to_group("UIshapes")
			
func Col_in_UIshape_List(pos,shape):
	for node in get_tree().get_nodes_in_group("UIshapes"):
#		print("transform ",node.get_parent().get_transform())
#		print("selfmade ",Matrix32(0,pos))
#		print( node.get_shape().collide(Matrix32(0,pos),shape,node.get_parent().get_transform()) )
#		print(shape.get_extents())
		print(node)
		if node.get_shape().collide(Matrix32(0,pos),shape,node.get_parent().get_transform()):
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
	
func changeMoney(val):
	money += val
	get_node("MoneyLabel").set_text("Money: " + str(money))