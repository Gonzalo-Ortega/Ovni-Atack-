extends Area2D

var velocity = Vector2(0,0)


func _ready():
	$AnimatedSprite2D.play()


func _physics_process(delta):
	$NavigationAgent2D.target_position = $Objective.global_position
	var dir = (Vector2)($Objective.global_position - global_position)
	if dir.length() > 1:
		dir = dir.normalized()
	
	position += dir

var is_dying = false
func die():
	if not is_dying:
		is_dying = true
		GlobalVariables.score += 5
	$AnimatedSprite2D.hide()
	$CollisionShape2D.queue_free()
	$DeathTimer.start(-1)
	$DeathParticles.restart()
var mov = 1
func _on_new_pos_timeout():
	var max_time = 1
	var min_time = 0.2
	$Objective/Timer.start(randf_range(min_time, max_time))

	$Objective.position = Vector2(mov, 0) * 1 # TODO move to resource
	mov = mov * (-1)
	$Objective/Timer.start(randf_range(min_time, max_time))

