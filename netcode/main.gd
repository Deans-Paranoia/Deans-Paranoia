# Klasa main - skrypt obsługujący połączenie z serwerem.
extends Control
signal current_player(id)
signal isServer
signal gameStart
@export var Address = ""
@export var Port = 8909
@onready var single_ip_info = load("res://ui/single_ip_info.tscn")
var peer
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	$ServerBrowser.joinGame.connect(joinByIp)
	var panel = get_node("ServerBrowser/ip_panel")
	for i in IP.get_local_interfaces():
		var single_ip_info_instance = single_ip_info.instantiate()
		single_ip_info_instance.name =  str(i.friendly)
		single_ip_info_instance.get_node("Network Name").text = str(i.friendly)
		single_ip_info_instance.get_node("Ipv4").text = str(i.addresses[1])
		single_ip_info_instance.host_down.connect(_on_host_button_down)
		panel.get_node("VBoxContainer").add_child(single_ip_info_instance)
	pass	

## Parametry: id - unikalny numer generowany losowo podczas nawiązywania połączenia z seweren
## Return: None
## Funkcja informująca o nowym graczu, który dołączył do jako peer, wywołuje się gdy jest emitowany sygnał wbudowany 'peer_connected'
func peer_connected(id:int):
	print("Player connected " + str(id))
		
## Parametry: id - unikalny numer generowany losowo podczas nawiązywania połączenia z seweren
## Return: None
## Funkcja informująca o graczu, który rozłączył się jako peer, wywołuje się gdy jest emitowany sygnał wbudowany 'peer_connected'
func peer_disconnected(id:int):
	print("Player disconnected " + str(id))
	globalScript.Players.erase(id)
	
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()
## Funkcja informująca o graczu, który połączył się do serwera klikając przycisk dołączenia do gry, wywołuje się gdy jest emitowany sygnał wbudowany 'connected_to_server'
func connected_to_server():
	print("Connected to server")
	SendPlayerInformation.rpc_id(1, "Player " + str(globalScript.Players.size()+1), multiplayer.get_unique_id() )
	var scene = load("res://netcode/waiting_room.tscn").instantiate()
	
	current_player.connect(scene.on_current_player)
	current_player.emit( multiplayer.get_unique_id())
	get_tree().root.add_child(scene)
## Funkcja informująca o graczu, któremu nie udało się dołączyć do gry. Wywołuje się gdy jest emitowany sygnał wbudowany 'connection_failed
func connection_failed():
	print("Connection failed")
## Parametry: name - nazwa gracza który dołączył do gry, id - unikalny numer generowany losowo podczas nawiązywania połączenia z seweren
## Return: None
## Funkcja wysyłająca informacje o graczu, który połączył się do serwera. Funkcja zapisuje informacje o graczu w skrypcie globalnym
@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !globalScript.Players.has(id):
		globalScript.Players[id] = {
			"name": name,
			"id": id,
			"fakeName":""
		}
	if multiplayer.is_server():
		for i in globalScript.Players:
			SendPlayerInformation.rpc(globalScript.Players[i].name, i)
##funkcja wywoływana w momencie rozpoczęcia gry, wyświetla mapę na ekranach graczy
@rpc("any_peer","call_remote")
func StartGame():
	var sceneMain = load("res://map/map.tscn").instantiate()
	self.hide()
	#print(control)
	var rooms = get_tree().get_nodes_in_group("room")
	for i in rooms:
		i.hide()
	get_tree().root.add_child(sceneMain)
## Return: bool
## funkcja wywołująca wbudowane metody multiplayer API, funkcja ta sprawia, że inni użytkownicy mogą zobaczyć serwer
func hostGame() -> bool:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(Port,8)
	if error != OK:
		print("Cannot host: " + str(error))
		return false
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players...")
	var scene:Node = load("res://netcode/waiting_room.tscn").instantiate()
	var node:Button = scene.get_node("StartGame")
	node.disabled = false
	scene.button_pressed.connect(on_start_game)
	scene.dean_picked.connect(on_update_id)
	isServer.connect(scene.enable_dean_change)
	get_tree().root.add_child(scene)
	isServer.emit()
	self.hide()
	return true
## funkcja zapisuje informacje o nowo wybranym dziekanie do skryptu globalnego
@rpc("any_peer","call_local")
func update_dean_id(id):
	globalScript.deanId = int(id);
## funkcja wywoływana w momencie wybrania innej osoby, która ma mieć rolę dziekana
func on_update_id(id):
	update_dean_id.rpc(id)
## funkcja wywoływana w momencie kliknięcia przycisku stworzenia gry uruchamia niezbędne sygnały sprawdzające zachowanie graczy w poczekalni
func _on_host_button_down(ip):
	if $ServerBrowser.setBroadcastAddress(ip):
		if hostGame():
			get_node("ServerBrowser/ip_panel").queue_free()
			$ServerBrowser.setupBroadcast("Dean's Paranoia")
				
		pass # Replace with function body.
## funkcja wywoływana w momencie kliknięcia przycisku dołączenia do serwera
func _on_join_button_down():
	joinByIp(Address)
	pass # Replace with function body.
## funkcja sprawdzająca czy można dołąćzyć do serwera, jeśli można, to dołącza
func joinByIp(ip):
	if $ServerBrowser.playerCount <8:
		peer = ENetMultiplayerPeer.new()
		self.hide()
		peer.create_client(ip,Port)
	
		peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
		multiplayer.set_multiplayer_peer(peer)
	else:
		for i in $ServerBrowser/VBoxContainer.get_children():
			i.get_node("Button").text = "room is full"
## funkcja wywoływana po kliknięciu przycisku rozpoczęcia gry
func on_start_game():
	for i in globalScript.Players:
		if i != globalScript.deanId:
			
			var rand = RandomNumberGenerator.new()
			var name_number = rand.randi() % globalScript.studentsNames.size()
			signName(name_number,i)
			signName.rpc(name_number,i)
			
	StartGame.rpc()
	StartGame()
	pass
## funkcja przypisująca graczowi imię z pośród wszystkich dostępnych imion studentów
@rpc("any_peer","call_remote")
func signName(name_number,i):
	globalScript.Players[i].fakeName = globalScript.studentsNames[name_number]
	globalScript.remove_name(name_number)
