extends Button

# przenosi do sceny 'level', w której znajduje się player i aktualizuje globalną zmienną
func _on_button_up():
	Engine.get_singleton("Singleton").player_type = "student"
	get_tree().change_scene_to_file("res://scenes/level.tscn")

