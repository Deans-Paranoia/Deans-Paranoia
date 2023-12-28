extends HBoxContainer
signal host_down(ip)

func _on_button_button_down():
	host_down.emit($Ipv4.text)
