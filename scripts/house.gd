extends Area2D

var acceleration = 5
var base_velocity = Vector2(-0.5, 0)
var max_speed = 2
var friction = 0.1
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	var input_vector = Vector2(0, 0)
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector = input_vector.normalized()
	
	
	if input_vector == Vector2(0, 0):
		velocity = velocity.lerp(base_velocity, friction)
	else:
		if input_vector.x > 0:
			velocity = base_velocity * 2 * input_vector.x
		elif input_vector.x < 0:
			velocity = base_velocity * 0.5
	
	position += velocity
	
	# Checks if position is in the screen, can be change to take dinamic sices.
	if position.x < -16:
		queue_free()
