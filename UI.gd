
extends Node


onready var packedTower = load("res://tower/tower.tscn")
func _ready():
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.is_pressed():
			var t = packedTower.instance()
			add_child(t)
			t.set_pos(Vector2(event.x,event.y))
	