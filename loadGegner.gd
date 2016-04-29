
extends Path2D

export var frequenz = 10.0
export var typ = 0
export var anzahl = 30
var map = 1
var lv = 1

var packedGegner = load("res://gegner/gegner.tscn")
var spawnFile = load("res://Level/Lv" + str(map) + "/spawnFile" + str(lv) + ".gd").new()
var wL = spawnFile.waves
onready var timer = get_parent().get_node("Timer")

var current = {"wave":0,"group":0,"gegner":0}
func cWave():
	return current["wave"]
func cGroup():
	return current["group"]
func cGegner():
	return current["gegner"]


func _ready():
	print(spawnFile.waves)
	spawnNextGroup()
	set_process(false)

func spawnNextGroup():
	print("current wave ",cWave(),"current group ",cGroup())

	current["gegner"] = 0
	
	if cGroup() < wL[cWave()].size():
		removeAllConnections()
		startGroup()
	elif cWave() + 1 < wL.size():
		current["wave"] += 1
		current["group"] = 0
		startGroup()
	else:
		removeAllConnections()
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

func spawnGegner(id):
	print("spawnGegner")
	if wL[cWave()][cGroup()]["amount"] > cGegner():
		add_child(get_newGegner(id))
		current["gegner"] += 1
	else:
		print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		removeAllConnections()
		timer.stop()
		timer.set_wait_time(wL[cWave()][cGroup()]["pause"])
		timer.set_one_shot(true)
		timer.connect("timeout",self,"spawnNextGroup")
		timer.start()
		current["group"] += 1

func startGroup():
	print("startGroup")
	var group = wL[cWave()][cGroup()]
	
	spawnGegner(group["type"])
	
	timer.set_wait_time(group["tick"])
	timer.set_one_shot(false)
	timer.connect("timeout",self,"spawnGegner",[group["type"]])
	timer.start()

func get_newGegner(id):
	var g = packedGegner.instance()
	
	g.get_node("Sprite").set_texture(load("res://gegner/gegnerLv" + str(id) + ".png"))
	
	if id == 1:
		g.speed = 30
	if id == 2:
		g.speed = 100
	return g
	
func removeAllConnections():
	print("removeAllConnections")
	var l = timer.get_signal_connection_list("timeout")
	for fcn in l:
		timer.disconnect("timeout",self,fcn["method"])