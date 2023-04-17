extends Spatial

var min_interval = 120
var max_interval = 150
var interval = 0#150
var last_z = 0

var next_scene = preload("res://Object/NextGate.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
var player:PlayerStack
func _ready():
	player = get_tree().current_scene.find_node("PlayerStack")

func _process(_delta):
	var diff = player.scroll.z-last_z
	if diff >= interval:
		spawn(diff-interval)
		last_z = player.scroll.z

#var nexts = []
var pity_counter = 0
const pity_amount = 1
func spawn(offset_z:float):
	#print("spawn")
	interval = rand_range(min_interval, max_interval)
	#for i in range(num):
	if randi()%2 == 1:
		var l = next_scene.instance()
		l.scroll_pos = Vector3(0, 0, player.scroll.z + 90)
		l.scroll_pos.z -= offset_z
		l.half = true
		l.right = false
		var r = next_scene.instance()
		r.scroll_pos = Vector3(0, 0, player.scroll.z + 90)
		r.scroll_pos.z -= offset_z
		r.half = true
		r.right = true
		var reduce = false
		if len(player.shapes) > 2:
			reduce = randi()%10==0
		if len(player.shapes) > 4:
			reduce = randi()%7==0
		if len(player.shapes) > 6:
			reduce = randi()%5==0
		if len(player.shapes) > 8:
			reduce = randi()%3==0
		if reduce:
			interval /= 2
			while l.mode == r.mode:
				l.mode = randi()%2+3
				r.mode = randi()%2+3
		else:
			while l.mode == r.mode:
				l.mode = randi()%3
				r.mode = randi()%3

		add_child(l)
		add_child(r)

	else:
		var next = next_scene.instance()
		next.scroll_pos = Vector3(0, 0, player.scroll.z + 90 + rand_range(-4, 4))
		next.scroll_pos.z -= offset_z
		next.right = randi()%2 == 0
		next.half = randi()%3 == 0
		add_child(next)
