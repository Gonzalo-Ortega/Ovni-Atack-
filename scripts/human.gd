extends Area2D

var velocity = Vector2(0,0)


func _ready():
	$AnimatedSprite2D.play()


func _physics_process(delta):
	$NavigationAgent2D.target_position = $Objective.global_position
	var dir = (Vector2)($NavigationAgent2D.get_next_path_position() - global_position)
	if dir.length() > 1:
		dir = dir.normalized()
	
	position += dir

var is_dying = false
func die():
	if not is_dying:
		is_dying = true
		GlobalVariables.score += 1
	$AnimatedSprite2D.hide()
	$CollisionShape2D.queue_free()
	$DeathTimer.start(-1)
	$DeathParticles.restart()

func _on_new_pos_timeout():
	var human_threads = get_tree().get_nodes_in_group("human_thread")
	var max_time = 1
	var min_time = 0.2
	var threads_position = Vector2(0, 0)
	for node in human_threads:
		node = node as Node2D
		var distance = (node.global_position-global_position)
		if distance.length() < 40:
			max_time = 1
			min_time = 0.2
			distance = distance.rotated(randf_range(0, 0.6))
			threads_position = distance.normalized() * 30
	if threads_position.length() > 0.1:
		$Objective.position = -threads_position
	else:
		$Objective.position = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * 50 # TODO move to resource


