extends Node2D
#sygnały idą do map.gd
signal noteTask(isVisible)
signal computerTask(isVisible)
signal walkingTask(isVisible)
@onready var map = get_tree().root.get_node("Map")
func _ready():
	noteTask.connect(map.npcs_notes)
	computerTask.connect(map.npcs_computer)
	walkingTask.connect(map.npcs_walking)
func _on_notes_area_notifier_screen_entered():
	noteTask.emit(true)


func _on_notes_area_notifier_screen_exited():
	noteTask.emit(false)


func _on_computer_area_notifier_screen_entered():
	computerTask.emit(true)


func _on_computer_area_notifier_screen_exited():
	computerTask.emit(false)
	


func _on_walking_notifier_screen_entered():
	walkingTask.emit(true)


func _on_walking_notifier_screen_exited():
	walkingTask.emit(true)
