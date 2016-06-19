
extends "res://tower/tower.gd"

var timer = Timer.new()
var tick = 2
var speed = 40
var expRad = 50
onready var packedProjectil = load("res://tower/rocketTower/rocketTowerRocket.tscn")


func _init():
	botTex = load("res://tower/rocketTower/rocketTowerBase.png")
	topTex = load("res://tower/rocketTower/rocketTowerGun.png")
	shape = load("res://tower/rocketTower/shape.tres")

func _ready():
	add_child(timer)
	timer.set_wait_time(tick)
	timer.start()
	timer.connect("timeout",self,"shoot")
	dmg = 50

func _process(delta):
	refreshRot()

func shoot():
	#print("shoot")
	if tarGeg != null && level.energy >= energyCost:
		newProjectile()
	
func newProjectile():
	level.changeEnergy(-energyCost)
	#print("projectile")
	#print("child count", get_child_count())
	var projectile = packedProjectil.instance()
	add_child(projectile)
	projectile.set_rot(top.get_rot())
