extends Node2D

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/root.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _process(delta):
	if Input.is_action_pressed("play"):
		get_tree().change_scene_to_file("res://scenes/root.tscn")
	elif Input.is_action_pressed("quit"):
		get_tree().quit()
