
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("VBoxContainer/MenuButton").get_popup().connect("item_pressed", get_node("."), "level_Button_pressed")


func level_Button_pressed(lvl):
	lvl += 1
	get_node("/root/global").setMapNum(lvl)
	print("Level: ", lvl)
	get_tree().change_scene("res://level/Lvl.tscn")