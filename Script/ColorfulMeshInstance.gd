class_name ColorfulMeshInstance
extends MeshInstance

var colorsource#:PlayerStack
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	colorsource = get_tree().current_scene.find_node("PlayerStack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var mat = get_active_material(0)
	mat.set_shader_param("base_color", colorsource.base_color)
	mat.set_shader_param("top_color" , colorsource.top_color )
	mat.set_shader_param("hole_color", colorsource.hole_color )
	mat.set_shader_param("dark_theme", colorsource.dark_theme )
	while mat.next_pass:
		mat = mat.next_pass
		mat.set_shader_param("base_color", colorsource.base_color)
		mat.set_shader_param("top_color" , colorsource.top_color )
		mat.set_shader_param("hole_color", colorsource.hole_color )
		mat.set_shader_param("dark_theme", colorsource.dark_theme )
