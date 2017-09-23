
extends "res://tower/tower.gd"

var timer = Timer.new()
var tick = 0.6
var speed = 450
onready var packedProjectil = load("res://tower/schussTower/schussTowerProjectile.tscn")


func _init():
	botTex = load("res://tower/schussTower/SchussTowerBase.png")
	topTex = load("res://tower/schussTower/SchussTowerGun.png")
	shape = load("res://tower/schussTower/shape.tres")

func _ready():
	add_child(timer)
	timer.set_wait_time(tick)
	timer.start()
	timer.connect("timeout",self,"shoot")

func _process(delta):
	if level.energy >= energyCost:
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
	projectile.move_local_x(40)