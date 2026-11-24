extends CharacterBody2D

var playerNumber: int = 1

var hammersmash = load("res://Sound Effects/hammersmash.mp3")
var swordswipe  = load("res://Sound Effects/swordswipe.mp3")
var jumpsound  = load("res://Sound Effects/lumora_studios-pixel-jump-319167.mp3")

var fireballScene = preload("res://Scenes/fireball.tscn")
var lightningScene = preload("res://Scenes/lightning.tscn")
var icicleScene = preload("res://Scenes/icicle.tscn")

var gravity = 800
var speed = 250
var jump = -400
var doubleJumpSize = jump * 0.75

var addToSpriteName


var canDoubleJump = false

var pnum

class timer:
	var time = 0

	func update(delta: float):
		if time > 0:
			time -= delta

	func reset(frames: int):
		time = frames / 60.0

	func can() -> bool:
		return time <= 0

# fighting system stuff
var startup = timer.new() 
var active = timer.new()
var end = timer.new()

var stun = timer.new()

enum Attacks {
	NONE,
	SHORT,
	RANGED
}

var facing = 1

var hasTime = false

var currentAttack = Attacks.NONE

enum WeaponState{
	CHARGING,
	ATTACKING,
	COOLDOWN,
	READY
}

var weapons = {
	short2 = {
		charge = 7.5,
		attack = 10,
		cooldown = 15,
		damage = 4.5
	},
	short1 = {
		charge = 5,
		attack = 15,
		cooldown = 5,
		damage = 4
	},
	range2 = {
		charge = 3,
		attack = 12,
		cooldown = 30
	},
	range1 = {
		charge = 7,
		attack = 24,
		cooldown = 10
	},
	short3 = {
		charge = 5,
		attack = 15,
		cooldown = 5,
		damage = 4
	},
	range3 = {
		charge = 3,
		attack = 12,
		cooldown = 30
	}
}

var targetVel := Vector2.ZERO

var weaponState = WeaponState.READY
var didAttack = false
var isLanding = false

var forcedDirection = 0

var inputNum = str(1)
var inNum = 1


func _ready() -> void:
	if name == "Player" :
		inputNum = str(1)
		inNum = 1
		print(Global.playerNumber)
		playerNumber = Global.playerNumber
		addToSpriteName = ""
	else:
		inputNum = str(2)
		inNum = 2
		playerNumber = Global.player2Number
		addToSpriteName = "2"
	
	pnum = str(playerNumber)
	
	if playerNumber == 3:
		$AnimatedSprite2D.position.x = -4
		$AnimatedSprite2D.position.y = -16

		$"Weapon/Spear".disabled = false
	else:
		$AnimatedSprite2D.position.x = 7
		$AnimatedSprite2D.position.y = 0

		$"Weapon/Short Melee 1".disabled = false
		$"Weapon/Short Melee 2".disabled = false
		$"Weapon/Short Melee 3".disabled = false
	
	# fixes shader param issue
	$AnimatedSprite2D.material = $AnimatedSprite2D.material.duplicate()

	$AnimatedSprite2D.play("idle" + pnum + addToSpriteName)

	set_physics_process(false)
	
	$"Intro Top".visible = true
	$"Intro Base".visible = true

	$"Intro Top".play(pnum)
	$"Intro Base".play("default")

	# to fix landing animation
	$AnimatedSprite2D.connect("animation_finished", func ():
		isLanding = false)

	await $"Intro Top".animation_finished

	$"Intro Top".queue_free()
	$"Intro Base".queue_free()

	set_physics_process(true)


func getCollider():
	if $Weapon.has_overlapping_bodies():
		for body in $Weapon.get_overlapping_bodies():
			if body.name.begins_with("Player") and not body.name == name:
				return body

	return null


func fight():
	if currentAttack == Attacks.NONE and weaponState == WeaponState.READY:
		if Input.is_action_just_pressed("short" + inputNum):
			$AnimatedSprite2D.play("short" + pnum + addToSpriteName)
			startup.reset(weapons["short" + pnum].charge)
			currentAttack = Attacks.SHORT
			weaponState = WeaponState.CHARGING
			forcedDirection = 1 if $AnimatedSprite2D.flip_h else -1
			print("charging")

		if Input.is_action_just_pressed("range" + inputNum):
			$AnimatedSprite2D.play("range" + pnum + addToSpriteName)
			startup.reset(weapons["range" + pnum].charge)
			forcedDirection = 1 if $AnimatedSprite2D.flip_h else -1
			currentAttack = Attacks.RANGED
			weaponState = WeaponState.CHARGING
	
	if weaponState == WeaponState.CHARGING and startup.can():
		weaponState = WeaponState.ATTACKING
		print("attacking")
		if currentAttack == Attacks.SHORT:
			active.reset(weapons["short" + pnum].attack)
			var audio = AudioStreamPlayer.new()
			if playerNumber == 1:
				audio.stream = swordswipe
				audio.volume_db = 5

			else:
				audio.stream = hammersmash
			add_child(audio)
			audio.play()
			audio.connect("finished", func():
				audio.queue_free())
		else:
			active.reset(weapons["range" + pnum].attack)

	if weaponState == WeaponState.ATTACKING:
		if currentAttack == Attacks.SHORT:
			var player = getCollider()

			if not player == null and not currentAttack == Attacks.NONE and not didAttack:
				didAttack = true

				if Global.isMultiplayer:
					var id = player.get_parent().name
					Global.emit("hitPlayer", id, 3, 1500 if $AnimatedSprite2D.flip_h else -1500, -1500, 0)
				else:
					Global.remove_hp(1 if inNum == 2 else 2, weapons["short" + pnum].damage)
					player.targetVel.y = -1500
					player.targetVel.x = 1500 if $AnimatedSprite2D.flip_h else -1500
		else:
			if not didAttack:
				didAttack = true
				if playerNumber == 1:
					var fireball = fireballScene.instantiate()
					get_parent().add_child(fireball)

					var currDurr = 1 if $AnimatedSprite2D.flip_h else -1

					fireball.position = position + Vector2(currDurr * 20, -10)

					fireball.direction = currDurr
				elif playerNumber == 2:
					var lightning = lightningScene.instantiate()
					get_parent().add_child(lightning)

					var currDurr = 1 if $AnimatedSprite2D.flip_h else -1

					lightning.position = position + Vector2(currDurr * 150, -30)
				elif playerNumber == 3:
					await get_tree().create_timer(0.1).timeout
					var icicle = icicleScene.instantiate()
					icicle.shootDirection = -1 if $AnimatedSprite2D.flip_h else 1

					icicle.position = position + Vector2(icicle.shootDirection * -8, -20)

					if icicle.shootDirection < 0:
						icicle.position.x += 20

					get_parent().add_child(icicle)


	
	if weaponState == WeaponState.ATTACKING and active.can():
		didAttack = false
		print("on cooldown")
		weaponState = WeaponState.COOLDOWN
		if currentAttack == Attacks.SHORT:
			end.reset(weapons["short" + pnum].cooldown)
		else:
			end.reset(weapons["range" + pnum].cooldown)
	
	if weaponState == WeaponState.COOLDOWN and end.can():
		print("cooldown over")
		weaponState = WeaponState.READY
		currentAttack = Attacks.NONE


var isJumping = false

func _physics_process(delta: float) -> void:
	startup.update(delta)
	end.update(delta)
	active.update(delta)
	stun.update(delta)
	
	if stun.can():
		fight()

	var direction = Input.get_axis("left" + inputNum, "right" + inputNum) * speed

	if not stun.can():
		direction = 0

	if not is_on_floor():
		direction *= 0.75

		if $"Land Cast".is_colliding() and velocity.y > 200 and not isLanding:
			$AnimatedSprite2D.play("land" + pnum + addToSpriteName)
			isLanding = true

	if currentAttack == Attacks.NONE or weaponState == WeaponState.READY or weaponState == WeaponState.COOLDOWN:
		forcedDirection = 0

	targetVel = lerp(targetVel, Vector2.ZERO, 0.2)

	if direction != 0:
		if is_on_floor() and currentAttack == Attacks.NONE and weaponState == WeaponState.READY and not didAttack and not isLanding:
			$AnimatedSprite2D.play("run" + pnum + addToSpriteName)
		velocity.x = lerp(velocity.x, direction, 0.15)
	else:
		if is_on_floor() and currentAttack == Attacks.NONE and weaponState == WeaponState.READY and not didAttack and not isLanding:
			$AnimatedSprite2D.play("idle" + pnum + addToSpriteName)
		velocity.x = lerp(velocity.x, 0.0, 0.15)

	if direction > 0 and forcedDirection != -1:
		$AnimatedSprite2D.flip_h = true
		$Weapon.scale.x = -1
		$Weapon.position.x = 18
		facing = 1
		if playerNumber == 3:
			$AnimatedSprite2D.position.x = 22
		$AnimatedSprite2D.offset.x = 5
	elif direction < 0 and forcedDirection != 1:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.offset.x = -7
		facing = -1
		if playerNumber == 3:
			$AnimatedSprite2D.position.x = -4
		$Weapon.scale.x = 1
		$Weapon.position.x = -4


	if Input.is_action_just_pressed("up" + inputNum):
		if is_on_floor() or canDoubleJump:
			var audio = AudioStreamPlayer.new()
			audio.stream = jumpsound
			add_child(audio)
			audio.play()
			audio.connect("finished", func():
				audio.queue_free())

		if is_on_floor():
			isJumping = true
			$AnimatedSprite2D.play("jump" + pnum + addToSpriteName)
			canDoubleJump = true
			velocity.y = jump
		elif canDoubleJump:
			$AnimatedSprite2D.play("double_jump" + pnum + addToSpriteName)
			canDoubleJump = false
			velocity.y = doubleJumpSize

	if not is_on_floor() and Input.is_action_just_released("up" + inputNum) and canDoubleJump:
		velocity.y *= 0.5

	velocity.y += gravity * delta

	velocity += targetVel

	move_and_slide()

	velocity -= targetVel

	fight()
