## Klasa odpowiedzialna za obsługę warstwy CanvasLayer
extends CanvasLayer

## Funkcja wywoływana w momencie naciśnięcia przycisku
func _on_button_button_down():
	# Wywołanie funkcji quit() dla drzewa sceny, co kończy działanie aplikacji
	get_tree().quit()
