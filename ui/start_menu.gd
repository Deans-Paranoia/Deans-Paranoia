## Klasa odpowiedzialna za obsługę obiektu Node2D
extends Node2D

## Funkcja wywoływana w momencie naciśnięcia przycisku
func _on_button_button_down():
	# Ładowanie sceny "main.tscn" i tworzenie jej instancji
	var scene = load("res://netcode/main.tscn").instantiate()
	
	# Dodanie instancji sceny do korzenia drzewa sceny
	get_tree().root.add_child(scene)
	
	# Ukrycie bieżącego obiektu
	self.hide()
