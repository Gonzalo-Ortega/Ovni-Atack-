extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var last_map_chunk = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	$PlayerController.position += Vector2(0, 0)
	
	$Map.update_map_for_position($PlayerController.global_position)
