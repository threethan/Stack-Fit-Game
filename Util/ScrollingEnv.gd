extends Spatial

var player

func _ready():
	player = get_tree().current_scene.find_node("PlayerStack")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translation.x = -player.scroll.x
