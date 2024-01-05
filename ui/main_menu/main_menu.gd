## Klasa Menu - skrypt obsługujący menu główne gry.

extends Control

func tweening_up(node):
	## Parametry: node - element GUI
	## Return: None
	## Funkcja animująca wznoszenie elementu GUI.
	var tween1 = create_tween()
	tween1.tween_property(node, "position", Vector2(0, -5), 0.4).as_relative().set_trans(Tween.TRANS_ELASTIC)

func tweening_down(node):
	## Parametry: node - element GUI
	## Return: None
	## Funkcja animująca opadanie elementu GUI.
	var tween = create_tween()
	tween.tween_property(node, "position", Vector2(0, 5), 0.2).as_relative().set_trans(Tween.TRANS_ELASTIC)
	
func _on_host_game_pressed():
	## Funkcja obsługująca naciśnięcie przycisku "Host Game".
	# Tworzenie instancji sceny głównej gry.
	var scene = load("res://netcode/main.tscn").instantiate()
	
	# Ustawienie flagi informującej, że gracz jest gospodarzem.
	scene.get_node("ServerBrowser").is_host = true
	
	# Dodanie sceny do drzewa węzłów.
	get_tree().root.add_child(scene)
	
	# Ukrycie bieżącego menu.
	self.hide()

func _on_join_game_pressed():
	## Funkcja obsługująca naciśnięcie przycisku "Join Game".
	# Tworzenie instancji sceny głównej gry.
	var scene = load("res://netcode/main.tscn").instantiate()
	
	# Dodanie sceny do drzewa węzłów.
	get_tree().root.add_child(scene)
	
	# Ukrycie bieżącego menu.
	self.hide()

func _on_options_pressed():
	## Funkcja obsługująca naciśnięcie przycisku "Options".
	# Tworzenie instancji sceny głównej gry.
	var scene = load("res://netcode/main.tscn").instantiate()
	
	# Dodanie sceny do drzewa węzłów.
	get_tree().root.add_child(scene)

	# Ukrycie bieżącego menu.
	self.hide()

func _on_quit_game_pressed():
	## Funkcja obsługująca naciśnięcie przycisku "Quit Game".
	# Wyjście z gry.
	get_tree().quit()
