
extends Path2D

export var frequenz = 10.0
export var typ = 0
export var anzahl = 30

var packedGegner = load("res://gegner/gegner.tscn")
var counter = 0
var timer = Timer.new()
func _ready():

	timer.set_wait_time(frequenz)
	timer.set_autostart(true)
	timer.connect("timeout",self,"spawnGegner")
	set_process(true)

func spawnGegner():
	counter += 1
	
	if counter >= anzahl:
		timer.disconnect("timeout",self,"spawnGegner")
		timer.free()
	
func get_GegnerWithProperties(id):
	g = packedGegner.instance()
	if id == 1:
		g.speed = 50
		g.get_child("Sprite").set_texture(load("res://gegner/gegnerLv1.png"))
		
	if id == 2:
		
		

