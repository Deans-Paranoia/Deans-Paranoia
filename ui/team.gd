extends Control


func _on_button_button_down():
	get_node("../Team").queue_free()
