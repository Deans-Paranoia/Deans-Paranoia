extends HBoxContainer

signal joinGame(ip)


func _on_button_button_down():
	if $ip.text != "":
		joinGame.emit($ip.text)
	
	pass # Replace with function body.
