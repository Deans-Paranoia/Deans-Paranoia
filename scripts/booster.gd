extends Node2D

func on_boost_requested():
	# funkcja usuwajaca booster po jego zebraniu
	queue_free()

