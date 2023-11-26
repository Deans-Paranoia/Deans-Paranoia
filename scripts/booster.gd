extends Node2D

var cooldownDuration: float = 5.0 # Czas odnowienia boostera
var boosterActive: bool = true

func _ready():
	# dodanie boostera do grupy boosterów
	add_to_group("boosters") 

func on_boost_requested():
	# funkcja zajmująca się dezaktywacją i ponowną aktywacją boostera
	
	if boosterActive:
		# dezaktywacja boosta
		boosterActive = false
		hide()
		
		# czekanie cd
		await get_tree().create_timer(cooldownDuration).timeout
		
		# ponowna aktywacja
		boosterActive = true
		show()
