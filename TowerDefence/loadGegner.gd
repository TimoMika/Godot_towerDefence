
extends Path2D

export var frequenz = 10.0
export var typ = 0
export var anzahl = 30
var map = 1
var lv = 1
var gameType = 1
var allWaveSpawned = false

var packedGegner = load("res://gegner/gegner.tscn")
var spawnFile = load("res://level/Lv" + str(map) + "/spawnFile" + str(lv) + ".gd").new()
onready var timer = get_parent().get_node("Timer")

var wL = spawnFile.waves
var current = {"wave":0,"group":0,"gegner":0}
func cWave():
	return current["wave"]
func cGroup():
	return current["group"]
func cGegner():
	return current["gegner"]

func get_newGegner(id):
	var g = packedGegner.instance()
	
	g.get_node("Sprite").set_texture(load("res://gegner/GegnerLv" + str(id) + ".png"))
	if id == 1:
		g.set_health(600)
		g.set_speed(40)
		g.set_loot(20)
	if id == 2:
		g.set_speed(90)
		g.set_health(400)
		g.set_loot(50)
	return g
	
func curve_loaded():
	if gameType == 1:
		spawnNextGroup()
	else:
		spawnNextGroup()

func spawnNextGroup():
	#print("current wave: ",cWave()," current group: ",cGroup())
	
	#reset the gegner couter when a new group starts
	current["gegner"] = 0
	
	#If not all groups did spawn (from the current wave)
	if cGroup() < wL[cWave()].size():
		startGroup()
	#if all groups did spawn and there is another wave
	elif cWave() + 1 < wL.size():
		current["wave"] += 1
		current["group"] = 0
		startGroup()
	#if all groups did spawn and there no wave left
	else:
		removeAllConnections()
		allWaveSpawned = true
		print("all waves spawned")

func startGroup():
	#print("startGroup")
	var group = wL[cWave()][cGroup()]
	#erster Gegner am anfang ohne das zeit vegangen ist
	spawnGegners(group)
	removeAllConnections()
	timer.set_wait_time(group["tick"])
	timer.set_one_shot(false)
	timer.connect("timeout",self,"spawnGegners",[group]) #let the spawnGegners Function spawn the whole group at the right time. 
	timer.start() #restart timer with new waitTime
	current["group"] += 1

func spawnGegners(group):
	#print("spawnGegner")
	#do we need more gegners in this wave ?
	if group["amount"] > cGegner():
		add_child(get_newGegner(group["type"]))
		current["gegner"] += 1
	else:
		#group is done. PAUSE, Setup the conter to start the next group/wave.
		removeAllConnections()
		timer.set_one_shot(true)
		timer.set_wait_time(group["pause"])
		timer.connect("timeout",self,"spawnNextGroup")
		timer.start() #restart timer with new waitTime
	
func removeAllConnections():
	#print("removeAllConnections")
	var l = timer.get_signal_connection_list("timeout")
	for fcn in l:
		timer.disconnect("timeout",self,fcn["method"])