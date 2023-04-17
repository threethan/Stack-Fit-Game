class_name GameManager
extends GameManagerCore

var scroll_speed = 15.0
var slant_amount = 0.06
var collapsed = false
var allowed_shapes:= 4
var score = 0
var combo_bonus = 0
var next_timer = 0
var next_thresh = 0
var difficulty = 0
var sensitivity = Vector2(1.0,1.0)

var shapes = []

var vibe_mult = 0.4
var battery_saver = false
func set_battery_saver(on):
	vibe_mult = 0.0 if on else 0.4
	battery_saver = on
#	get_viewport().fxaa = not on


var win_size
func _physics_process(_delta):
	win_size = OS.get_window_size()
	get_viewport().size = win_size*0.7 if battery_saver else win_size

const MAX_COMBO = 3 # Cap combo bonus
const PERFECT_BASE_SCORE = 2
func score(perfect):
	if perfect:
		score += PERFECT_BASE_SCORE + min(MAX_COMBO, combo_bonus)
		combo_bonus += 1
		difficulty += 0.06 + combo_bonus * 0.03
		play_sound("chime"+str(min(combo_bonus-1+1, 3)))
		play_sound("tilep"+str(randi()%3))
		Input.vibrate_handheld((70+20*min(MAX_COMBO, combo_bonus))*vibe_mult)
	else:
		score += 1
		combo_bonus = 0
		difficulty += 0.02
		play_sound("tile"+str(randi()%3))
		Input.vibrate_handheld(30*vibe_mult)

var frame_count = 0
func _process(delta):
	if collapsed:
		return
	scroll_speed = 12 + pow(difficulty+0.5,1.3)*1.3
	frame_count += 1
	
	if (difficulty < 2.0/60.0): # Initial speed up
		scroll_speed += 10000 * pow(2.0/60.0-difficulty,1.5)
	#if next_timer > next_thresh:
#		if   len(shapes) == 0:
#			add_shapes(5)
#		elif   len(shapes) < 3:
#			add_shapes(3)
#		elif len(shapes) < 6:
#			add_shapes(2)
#		else:
#			add_shapes(1)
#		next_timer -= next_thresh
#		next_thresh = 25.0 / (difficulty*1.2+2.0)
	if frame_count == 2:
		add_shapes(3)
		
# DISABLED NEXT TIMER #
#	next_timer += delta

	difficulty += delta * 1.0/60.0 * 1.5
	
	allowed_shapes = 4+floor(difficulty/2.0)
	
	current_hue += scroll_speed * delta * 0.0001
	set_color(current_hue)
	
func refill():
	next_timer = 0
	add_shapes(3)
	difficulty += 0.2

# To be overridden by child
func add_shapes(_a):
	pass 
