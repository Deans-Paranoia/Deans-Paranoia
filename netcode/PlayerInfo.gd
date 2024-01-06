extends Control

signal makeAsDean(playerId)



func _on_make_as_dean_button_down():
	var playerName:String = $HBoxContainer/Name.text
	var playerId = playerName.get_slice(" ",1)
	makeAsDean.emit(playerId)
