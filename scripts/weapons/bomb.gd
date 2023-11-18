extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fly_down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func explode():
	var to_destroy = $BombArea.get_overlapping_areas()
	for area in to_destroy:
		if "bomb_kills" in area.get_groups():
			area.die()
	$BombSound.play()
	$BombArea/Torch.hide()
	$BombArea/AnimatedSprite2D.hide()
	$BombArea/Timer.start(-1)
	$BombArea/ExplosionParticles.restart()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fly_down":
		explode()


func _on_timer_timeout():
	queue_free()
