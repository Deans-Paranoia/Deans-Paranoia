## Klasa Menu - skrypt obsługujący menu główne gry.

extends Control

## Parametry: node - element GUI
## Return: None
## Funkcja animująca wznoszenie elementu GUI.
func tweening_up(node):
	var tween1 = create_tween()
	tween1.tween_property(node, "position", Vector2(0, -5), 0.4).as_relative().set_trans(Tween.TRANS_ELASTIC)

## Parametry: node - element GUI
## Return: None
## Funkcja animująca opadanie elementu GUI.
func tweening_down(node):
	var tween = create_tween()
	tween.tween_property(node, "position", Vector2(0, 5), 0.2).as_relative().set_trans(Tween.TRANS_ELASTIC)
	
## Funkcja obsługująca naciśnięcie przycisku "Host Game".
func _on_host_game_pressed():
	# Tworzenie instancji sceny głównej gry.
	var scene = load("res://netcode/main.tscn").instantiate()
	
	# Ustawienie flagi informującej, że gracz jest gospodarzem.
	scene.get_node("ServerBrowser").is_host = true
	
	# Dodanie sceny do drzewa węzłów.
	get_tree().root.add_child(scene)
	
	# Ukrycie bieżącego menu.
	self.hide()

## Funkcja obsługująca naciśnięcie przycisku "Join Game".
func _on_join_game_pressed():
	# Tworzenie instancji sceny głównej gry.
	var scene = load("res://netcode/main.tscn").instantiate()
	
	# Dodanie sceny do drzewa węzłów.
	get_tree().root.add_child(scene)
	
	# Ukrycie bieżącego menu.
	self.hide()

## Funkcja obsługująca naciśnięcie przycisku "Options".
func _on_options_pressed():
	# Tworzenie instancji sceny głównej gry.
	var scene = load("res://netcode/main.tscn").instantiate()
	
	# Dodanie sceny do drzewa węzłów.
	get_tree().root.add_child(scene)

	# Ukrycie bieżącego menu.
	self.hide()

## Funkcja obsługująca naciśnięcie przycisku "Quit Game".
func _on_quit_game_pressed():
	# Wyjście z gry.
	get_tree().quit()
