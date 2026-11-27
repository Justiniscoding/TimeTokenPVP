extends Node2D

var timeTokenScene = preload("res://Scenes/TimeToken.tscn")
var timePerToken = 10

func _ready() -> void:
	$Control/Renee.value = 100
	$Control/Boris.value = 100

	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	Global.connect("hpChange", hpChange)

func hpChange(playerNum, _amount):
	var tween: Tween = get_tree().create_tween()
	if playerNum == 2:
		tween.tween_property($Control/Renee, "value", Global.p2hp, 0.5)
		$Player2.modulate = Color8(255, 100, 100, 255)
	
		get_tree().create_timer(0.5).connect("timeout", func():
			$Player2.modulate = Color8(255, 255, 255))
	else:
		tween.tween_property($Control/Boris, "value", Global.p1hp, 0.5)
		$Player.modulate = Color8(100, 100, 255)
		get_tree().create_timer(0.5).connect("timeout", func():
			$Player.modulate = Color8(255, 255, 255))
	tween.play()

	await tween.finished
	if Global.p1hp <= 0:
		Global.player_won(2)
	elif Global.p2hp <= 0:
		Global.player_won(1)

var startDelay = 2

func _process(delta: float) -> void:
	timePerToken -= delta
	if timePerToken <= 0:
		var timeToken = timeTokenScene.instantiate()
		add_child(timeToken)
		timeToken.position.x = (randf() * 550) - 275
		timeToken.position.y = 50
		timePerToken = 10 + randf() * 8
	startDelay -= delta

	if startDelay <= 0:
		$"Time Demon".modulate.a += (delta) * 0.25
		$"Time Demon".rotation_degrees += delta * 5
	
	if $DeadZone.has_overlapping_bodies():
		for body in $DeadZone.get_overlapping_bodies():
			if body.name == "Player":
				Global.player_won(2)
			if body.name == "Player2":
				Global.player_won(1)
