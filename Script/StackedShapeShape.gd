class_name StackedShapeShape
extends ShapeObject

# Get nodes
onready var effect_shape = get_node("EffectShape")
onready var effect_label = get_node("EffectShape/Label3D")
onready var ao_shape = get_node("AoShape")
onready var shadow_shape = get_node("ShadowShape")
onready var outline_shape = get_node("OutlineShape")

func _ready():
	follow_scroll = false # Follow player (parent) NOT scroll. Must be before parent ready.
	._ready()

func _process(delta):
	translation = lerp(translation, Vector3(0,0,0), delta*15)
	
	if anim_time_left > 0:
		anim_time_left -= delta/ANIM_DURATION
		var t = anim_time_left
		scroll_pos = lerp(target_scroll_pos, target_scroll_pos - offset_scroll_pos, pow(t,4))
		for m in [get_active_material(0), shadow_shape.get_active_material(0), outline_shape.get_active_material(0)]:
			m.set_shader_param("wobble", offset_scroll_pos * 0.5 * sin(t*10) * (t))
			m.set_shader_param("squish", shapeheight * (1-t))
			m.set_shader_param("fade", 1-t*t)

		var perfect = offset_scroll_pos.x == 0
		# Fade out hole's faketranslucency
		my_hole.get_active_material(0).next_pass.next_pass.set_shader_param("fade", t)
		
		# Glow FX
		effect_shape.get_active_material(0).next_pass.set_shader_param("alpha", (t*t) * (1.0 if perfect else 0.2))
		effect_shape.get_active_material(0).next_pass.set_shader_param("grow",  (1-t) * (1.5 if perfect else 0.5))
		# Text
		effect_label.modulate.a = t
		effect_label.font.extra_spacing_char = (1-t)*40-20
		# Ring
		var ring_size = 1.5 + min(combo_bonus,player.MAX_COMBO)*0.7 if perfect else 0.5
		t = 1-2*(1-t) # Speed up ring FX
		effect_shape.get_active_material(0).set_shader_param("inner", 1+ring_size-ring_size*clamp(pow(t+0.0,1), 0, 1))
		effect_shape.get_active_material(0).set_shader_param("outer", 1+ring_size-ring_size*clamp(pow(t-0.5,1), 0, 1))
		

		
		rotation = lerp(rotation, Vector3(0,0,0), 1-anim_time_left)
		
		if anim_time_left <= 0:
			my_hole.queue_free()
			queue_free()
		
		ao_shape.get_active_material(0).set_shader_param("amount", max(0, clamp(1.0-pow(0.0*0.5+0.1,1.5), 0, 0.5)*0.2+0.07)*anim_time_left*anim_time_left)
	else:
		ao_shape.get_active_material(0).set_shader_param("amount", max(0, clamp(1.0-pow(global_translation.y*0.5+0.1,1.5), 0, 0.5)*0.2+0.07))
	._process(delta)


func set_color(hue:float):
	get_active_material(0).set_shader_param("color", Color.from_hsv(hue, 0.6, 1.0))
	outline_shape.get_active_material(0).set_shader_param("color", Color.from_hsv(hue, 0.6, 1.0))
	
var anim_time_left = 0
var target_scroll_pos := Vector3()
var offset_scroll_pos := Vector3()
var my_hole
const ANIM_DURATION = 0.7
var combo_bonus = 0
func animate_away(offset, hole):
	hole.enabled = false
	follow_scroll = true
	target_scroll_pos = hole.scroll_pos
	offset_scroll_pos = offset
	scroll_pos = target_scroll_pos
	anim_time_left = 1
	my_hole = hole
	
	effect_shape.mesh = mesh
	
	effect_shape.visible = true
	if offset_scroll_pos.x == 0: # If perfect fit
		combo_bonus = player.combo_bonus-1
		if combo_bonus >= player.MAX_COMBO:
			effect_label.text = "PERFECT MAX"
		elif combo_bonus > 0:
			effect_label.text = "PERFECT +%d" % (combo_bonus)
	else:
		effect_label.visible = false
	
	remove_child(effect_shape)
	hole.add_child(effect_shape)
	
	_process(0)

func set_shape(s):
	.set_shape(s)
	shadow_shape.mesh = mesh
	ao_shape.mesh = mesh
	outline_shape.mesh = mesh
