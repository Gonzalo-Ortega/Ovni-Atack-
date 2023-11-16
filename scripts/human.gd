extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var velocity = Vector2(0,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$NavigationAgent2D.target_position = get_global_mouse_position()
	var dir = (Vector2)($NavigationAgent2D.get_next_path_position() - global_position)
	if dir.length() > 1:
		dir = dir.normalized()
	
	position += dir
