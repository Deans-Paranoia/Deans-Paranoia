extends Control

func tweening_up(node):
	var tween1 = create_tween()
	tween1.tween_property(node, "position", Vector2(0, -5), 0.4).as_relative().set_trans(Tween.TRANS_ELASTIC)
func tweening_down(node):
	var tween = create_tween()
	tween.tween_property(node, "position", Vector2(0, 5), 0.2).as_relative().set_trans(Tween.TRANS_ELASTIC)
	
func _on_host_game_pressed():
	var scene = load("res://netcode/main.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	

func _on_join_game_pressed():
	var scene = load("res://netcode/main.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
	
func _on_options_pressed():
	var scene = load("res://netcode/main.tscn").instantiate()
	get_tree().root.add_child(scene)

	self.hide()
	

func _on_quit_game_pressed():
	get_tree().quit()

func _on_host_game_button_down():
	tweening_down($ColorRectMenu/MarginContainer/VBoxContainer/HostGame)

func _on_host_game_button_up():
	tweening_up($ColorRectMenu/MarginContainer/VBoxContainer/HostGame)

func _on_join_game_button_down():
	tweening_down($ColorRectMenu/MarginContainer/VBoxContainer/JoinGame)


func _on_join_game_button_up():
	tweening_up($ColorRectMenu/MarginContainer/VBoxContainer/JoinGame)


func _on_options_button_down():
	tweening_down($ColorRectMenu/MarginContainer/VBoxContainer/Options)


func _on_options_button_up():
	tweening_up($ColorRectMenu/MarginContainer/VBoxContainer/Options)


func _on_quit_game_button_down():
	tweening_down($ColorRectMenu/MarginContainer/VBoxContainer/QuitGame)


func _on_quit_game_button_up():
	tweening_up($ColorRectMenu/MarginContainer/VBoxContainer/QuitGame)
