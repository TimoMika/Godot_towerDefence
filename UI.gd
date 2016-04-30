
extends Node

#var shapeChecker = RectangleShape2D.new()
onready var packedTower = load("res://tower/tower.tscn")
func _ready():
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.button_index == BUTTON_LEFT && event.is_pressed():
		var t = packedTower.instance()
		if not Col_in_UIshape_List(event.pos,t.get_node("shape").get_shape()):
			t.set_pos(event.pos)
			add_child(t)
			t.get_node("shape").add_to_group("UIshapes")

func Col_in_UIshape_List(pos,shape):
	for node in get_tree().get_nodes_in_group("UIshapes"):
#		print("transform ",node.get_parent().get_transform())
#		print("selfmade ",Matrix32(0,pos))
#		print( node.get_shape().collide(Matrix32(0,pos),shape,node.get_parent().get_transform()) )
#		print(shape.get_extents())
		print(node)
		if node.get_shape().collide(Matrix32(0,pos),shape,node.get_parent().get_transform()):
			return true
	return false