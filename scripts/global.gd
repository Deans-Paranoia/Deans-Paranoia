extends Node

func _ready():
	# rejestruje skrypt jako singleton (umożliwia dostęp z innych skryptów)
	Engine.register_singleton("global", self)
var Players ={}
var deanId:int
var player_type: String
