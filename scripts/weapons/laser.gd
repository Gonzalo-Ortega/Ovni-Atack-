extends Node2D

var maximum_length = -1
var LASER_AREA = 8


# Called when the node enters the scene tree for the first time.
func _ready():
	$SoundEffect.play()


func _set_size(new_size):
	maximum_length = new_size
	$LaserArea.position = Vector2(maximum_length/2, -LASER_AREA/2+3)
	$LaserArea/LaserCollisionShape.shape.size = Vector2(maximum_length, LASER_AREA)
	queue_redraw()


func _raycast_maximun_length():
	# Get space state
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position+Vector2(5000, 0))
	# Detect areas and add houses collision mask
	query.collide_with_areas = true
	query.collision_mask = 0b10000 # Layer 5
	
	var new_maximum_length = 500
	var result = space_state.intersect_ray(query)
	
	if result:
		new_maximum_length = result.position.x-global_position.x

	if maximum_length != new_maximum_length:
		_set_size(new_maximum_length)


func _physics_process(delta):
	if Input.is_action_just_released("shoot_laser") or GlobalVariables.laser <= 0:
		queue_free()
	GlobalVariables.laser -= 0.1
	_raycast_maximun_length()


func _draw():
	draw_line(Vector2(0,-LASER_AREA/2+3), Vector2(maximum_length, -LASER_AREA/2+3), Color.WHITE, LASER_AREA)


func _on_laser_area_body_entered(body):
	print(typeof(body))


func _on_laser_area_area_entered(area: Area2D):
	if "laser_kills" in area.get_groups():
		area.die()
