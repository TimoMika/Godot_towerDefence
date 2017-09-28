extends Node2D

onready var bot = get_node("bot")
onready var top = bot.get_node("top")

var botTex
var topTex
var shape
var tarGeg


var dmg = 10
var cost = 50
var lv = 1
var energyCost = 5
var schootRange = 200

onready var level = get_node("/root/Level")

func _ready():
	bot.set_texture(botTex)
	top.set_texture(topTex)
	set_process(true)
	get_node("shape").add_to_group("UIshapes")

func refreshRot():
	tarGeg = null

	for g in get_parent().get_node("Path").get_children():
		if g.health.get_value() > 0:
			var toGeg = g.get_pos()-get_pos()
			if (toGeg).length() < schootRange:
				tarGeg = g
				top.set_rot(-toGeg.angle_to(Vector2(1,0)))
				break
