extends ColorfulMeshInstance

onready var game_manager = get_tree().current_scene.find_node("PlayerStack")
func _process(_delta):
	if game_manager.dark_theme:
		get_active_material(0).set_shader_param("base_color_b", Color(0.10, 0.09, 0.11))
		get_active_material(0).set_shader_param("top_color_b", Color(0.09,0.10,0.11))
	else:
		get_active_material(0).set_shader_param("base_color_b", Color(0.94, 0.90, 0.95))
		get_active_material(0).set_shader_param("top_color_b", Color(0.98,0.996,1.0))
