extends Node

var Game = preload("res://scenes/game_manager.tscn")



func _ready():
	$TittleScreen/Tittle.play()


func _physics_process(delta):
	if Input.is_action_just_pressed("shoot_laser") and not GlobalVariables.playing:
		GlobalVariables.playing = true
		var game = Game.instantiate()
		add_child(game)
		$TittleScreen.hide()
