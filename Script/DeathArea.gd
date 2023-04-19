extends Area

var player

func _ready():
	player = get_tree().current_scene.find_node("PlayerStack")
	connect("body_entered", self, "body_entered")
	connect("body_exited" , self, "body_exited" )

var bodies := []
func body_entered(body):
	bodies.append(body)
	check_loss()
func body_exited(body):
	bodies.erase(body)
	check_loss()

var pending_collapse = false
func check_loss():
	pending_collapse = false
	if player.shapes == []:
		return
	for body in bodies:
		if body == player.shapes[0]:
			continue
		elif body in player.shapes:
			pending_collapse = true


var collapse_counter = 0
const COLLAPSE_THRESH = 0.07
func _physics_process(delta):
	if pending_collapse:
		collapse_counter += delta
		if collapse_counter > COLLAPSE_THRESH:
			if player.can_collapse:
				player.collapse()
	elif collapse_counter > 0:
		collapse_counter -= delta*4
	else:
		collapse_counter = 0
