extends RigidBody2D

var didStun = false


func _ready() -> void:
	lock_rotation = true

	var t = 0.4
	var g = ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_scale
	var dx = -100.0
	var dy = 4.0

	linear_velocity = Vector2(Global.shootDirection * (dx / t), dy / t - 0.5 * g * t)
	$AnimatedSprite2D.play("loop")


func _physics_process(delta: float) -> void:
	var angle = linear_velocity.angle() + rad_to_deg(180)
	$AnimatedSprite2D.rotation = angle
	$Area2D.rotation = angle          

	if didStun:
		return

	for body in $Area2D.get_overlapping_bodies():
		if body == self:
			continue

		var playerNumber = 0
		if body.name == "Player":
			playerNumber = 1
			didStun = true
			Global.remove_hp(playerNumber, 3)
			body.stun.reset(45)
		elif body.name == "Player2":  
			playerNumber = 2
			didStun = true
			Global.remove_hp(playerNumber, 3)
			body.stun.reset(45)
		elif body.name == "Map":
			print("hit ground")
			queue_free()

		
		queue_free()
		break                       
