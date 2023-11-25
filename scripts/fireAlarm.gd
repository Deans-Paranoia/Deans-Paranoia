extends StaticBody2D

signal player_entered_fire_alarm_zone

var useable: bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func use_alarm():
	useable = false

func _on_area_2d_body_entered(body):
	player_entered_fire_alarm_zone.emit()
