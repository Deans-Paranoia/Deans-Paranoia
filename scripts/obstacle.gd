extends Node2D

signal student_entered_obstacle_area(body)
signal student_exited_obstacle_area(body)

func _on_obstacle_body_entered(body):
	if body is CharacterBody2D:
		emit_signal("student_entered_obstacle_area", self)

func _on_obstacle_body_exited(body):
	if body is CharacterBody2D:
		emit_signal("student_exited_obstacle_area", self)
		
# Metoda do zniszczenia przeszkody
func destroy_obstacle():
	queue_free()

