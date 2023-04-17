extends Spatial

var player#:PlayerStack
var scroll_pos:=Vector3.ZERO

onready var label = get_node("Label")
onready var shadow = get_node("Shadow")

var count = 0
var mode = 0

var half = false
var right = false
var missed_timer

func _ready():
	visible = false
	player = get_tree().current_scene.find_node("PlayerStack")
	update()
	if half:
		scroll_pos.x = -5 if right else 5

func update():
	# Add
	if   mode == 0:
		count = randi()%3+2
		label.text = ("— +%d —" if half else "———— +%d ————")%[count]
	# Add More
	elif mode == 1:
		count = randi()%3+5
		label.text = ("— +%d —" if half else "———— +%d ————")%[count]
	# Multiply
	elif mode == 2:
		count = 2+randi()%2
		label.text = ("— x%d —" if half else "———— x%d ————")%[count]
		shadow.text = label.text
	# Subtract
	elif mode == 3:
		count = randi()%3+2
		label.text = ("— -%d —" if half else "———— -%d ————")%[count]
		shadow.text = label.text
	# Divide
	elif mode == 4:
		count = randi()%2+2
		label.text = ("— ÷%d —" if half else "———— ÷%d ————")%[count]
		shadow.text = label.text

		
	shadow.text = label.text

var animation_timer
var frame_count = 0
const shadow_opacity = 0.05
func _process(delta):
	frame_count += 1
	if frame_count == 3:
		visible = true
		
	label.modulate.a = clamp(1.25 - translation.z/90, 0, 1)
	if "scroll" in player:
		translation = scroll_pos - player.scroll
		
	if missed_timer:
		label.scale  = Vector3.ONE * (missed_timer)
		shadow.scale = Vector3.ONE * (missed_timer)
		label.modulate.a  = missed_timer
		shadow.modulate.a = missed_timer * shadow_opacity
		missed_timer -= delta*6
		if missed_timer <= 0:
			queue_free()
		return
	if animation_timer:
		label.scale  = Vector3.ONE * (3-animation_timer*2)
		shadow.scale = Vector3.ONE * (3-animation_timer*2)
		label.modulate.a  = animation_timer
		shadow.modulate.a = animation_timer * 0.05
		animation_timer -= delta*2
		if animation_timer <= 0:
			queue_free()
		return	
	
	if translation.z < 0.5:
		if half:
			if player.translation.x>0 == right:
				missed_timer = 1
				return
		if   mode == 0 or mode == 1:
			player.add_shapes(count)
		elif mode == 2:
			player.mul_shapes(count)
		elif mode == 3:
			player.rem_shapes(count)
		elif mode == 4:
# warning-ignore:integer_division
			player.rem_shapes(floor(len(player.shapes)/2))
			
		player.play_sound("chime0")
		animation_timer = 1
