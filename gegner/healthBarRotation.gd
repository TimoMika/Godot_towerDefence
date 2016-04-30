
extends Node2D

func _ready():
	set_process(true)
func _process(delta):
	set_rot(-get_parent().get_rot())

