extends CanvasLayer


func _on_button_button_down():
	back_to_menu()
@rpc("any_peer","call_remote")
func back_to_menu():
	#delete_players.rpc()
	get_tree().quit()
	#get_tree().root.get_node("Map").queue_free()
	#get_tree().root.get_node("main/ServerBrowser").exit_tree()
	#get_tree().root.get_node("main").queue_free()
	#get_tree().root.get_node("Waiting_room").queue_free()
	#get_tree().root.get_node("StartMenu").visible = true
	#globalScript.Players = {}
	#globalScript.deanId = 0
	#for i in multiplayer.get_peers():
	#	multiplayer.multiplayer_peer.disconnect_peer(i)
	#self.hide()
	#print(str(multiplayer.get_peers().size()))
#@rpc("any_peer","call_remote")
#func delete_players():
		#get_tree().quit()
		#get_tree().root.get_node("Map").queue_free()
		#get_tree().root.get_node("main/ServerBrowser").exit_tree()
		#get_tree().root.get_node("main").queue_free()
		#get_tree().root.get_node("Waiting_room").queue_free()
		#get_tree().root.get_node("StartMenu").visible = true
		#globalScript.Players = {}
		#globalScript.deanId = 0
		#self.hide()
		
