extends Node

onready var bot = get_node("bot")
onready var top = bot.get_node("top")
onready var level = get_node("/root/Level")

var botTex = load("res://buildings/generator/Generator.png")
var topTex = null
var shape = load("res://buildings/generator/shape.tres")
var energyProduction = 20
var cost = 20
var lv = 1

var timer = Timer.new()

func _ready():
	bot.set_texture(botTex)
	top.set_texture(topTex)
	get_node("shape").set_shape(shape)
	add_child(timer)
	timer.set_wait_time(1)
	timer.start()
	timer.connect("timeout",self,"generate")
	get_node("shape").add_to_group("UIshapes")

func generate():
	level.changeEnergy(energyProduction)