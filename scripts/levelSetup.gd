extends Node

# wczytuje globalną zmienną player_type
var player_type = Engine.get_singleton("global").player_type

# preloaduje do pamięci zwykłego gracza
@onready var player_scene = preload("res://scenes/player.tscn")
var current_player

func _ready():
	# tworzy zwykłego gracza "na wszelki"
	current_player = player_scene.instantiate()
	add_child(current_player)
	_replace_player()

func _replace_player():
	# usuwa obecnego gracza
	current_player.queue_free()

	# wczytuje i tworzy gracza zgodnie z dokonanym wyborem
	match player_type:
		"dean":
			current_player = preload("res://scenes/dean.tscn").instantiate()
		"student":
			current_player = preload("res://scenes/student.tscn").instantiate()

	add_child(current_player)
