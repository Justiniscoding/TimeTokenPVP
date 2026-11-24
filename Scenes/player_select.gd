extends Node2D

var playerNum = 1
var player2Num = 2
var otherPlayerNum
var otherPlayer2Num

var ogX = 83.5
var ogY = 0
var newX = 109
var newY = -40
var newX2 = 57

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left1"):
		playerNum -= 1
	if Input.is_action_just_pressed("right1"):
		playerNum += 1
	if Input.is_action_just_pressed("left2"):
		player2Num -= 1
	if Input.is_action_just_pressed("right2"):
		player2Num += 1
	
	if abs(playerNum) % 3 == 0:
		$"Player 1".position.x = newX2
		$"Player 1".position.y = newY
		otherPlayerNum = 3
	elif abs(playerNum) % 3 == 1:
		$"Player 1".position.x = ogX
		$"Player 1".position.y = ogY
		otherPlayerNum = 2
	else:
		otherPlayerNum = 1
		$"Player 1".position.x = ogX
		$"Player 1".position.y = ogY

	if abs(player2Num) % 3 == 0:
		otherPlayer2Num = 3	
		$"Player 2".position.x = -newX
		$"Player 2".position.y = newY
	elif abs(player2Num) % 3 == 1:
		otherPlayer2Num = 2
		$"Player 2".position.x = -ogX
		$"Player 2".position.y = ogY
	else:
		otherPlayer2Num = 1
		$"Player 2".position.x = -ogX
		$"Player 2".position.y = ogY
		
	$"Player 2".play("idle" + str(otherPlayer2Num) + "2")
	$"Player 1".play("idle" + str(otherPlayerNum))	
	
	if Input.is_action_just_pressed("Set1"):
		Global.playerNumber = otherPlayerNum
		Global.player2Number = otherPlayer2Num
		get_tree().change_scene_to_file("res://Scenes/Countdown.tscn")
	pass
