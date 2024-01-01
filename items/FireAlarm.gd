extends Sprite2D

var teksturaPoUzyciu = preload("res://assets/alarm-sabotaged.png")

func _on_fire_alarm_zmien_teksture():
	print(texture)
	print(teksturaPoUzyciu)
	texture = teksturaPoUzyciu # Zmiana tekstury po wcisnieciu alarmu
	print(texture)
	
