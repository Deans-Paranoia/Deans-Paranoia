extends Button

# przenosi do sceny 'level', w której znajduje się player
func _on_button_up():
	get_tree().change_scene_to_file("res://scenes/level.tscn")
