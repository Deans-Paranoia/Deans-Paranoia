extends Sprite2D

var teksturaPoUzyciu = preload("res://assets/alarm-sabotaged.png")

func _on_fire_alarm_zmien_teksture():
	change_texture.rpc()
	change_texture()

@rpc("any_peer","call_remote")
func change_texture():
	texture = teksturaPoUzyciu # Zmiana tekstury po wcisnieciu alarmu
