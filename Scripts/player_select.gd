extends Node2D

var playerNum = 1
var player2Num = 2

const p1Origin = Vector2(361, 119)
const p2Origin = Vector2(195, 119)

const gap = Vector2(48, 51)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left1"):
		playerNum -= 1
	if Input.is_action_just_pressed("right1"):
		playerNum += 1
	if Input.is_action_just_pressed("up1"):
		playerNum -= 3
	if Input.is_action_just_pressed("down1"):
		playerNum += 3
	if Input.is_action_just_pressed("left2"):
		player2Num -= 1
	if Input.is_action_just_pressed("right2"):
		player2Num += 1
	if Input.is_action_just_pressed("up2"):
		player2Num -= 3
	if Input.is_action_just_pressed("down2"):
		player2Num += 3
	
	playerNum %= 9;
	playerNum += 9;
	playerNum %= 9;

	player2Num %= 9;
	player2Num += 9;
	player2Num %= 9;

	var selected1 = Vector2(playerNum % 3, playerNum / 3)
	var selected2 = Vector2(player2Num % 3, player2Num / 3)

	$"Player1 Selected".position = p1Origin + selected1 * gap
	$"Player2 Selected".position = p2Origin + selected2 * gap

	if Input.is_action_just_pressed("Set1"):
		if playerNum == 0:
			playerNum = 1
		elif playerNum == 1:
			playerNum = 0

		if player2Num == 0:
			player2Num = 1
		elif player2Num == 1:
			player2Num = 0
		Global.playerNumber = playerNum + 1
		Global.player2Number = player2Num + 1
		get_tree().change_scene_to_file("res://Scenes/Countdown.tscn")
