extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	connect("pressed", self, "play")
	get_tree().paused = true
	Engine.target_fps = 15
	
func play():
	Engine.target_fps = 0
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(load("res://Default.tscn"))
