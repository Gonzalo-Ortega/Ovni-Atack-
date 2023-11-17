extends Area2D


# Called when the node enters the scene tree for the first time.
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


	if Input.is_action_just_pressed("shoot_laser") and GlobalVariables.laser > 0:
		var laser = $Player.Laser.instantiate()
		laser.position = Vector2(Vector2(10, 0))
		$Player.add_child(laser)

