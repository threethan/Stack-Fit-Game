class_name PlayerStack
extends GameManager

# Declare member variables here. Examples:
#var shapes = [] # Shapes in order from bottom to top
var shape_scene = load("res://Object/StackedShape.tscn")

var scroll= Vector3(0, 0, 0)
const SNAP_DIST = 3.5
const SNAP_DIST_Z = 1.5
const PERFECT_DIST = 0.5
const SCROLL_STACK_THRESH = 0.055
const SENS_MULT = Vector2(30.0, 1.0)
const MAX_STACK_SIZE = 14
const PUNISH_ABOVE = 8
const INTERP_SPEED = 1.25
const MOVE_SLANT = 0.03
const MOVE_TARGET_CAP = 8.0
const MOVE_POS_CAP = 5.0
var prev_y = null
var hue = 0
var add_snap = 0

var collapse_cooldown = 0

var scroll_cooldown = 0
const SCROLL_DELAY = 0.14
	
func add_shape():
	collapse_cooldown = 6
	play_sound(("shuffle"if randi()%2==1 else "shuffler")+str(randi()%3))
	if len(shapes) >= MAX_STACK_SIZE:
		return
	var shape:StackedShape = shape_scene.instance()
	get_parent().add_child(shape)
	if shapes != []:
		shape.translation.x = shapes[0].translation.x
		shape.translation.z = shapes[0].translation.z
	shapes.append(shape)
	shape.shape.set_random_shape()
	shape.update_y(len(shapes))
	shape.shape.set_color(hue)
	hue += 1.0/MAX_STACK_SIZE
	Input.vibrate_handheld(25*vibe_mult)

func add_shapes(num):
	for _i in range(num):
		add_shape()
		var nexts_timer = Timer.new()
		add_child(nexts_timer)
		nexts_timer.start(0.2)
		yield(nexts_timer, "timeout")

func mul_shapes(num):
	var copy = shapes.duplicate()
	for _i in range(num-1):
		for shape in copy:
			add_shape()
			if not is_instance_valid(shape):
				return
			shapes[len(shapes)-1].shape.set_shape(shape.shape.shape)
			var nexts_timer = Timer.new()
			add_child(nexts_timer)
			nexts_timer.start(0.2)
			yield(nexts_timer, "timeout")

func rem_shapes(num):
	for _i in range(num):
		shapes[0].queue_free()		
		shapes.remove(0)
		var nexts_timer = Timer.new()
		add_child(nexts_timer)
		if shapes == [] and not collapsed:
			refill()
			#collapse()
		nexts_timer.start(0.2)
		yield(nexts_timer, "timeout")


func slant(amt):
	if randi()%5 == 1:
		play_sound("slide"+str(randi()%3))
	var i = 2
	if len(shapes) > PUNISH_ABOVE:
		i += (len(shapes) - PUNISH_ABOVE)
	for shape in shapes:
		shape.add_slant(amt*i)
		i += 1

func check(target, delta):
	if shapes == []:
		return
		
	if shapes[0].shape.mesh != target.mesh:
		var diff = (target.translation - shapes[0].translation)
		if diff.length() < SNAP_DIST:
			slant(slant_amount*-diff*delta)
		return
	
	for shape in shapes:
		if shape.translation.y < 0.7: # Check if grounded
			if  abs(target.translation.z-shape.translation.z) < SNAP_DIST_Z+scroll_speed*delta \
			and abs(target.translation.x-shape.translation.x) < SNAP_DIST:
				var offset = target.translation - shape.translation
				if abs(offset.x) < PERFECT_DIST:
					offset.z = 0
					offset.x = 0
				score(offset.x == 0)
				start_animating(offset, target)
				slant(-offset*slant_amount)
				
	if shapes == [] and not collapsed:
		refill()

# Called every frame. 'delta' is the elapsed time since the previous frame.
var target_translation := Vector3.ZERO
onready var camera = get_viewport().get_camera()
onready var surface_plane = Plane(Vector3(0,1,0), 0.0)
var prev_mouse
func _process(delta):
	if collapsed:
		if scroll_speed > 0.5:
			scroll_speed = lerp(scroll_speed, 0, delta*2)
			for shape in shapes:
				shape.add_central_force(Vector3.FORWARD*-0.5*scroll_speed)
		else:
			scroll_speed = 0
	else:
		var prev_target = target_translation
#		if Input.is_action_just_pressed("debug_add"):
#			add_shape()
		if Input.is_action_just_pressed("debug_collapse"):
			collapse()
		#check_collapse()

		# Move on click
		if Input.is_mouse_button_pressed(1) and movement_allowed:

			var mouse_pos = get_viewport().get_mouse_position()
			if prev_mouse:
				var mouse_delta = mouse_pos-prev_mouse

				#var view_size = get_viewport().get_visible_rect().size
				#mouse_pos -= win_size/2
				mouse_delta *= SENS_MULT * (sensitivity+Vector2(1.5,1.5))
				#mouse_pos += view_size/2

				#var in_pos = Vector2(mouse_pos.x, camera.unproject_position(Vector3.ZERO).y)
				#var ray_normal = camera.project_ray_normal(in_pos)
				#var projected_pos = surface_plane.intersects_ray(camera.translation, ray_normal)
				#target_translation = Vector3.ZERO + Vector3(-1*mouse_pos.x/win_size.x,0,0) #Multiply is a failsafe
				target_translation.x += -1*mouse_delta.x/win_size.y
				target_translation.x = clamp(target_translation.x, -MOVE_TARGET_CAP, MOVE_TARGET_CAP)
				var abs_thresh = SCROLL_STACK_THRESH*win_size.y
				if prev_y:
					if scroll_cooldown <= 0:
						if   prev_y-mouse_pos.y < -abs_thresh:
							scroll_stack(true)
							prev_y += abs_thresh
							scroll_cooldown = SCROLL_DELAY
						elif prev_y-mouse_pos.y >  abs_thresh:
							scroll_stack(false)
							prev_y -= abs_thresh
							scroll_cooldown = SCROLL_DELAY
				else:
					prev_y = mouse_pos.y
			prev_mouse = mouse_pos
		else:
			prev_mouse = null
			prev_y = null
		var move_slant_amt = (prev_target-target_translation)*MOVE_SLANT
		if move_slant_amt.length() > delta*MOVE_SLANT*60: 
			slant(move_slant_amt)
	scroll_cooldown -= delta

	var offset = Vector3.ZERO
	if shapes != [] and not collapsed:
		offset = shapes[0].translation*Vector3(1,0,1)
	translation = lerp(translation, target_translation-offset, delta*INTERP_SPEED)
	translation.x = clamp(translation.x, -MOVE_POS_CAP-offset.x, MOVE_POS_CAP-offset.x)

	camera.translation.x = -translation.x

	scroll.z += delta * scroll_speed
	scroll.x = translation.x * 2.0

func _physics_process(_delta):
	collapse_cooldown -= 1 #Set to false when shuffling
	check_collapse()

func start_animating(offset, target):
	var animating_shape
	collapse_cooldown = 8
	animating_shape = shapes[0]
	if animating_shape.get_parent() == self:
		remove_child(animating_shape)
		get_parent().add_child(animating_shape)
	animating_shape.animate_away(offset, target)
	shapes.remove(0)
	
	target = null

const SCROLL_PUNISH = 0.05
const SHAPE_HEIGHT = 1.0
func scroll_stack(forward:=true):
	if collapse_cooldown >= 0:
		return # Make sure we check for collapses at least sometimes
	collapse_cooldown = 3
	collapse_count -= 2
	if len(shapes) <= 1: #If empty or 1 shape don't shuffle
		return
		
	var move_index = 0 if forward else len(shapes)-1
	var move_item = shapes[move_index]
	shapes.remove(move_index)
	for shape in shapes:
		shape.queue_offset.y -= SHAPE_HEIGHT if forward else -SHAPE_HEIGHT
	if forward:
		shapes.append(move_item)
		move_item.update_y(len(shapes)-1)
	else:
		shapes.insert(0, move_item)
		move_item.update_y(0)
		
	play_sound(("shuffle"if forward else "shuffler")+str(randi()%3))
	slant(Vector3(rand_range(-1,1), 0, rand_range(-1,1))*SCROLL_PUNISH)
	Input.vibrate_handheld(10*vibe_mult)


var collapse_count = 0
var can_collapse = false
func check_collapse():
	can_collapse = false
	if collapsed or collapse_cooldown > 0:
		return
	var last_y = -1.0
	for shape in shapes:
		if shape.translation.y > last_y+0.4:
			last_y = shape.translation.y
		else:
			collapse_count += 1
			if collapse_count > 8:
				can_collapse = true
			return
	collapse_count = 0
func collapse():
	Input.vibrate_handheld(800*vibe_mult) 
	collapsed = true
	for shape in shapes:
		shape.collapse()
		play_sound(("shuffle"if randi()%2==1 else "shuffler")+str(randi()%3))
	play_sound("collapse")

var movement_allowed = false

func _on_Surf_focus_entered():
	movement_allowed = true

func _on_Surf_focus_exited():
	movement_allowed = false
