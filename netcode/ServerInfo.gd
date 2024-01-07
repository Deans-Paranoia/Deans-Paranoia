extends HBoxContainer

signal joinGame(ip)

## funkcja wywoływana w momencie naciśnięcia przycisku dołączania do instniejącego serwera
func _on_button_button_down():
	if $ip.text != "":
		print($ip.text)
		joinGame.emit($ip.text)
	
	pass # Replace with function body.
