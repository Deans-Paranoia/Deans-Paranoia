## Klasa odpowiedzialna za obsługę warstwy HBoxContainer
extends HBoxContainer

## Sygnał informujący o wyłączeniu hosta z podanym adresem IP
signal host_down(ip)

## Funkcja wywoływana w momencie naciśnięcia przycisku
func _on_button_button_down():
	# Emitowanie sygnału host_down z adresem IP przekazanym z kontrolki Ipv4
	host_down.emit($Ipv4.text)
