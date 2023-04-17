extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# This guy is hidden bc it sometimes causes crashes???

func _pressed():	
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

onready var last_win_size = OS.get_window_size()
func _physics_process(_delta):
	if last_win_size != OS.get_window_size():
		get_tree().reload_current_scene()

	
