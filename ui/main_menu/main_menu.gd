extends Control

func tweening_up(node):
	var tween1 = create_tween()
	tween1.tween_property(node, "position", Vector2(0, -5), 0.4).as_relative().set_trans(Tween.TRANS_ELASTIC)
func tweening_down(node):
	var tween = create_tween()
	tween.tween_property(node, "position", Vector2(0, 5), 0.2).as_relative().set_trans(Tween.TRANS_ELASTIC)
	
func _on_start_game_pressed():
	var scene = load("res://netcode/main.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	

	
	
func _on_options_pressed():
	var scene = load("res://netcode/main.tscn").instantiate()
	get_tree().root.add_child(scene)

	self.hide()
	

func _on_quit_game_pressed():
	get_tree().quit()

