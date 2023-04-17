class_name GameManagerCore
extends Spatial


func play_sound(soundname):
	var chime = AudioStreamPlayer.new()
	var stream = AudioStreamRandomPitch.new()
	stream.set_audio_stream(load("res://Sound/"+soundname+".wav"))
	chime.stream = stream
	add_child(chime)
	chime.play()

var current_hue = randf()
export var start_sound = "startup"
func _ready():
	play_sound(start_sound)
	set_color(current_hue)

var base_color = Color.black
var top_color  = Color.white
var hole_color = Color.white
func set_color(hue):
	if dark_theme:
		base_color = Color.from_hsv(hue, 0.6, 0.45)
		top_color = Color.from_hsv(hue+0.1, 0.4, 0.55)
		hole_color = Color(0.12, 0.13, 0.14);
	else:
		base_color = Color.from_hsv(hue-0.1, 0.4, 0.74)
		top_color = Color.from_hsv(hue+0.1, 0.35, 0.83)
		hole_color = Color(-0.03, -0.03, -0.02)

var dark_theme = false
