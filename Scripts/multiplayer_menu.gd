extends Node2D

const multiplayerRoomScene = preload("res://Scenes/MultiplayerRoom.tscn")

func createRoom() -> void:
	var roomName = $GUI/VBoxContainer2/LineEdit.text

	Global.emit("createRoom", roomName)

	var multiplayerRoom = multiplayerRoomScene.instantiate()
	multiplayerRoom.init(roomName, joinRoom, true)
	$GUI/OpenRooms.add_child(multiplayerRoom)
	
func joinRoom(roomName: String) -> void:
	print("here")

func _ready() -> void:
	$GUI/VBoxContainer/CreatRoom.connect("pressed", createRoom)

	Global.on("createRoom", func(roomName):
		var multiplayerRoom = multiplayerRoomScene.instantiate()
		multiplayerRoom.init(roomName, joinRoom)
		$GUI/OpenRooms.add_child(multiplayerRoom))
