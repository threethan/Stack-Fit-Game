class_name StackedShape
extends RigidBody

onready var shape = get_node("Shape")
func update_y(index:int):
	if shape:
		queue_translation = translation
		queue_translation.y = shape.shapeheight*float(index)


var queue_offset := Vector3.ZERO
var queue_translation = null
var queue_impulse := Vector3.ZERO

func animate_away(offset, hole):
	remove_child(shape)
	get_parent().add_child(shape)
	shape.animate_away(offset, hole)
	queue_free()

func _physics_process(_delta):
	if queue_offset != Vector3.ZERO:
		shape.translation -= queue_offset
		translation += queue_offset
		queue_offset = Vector3.ZERO
	if queue_impulse != Vector3.ZERO:
		linear_velocity += queue_impulse
		queue_impulse = Vector3.ZERO
	if queue_translation:
		shape.translation = translation - queue_translation
		translation = queue_translation
		queue_translation = null
func add_slant(amt):
	queue_impulse += amt*Vector3(2.0, 0.0, 0.5)

func collapse():
	get_node("CollisionShape").scale = Vector3(0.5, 1, 0.5)
	linear_velocity += Vector3(rand_range(-1,1),rand_range(-0.5,1.5),rand_range(-1,1)) * 10
	gravity_scale = 2
