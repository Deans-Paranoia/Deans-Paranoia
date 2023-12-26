extends Node2D 

var actual_value = 0
var textures = []
var can_update_value: bool = false
func _ready():
	load_textures()
	update_texture()
	
func load_textures():
	for i in range(10):
		textures.append(load("res://assets/terminal_" + str(i) + ".png"))

func update_texture():
	$Terminal/Sprite2D/Sprite2D.texture = textures[actual_value]
@rpc("any_peer","call_remote")
func use_terminal():
	actual_value += 1
	if actual_value > 9:
		actual_value = 0
	update_texture()
	
	
func _on_terminal_area_body_exited(body):
	if body.is_in_group("obstacles"):
			print("visibility change")
			can_update_value = true
			$".".visible = true
			show_terminal.rpc($".".name)
@rpc("any_peer","call_local")
func show_terminal(name):
	var terminal = get_node("../"+str(name))
	terminal.visible = true
