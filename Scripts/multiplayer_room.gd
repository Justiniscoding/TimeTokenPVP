extends Control

var callback: Callable

var user

func init(username: String, joinCallback: Callable, isJoined = false) -> void:
	$VBoxContainer/Label.text = username + "'s Room"
	user = username
	callback = joinCallback

	if isJoined:
		$VBoxContainer/Button.text = "Joined"
		$VBoxContainer/Button.disabled = true


func _ready() -> void:
	$VBoxContainer/Button.connect("pressed", func():
		callback.call(user))
