extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	var t = 0.75
	var g = ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_scale 
	var dx = -200.0   
	var dy = 4.0      

	var xVelo = dx / t
	var yVelo = dy / t - 0.5 * g * t
	linear_velocity = Vector2(xVelo, yVelo)
	$AnimatedSprite2D.play("loop")

	pass # Replace with function body.

var didStunm = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation = linear_velocity.angle() + rad_to_deg(180)
	if $Area2D.has_overlapping_bodies():
		for body in $Area2D.get_overlapping_bodies():
			if body == self:
				return
			var playerNumber
			if body.name == "Player" :
				playerNumber = 1
			else:
				playerNumber = 2
			#if body.name == "Player" and not didStunm:
			if not didStunm:
				didStunm = true
				Global.remove_hp(playerNumber, 3)
				body.stun.reset(45)
	pass
