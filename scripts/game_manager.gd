extends Node

var last_map_chunk = -1


func _ready():
	$Music.play()


func _process(delta):
	pass


func _physics_process(delta):
	$PlayerController.position += Vector2(0.5, 0)
	$Map.update_map_for_position($PlayerController.global_position)
	$UI/LaserLabel.text = "(E) Laser: " + str(int(GlobalVariables.laser))
