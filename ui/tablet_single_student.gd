## Klasa odpowiedzialna za obsługę obiektu HBoxContainer
extends HBoxContainer

## Zmienna przechowująca stan zaznaczenia
var isChecked

## Referencja do ikony checkmark
@onready var checkmark = load("res://ui/deans_tablet/checkmark.png")

## Referencja do ikony krzyżyka
@onready var cross = load("res://assets/cross.png")

## Funkcja wywoływana w momencie naciśnięcia przycisku
func _on_button_button_down():
	# Sprawdzenie aktualnego stanu zaznaczenia
	if isChecked:
		# Zmiana ikony na krzyżyk, jeżeli był zaznaczony
		$Button.icon = cross
		isChecked = false
	else:
		# Zmiana ikony na checkmark, jeżeli nie był zaznaczony
		$Button.icon = checkmark
		isChecked = true
