extends Spatial



var min_interval = 10
var max_interval = 12
var interval = 0
var last_z = 0

var hole_scene = preload("res://Object/Hole.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
var player:PlayerStack
func _ready():
	player = get_tree().current_scene.find_node("PlayerStack")

func _process(_delta):
	var diff = player.scroll.z-last_z
	if diff >= interval:
		spawn(diff-interval)
		last_z = player.scroll.z

var holes = []
var pity_counter = 0
const pity_amount = 1
func spawn(offset_z:float):
	var num = randi()%4 + 1
	interval = rand_range(min_interval, max_interval) * (3+num)/4
	var used_shapes = []
	var r = range(num)
	if randi()%2==0:
		r.invert()
	for i in r:
		var hole = hole_scene.instance()
		var rand_x = rand_range(-4, 4)/num
		var new_x = rand_x - 20/2 + 20.0*(i+0.5)/num
		hole.scroll_pos = Vector3(new_x, 0, player.scroll.z + 90 + rand_range(-4, 4))
		holes.append(hole)
		hole.scroll_pos.z -= offset_z
		add_child(hole)
		while hole.shape in used_shapes:
			hole.set_random_shape()
		used_shapes.append(hole.shape)
		if pity_counter == 0 and player.shapes != []:
			hole.set_shape(player.shapes[randi()%len(player.shapes)].shape)
			pity_counter = pity_amount
		else:
			pity_counter -= 1

