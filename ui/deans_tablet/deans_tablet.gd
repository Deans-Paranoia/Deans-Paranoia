#trzeba dorobić wyświetlanie ile zostało nieuków
extends CanvasLayer
@onready var single_scene = load("res://ui/deans_tablet/tablet_single_student.tscn")
func _ready():
	var i = 1
	print(str(globalScript.usedNames.size()))
	for j in globalScript.usedNames:
		
		var scene = single_scene.instantiate()
		scene.get_node("Label").text = str(j)
		if i%2 ==1:
			get_node("$Tablet/ReferenceRect/VBoxContainer").add_child(scene)
		else:
			get_node("$Tablet/ReferenceRect/VBoxContainer2").add_child(scene)
		i+=1
