tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export(PackedScene) var shape_scene_file;
#onready var shape_scene:Spatial = get_node("Shapes")#shape_scene_file.instance()
export(MeshLibrary) var out_res;
export var recheck := false setget do

func do(_0=0):
	var shape_scene:Spatial = get_node("Shapes")
	var meshes = []
	var names = []
	for shape in shape_scene.get_children():
		if "mesh" in shape:
			meshes.append(shape.mesh)
			names .append(shape.name)
	print("Found ",len(meshes), " shapes.")
	
	out_res = MeshLibrary.new()
	for i in range(len(meshes)):
		out_res.create_item(i)
		out_res.set_item_mesh(i, meshes[i])
		out_res.set_item_name(i, names[i] )
