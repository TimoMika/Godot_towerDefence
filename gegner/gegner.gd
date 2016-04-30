
extends PathFollow2D

# member variables here, example:
# var a=2
# var b="textvar"
var offset = 0
onready var curve_length = get_parent().get_curve().get_baked_length()
export var speed = 50
export var dmg = 1
var lp = 100;
onready var health = get_node("rotFix/healthbar")

func _ready():
	set_process(true)
	health.set_max(lp)
	health.set_value(lp)

func set_speed(sp):
	speed = sp
func set_health(hlth):
	lp = hlth
	
func _process(delta):
	offset += delta * speed
	set_offset(offset)
#	print(offset)
#	print(get_parent().get_curve().get_baked_length())
	if curve_length < offset:
		#make demage
		#global.lives -= dmg
		queue_free()
	if health.get_value() <= 0:
		#print("TOOOOOOOT")
		free()
func dealDMG(dmg):
	health.set_value(health.get_value() - dmg)