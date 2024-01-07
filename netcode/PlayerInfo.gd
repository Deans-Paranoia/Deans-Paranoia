extends HBoxContainer
# sygnał przesyłający unikalne id gracz, która ma otrzymać rolę dziekana
signal makeAsDean(playerId)


## funkcja wywoływana w momencie kliknięcia przycisku 'uczyń dziekanem'
func _on_make_as_dean_button_down():
	var playerName:String = $Name.text
	var playerId = playerName.get_slice(" ",1)
	makeAsDean.emit(playerId)
