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
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
	
	#if playerNumber == 3:
		#$AnimatedSprite2D.position.x = -4
		#$AnimatedSprite2D.position.y = -16
	#else:
		#$AnimatedSprite2D.position.x = 7
		#$AnimatedSprite2D.position.y = 0
	if(abs(playerNum) % 3 == 0):
		$CharacterBody2D2/AnimatedSprite2D2.position.x = newX2
		$CharacterBody2D2/AnimatedSprite2D2.position.y = newY
		otherPlayerNum = 3
	elif(abs(playerNum) % 3 == 1):
		$CharacterBody2D2/AnimatedSprite2D2.position.x = ogX
		$CharacterBody2D2/AnimatedSprite2D2.position.y = ogY
		otherPlayerNum = 2
	else:
		otherPlayerNum = 1
		$CharacterBody2D2/AnimatedSprite2D2.position.x = ogX
		$CharacterBody2D2/AnimatedSprite2D2.position.y = ogY
		
	if(abs(player2Num) % 3 == 0):
		otherPlayer2Num = 3	
		$CharacterBody2D/AnimatedSprite2D2.position.x = -newX
		$CharacterBody2D/AnimatedSprite2D2.position.y = newY
	elif(abs(player2Num) % 3 == 1):
		otherPlayer2Num = 2
		$CharacterBody2D/AnimatedSprite2D2.position.x = -ogX
		$CharacterBody2D/AnimatedSprite2D2.position.y = ogY
	else:
		otherPlayer2Num = 1
		$CharacterBody2D/AnimatedSprite2D2.position.x = -ogX
		$CharacterBody2D/AnimatedSprite2D2.position.y = ogY
		
	$CharacterBody2D/AnimatedSprite2D2.play("idle" + str(otherPlayer2Num) + "2")
	$CharacterBody2D2/AnimatedSprite2D2.play("idle" + str(otherPlayerNum))	
	
	print(otherPlayerNum, " ", otherPlayer2Num)
	
	if Input.is_action_just_pressed("Set1"):
		Global.playerNumber = otherPlayerNum
		Global.player2Number = otherPlayer2Num
		get_tree().change_scene_to_file("res://Scenes/Countdown.tscn")
	pass
