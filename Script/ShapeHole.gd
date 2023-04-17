class_name ShapedHole
extends ShapeObject

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
#	scroll_pos = Vector3(rand_range(-5, 5), 0, player.scroll.z + 50)
	set_random_shape()
	._ready()
	._process(0)
	get_active_material(0).next_pass.set_shader_param("shapeheight", shapeheight)
	get_active_material(0).next_pass.next_pass.set_shader_param("shapeheight", shapeheight)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	._process(delta)
	get_active_material(0).set_shader_param("alpha", pow(clamp(1.25 - translation.z/90, 0, 1),2))
	get_active_material(0).next_pass.next_pass.set_shader_param("alpha", pow(clamp(1.25 - translation.z/90, 0, 1),2))
	if enabled:
		player.check(self, delta)
		if translation.z < -20:
			queue_free()
	visible = true

export var enabled := true
