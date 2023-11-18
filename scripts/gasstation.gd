extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	pass

func explode():
	var to_destroy = $Explossion.get_overlapping_areas()
	for area in to_destroy:
		if "bomb_kills" in area.get_groups():
			area.die()
	$Explode.play()
	$Explossion/Timer.start(-1)
	$Explossion/ExplossionParticles.restart()

var is_dying = false
func die():
	if not is_dying:
		is_dying = true
		explode()
		$AnimatedSprite2D.play("destroyed")
		$CollisionShape2D.queue_free()
		GlobalVariables.score += 20
