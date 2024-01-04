extends Sprite2D

var textureAfterUsage = preload("res://assets/alarm-sabotaged.png")

func _on_fire_alarm_change_texture():
	change_texture.rpc()
	change_texture()

@rpc("any_peer","call_remote")
func change_texture():
	texture = textureAfterUsage # Zmiana tekstury po wcisnieciu alarmu
