extends StackedShape

# This is used for the title and icon, where shapes don't do anything.

# Overrides for icon scene, could also be used on title
export var override_hue = 0.0
export var override_shape = 0

# Set a random shape and color
func _ready():
	shape.set_random_shape()
	shape.set_color(randf())
	
	set_physics_process_internal(false)
	if override_hue != 0:
		shape.set_color(override_hue)
	if override_shape !=0:
		shape.set_shape(override_shape)
