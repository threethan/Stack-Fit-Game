extends Button

onready var game_manager = get_tree().current_scene.find_node("PlayerStack")

# Called when the node enters the scene tree for the first time.

func _pressed():
	var interface = get_tree().current_scene.find_node("Interface")
	game_manager.set_battery_saver(not game_manager.battery_saver)
	interface.save_data()
	#get_tree().paused = false
	game_manager._physics_process(0)
	game_manager._physics_process(0)
	
func _process(_delta):
	text = "Battery Saver: On" if game_manager.battery_saver else "Battery Saver: Off"
