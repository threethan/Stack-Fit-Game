extends Button

onready var game_manager = get_tree().current_scene.find_node("PlayerStack")

# Called when the node enters the scene tree for the first time.

func _pressed():
	var interface = get_tree().current_scene.find_node("Interface")
	interface.set_dark_theme(not game_manager.dark_theme)
	interface.save_data()
	get_tree().paused = false
	unpause_counter = 2 #Unpause for 2 frames to allow colors to update
	
var unpause_counter = -1
func _process(_delta):
	text = "Light Mode" if game_manager.dark_theme else "Night Mode"
	if unpause_counter == 0:
		get_tree().paused = true
		unpause_counter = -1
	else:
		unpause_counter -=1
