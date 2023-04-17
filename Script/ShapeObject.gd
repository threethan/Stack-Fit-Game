class_name ShapeObject
extends ColorfulMeshInstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const shapeheight := 1
var shapeslib:MeshLibrary = preload("res://ShapesLib.tres")
	
func set_random_shape():
	if "allowed_shapes" in player:
		var limiter = (randi() % player.allowed_shapes/2+1)*2
		set_shape(randi() % limiter % len(shapeslib.get_item_list()))
	else:
		set_shape(randi() % len(shapeslib.get_item_list()) % len(shapeslib.get_item_list()))

var shape
func set_shape(id:int):
	shape = id
	mesh = shapeslib.get_item_mesh(id)
	
var follow_scroll = true

# Called when the node enters the scene tree for the first time.
var player#:PlayerStack
var scroll_pos:=Vector3.ZERO

func _ready():
	scale = Vector3(2.5, shapeheight, 2.5)
	player = get_tree().current_scene.find_node("PlayerStack")

func _process(_delta):
	if follow_scroll and "scroll" in player:
		translation = scroll_pos - player.scroll
