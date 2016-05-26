
extends PathFollow2D

export var speed = 50
export var dmg = 1
var lp = 100
var loot = 10

var offset = 0
onready var curve_length = get_parent().get_curve().get_baked_length()
onready var level = get_node("/root/Level")
onready var health = get_node("rotFix/healthbar")

func _ready():
	set_process(true)
	health.set_max(lp)
	health.set_value(lp)

func set_speed(sp):
	speed = sp
func set_health(hlth):
	lp = hlth
func set_loot(lt):
	loot = lt
func _process(delta):
	offset += delta * speed
	set_offset(offset)
#	print(offset)
#	print(get_parent().get_curve().get_baked_length())
	if curve_length < offset:
		#make demage
		level.changeLives(-dmg)
		queue_free()
	
		
func dealDMG(dmg):
	health.set_value(health.get_value() - dmg)
	if health.get_value() <= 0:
		level.changeMoney(loot)
		queue_free()