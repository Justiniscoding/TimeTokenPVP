extends Area2D

var start = load("res://Sound Effects/fire ball conjure.mp3")
var middle = load("res://Sound Effects/fireball swoosh.mp3")
var end = load("res://Sound Effects/explode.mp3")

var speed = 250

var direction = 1

var timer = 0

var middleAudio

func playAudio(stream, db):
	var audio = AudioStreamPlayer.new()
	audio.stream = stream
	audio.volume_db = db
	add_child(audio)
	audio.play()
	await audio.finished
	audio.queue_free()

func _ready() -> void:
	playAudio(start, 5)
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("roll")
	middleAudio = AudioStreamPlayer.new()
	middleAudio.stream = middle
	add_child(middleAudio)
	middleAudio.play()

func _physics_process(delta: float) -> void:
	timer += delta
	
	

	if timer > 1.5:
		$AnimatedSprite2D.play("explode")
		set_physics_process(false)
		if middleAudio:
			middleAudio.stop()
		playAudio(end, 10)
		$AnimatedSprite2D.connect("animation_finished", func():
			# await get_tree().create_timer(1.25).timeout
			queue_free())
		return

	if has_overlapping_bodies():
		
		
		for body in get_overlapping_bodies():
			var playerNumber
			if body.name == "Player":
				playerNumber = 1
			else:				
				playerNumber = 2
			#if body.name == "Player2":
			$AnimatedSprite2D.play("explode")
			if middleAudio:
				middleAudio.stop()	
			playAudio(end, 10)
			set_physics_process(false)
			if Global.isMultiplayer:
				Global.emit("hitPlayer", body.get_parent().name, 5, 400 * direction, 0, 0)
			else:
				body.targetVel.x = 400 * direction
				Global.remove_hp(playerNumber, 5)
			$AnimatedSprite2D.connect("animation_finished", func():
				# await get_tree().create_timer(1.25).timeout
				queue_free())
			return


	position.x += direction * speed * delta
