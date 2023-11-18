extends Area2D

var Laser = preload("res://scenes/weapons/laser.tscn")
var Bomb = preload("res://scenes/weapons/bomb.tscn")

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_vector = Vector2(0, 0)
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector == Vector2(0, 0):
		$Player.velocity = $Player.velocity.lerp(Vector2(0, 0), $Player.friction)
	else:
		$Player.velocity += input_vector * $Player.acceleration * delta
		$Player.velocity = $Player.velocity.limit_length($Player.max_speed)
	
	$Player.position += $Player.velocity
	
	var new_player_pos = $Player.position
	var player_rect = (Rect2)($Player/CollisionShape2D.shape.get_rect())
	player_rect.position += new_player_pos
	var playable_space_rect = (Rect2)($PlayableSpace.shape.get_rect())

	if $Player.global_position.y < -10:
		$Player.global_position.y = 120
	if $Player.global_position.y > 130:
		$Player.global_position.y = 0
	
	if $Player.position.x < -70:
		$Player.position.x = -70
	if $Player.position.x > 70:
		$Player.position.x = 70
	
	
	if Input.is_action_just_pressed("shoot_laser") and GlobalVariables.laser > 0:
		var laser = Laser.instantiate()
		laser.position = Vector2(Vector2(10, 0))
		$Player.add_child(laser)
	
	if Input.is_action_just_pressed("bomb") and GlobalVariables.bombs > 0:
		var bomb = Bomb.instantiate()
		bomb.position = $Player.position
		add_child(bomb)
		GlobalVariables.bombs -= 1
	
	if Input.is_action_just_pressed("explode") and GlobalVariables.explode > 0:
		if $Player.explosion < 0:
			$NukeTimer.start(-1)
			$Player.explosion = 20
			$Player.queue_redraw()
			$Player/Explode.play()



func _on_nuke_timer_timeout():
	GlobalVariables.explode -= 1
