extends Node2D

const origins = [
	Vector2(195, 144),
	Vector2(361, 144)
]

const TIME_PER_FRAME = 0.1

var player_nums = [0, 1]
var frame_timers = [0, 0]
var clock_frames = [0, 0]
var clock_targets = [0, 0]

func _process(delta: float) -> void:
	for i in range(0, 2):
		if frame_timers[i] > 0:
			frame_timers[i] -= delta

		if Input.is_action_just_pressed("right" + str(i + 1)):
			if player_nums[i] < 2:
				player_nums[i] += 1
			elif player_nums[i] == 4:
				player_nums[i] -= 1

		if Input.is_action_just_pressed("down" + str(i + 1)):
			if player_nums[i] == 0:
				player_nums[i] = 4
			elif player_nums[i] == 2:
				player_nums[i] = 3

		if Input.is_action_just_pressed("left" + str(i + 1)):
			if player_nums[i] > 0 and player_nums[i] < 3:
				player_nums[i] -= 1

			if player_nums[i] == 3:
				player_nums[i] += 1

		if Input.is_action_just_pressed("up" + str(i + 1)):
			if player_nums[i] == 4:
				player_nums[i] = 0

			if player_nums[i] == 3:
				player_nums[i] = 2

		var selected_node = get_node("Player" + str(i + 1) + " Selected")

		if player_nums[i] < 3:
			selected_node.position = origins[i] + Vector2(48 * player_nums[i], 0)
		elif player_nums[i] == 3:
			selected_node.position = origins[i] + Vector2(96, 54)
		else:
			selected_node.position = origins[i] + Vector2(0, 54)
		
		if player_nums[i] < 3:
			clock_targets[i] = (11 + player_nums[i]) % 12
		elif player_nums[i] == 3:
			clock_targets[i] = 3
		else:
			clock_targets[i] = 9

		if clock_frames[i] != clock_targets[i] and frame_timers[i] <= 0:
			frame_timers[i] = TIME_PER_FRAME
			if clock_frames[i] == 11 and clock_targets[i] < 8:
				clock_frames[i] = 0
			elif clock_frames[i] == 0 and clock_targets[i] > 5:
				clock_frames[i] = 11
			else:
				clock_frames[i] += sign(clock_targets[i] - clock_frames[i])

		get_node("Player" + str(i + 1) + " TT").frame = clock_frames[i]

	if Input.is_action_just_pressed("Set1"):
		Global.playerNumber = player_nums[0] + 1
		Global.player2Number = player_nums[1] + 1
		get_tree().change_scene_to_file("res://Scenes/Countdown.tscn")
