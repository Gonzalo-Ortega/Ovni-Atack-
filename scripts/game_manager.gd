extends Node

var last_map_chunk = -1


func _ready():
	$Music.play()
	GlobalVariables.laser = 100
	GlobalVariables.bombs = 5
	GlobalVariables.explode = 1
	GlobalVariables.score = 0
	GlobalVariables.game_over = false


func _physics_process(delta):
	$PlayerController.position += Vector2(0.5, 0)
	$Map.update_map_for_position($PlayerController.global_position)
	
	$UI/Laser.text = "(E) Laser: " + str(int(GlobalVariables.laser))
	$UI/Bomb.text = "(Q) Bomb: " + str(int(GlobalVariables.bombs))
	$UI/Explode.text = "(R) Explode: " + str(int(GlobalVariables.explode))
	
	$UI/Score.text = "Score: " + str(int(GlobalVariables.score))
	
	GlobalVariables.game_over = GlobalVariables.explode == 0
	
	if Input.is_action_just_pressed("esc") or GlobalVariables.game_over:
		queue_free()
