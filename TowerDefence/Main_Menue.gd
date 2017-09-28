extends Node

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	pass

func _on_MenuButton_Quit_pressed():
	get_tree().quit()

func _on_KampainButton_pressed():
	print("GameMode = Kampain")
	get_node("/root/global").setGameType(1)
	get_node("MainMenue").set_hidden(true)
	get_node("LevelSelectMenue").set_hidden(false)

func _on_SurvivalButton_pressed():
	print("GameMode = Survival")
	get_node("/root/global").setGameType(2)
	get_node("MainMenue").set_hidden(true)
	get_node("LevelSelectMenue").set_hidden(false)

func _on_Button_pressed():
	get_node("MainMenue").set_hidden(false)
	get_node("LevelSelectMenue").set_hidden(true)

func _on_Level1_pressed():
	get_node("/root/global").setMapNum(1)
	print("Level: 1")
	get_tree().change_scene("res://level/Lvl.tscn")

func _on_Level2_pressed():
	get_node("/root/global").setMapNum(2)
	print("Level: 2")
	get_tree().change_scene("res://level/Lvl.tscn")
