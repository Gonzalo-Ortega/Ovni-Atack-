extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var disable = false
func _physics_process(delta):
	if not disable:
		var space_state = get_world_2d().direct_space_state
		# use global coordinates, not local to node
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position+Vector2(5000, 0))
		
		var result = space_state.intersect_ray(query)
		print(result)
		print(global_position)
		if result:
			draw_line(Vector2(0,0), global_position-result.position+Vector2(5000, 0), Color.AQUA, 4)
			var circle_instance = CircleShape2D.new()
			var collision_shape = CollisionShape2D.new()
			collision_shape.shape = circle_instance 
			add_child(collision_shape)
			print("Hit at point: ", result.position)
			collision_shape.global_position = result.position
			disable = true	

func _draw():
	# Draw a line as the raycast
	draw_line(Vector2(0, 0), Vector2(0, 0), Color.AQUA, 4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
