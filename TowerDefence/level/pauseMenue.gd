extends Panel


func _ready():
	pass


func _on_ResumeButton_pressed():
	get_tree().set_pause(false)
	set_hidden(true)


func _on_BackButton_pressed():
	get_tree().set_pause(false)
	get_tree().change_scene("res://Main_Menue.tscn")

