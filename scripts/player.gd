extends Area2D

var acceleration = 5
var base_velocity = Vector2(0, 0)
var max_speed = 2
var friction = 0.1
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if explosion > 0:
		queue_redraw()

var explosion = -1
func _draw():
	if explosion > 0:
		draw_circle(Vector2(0,0), explosion, Color.WHITE)
		explosion += 1



func _physics_process(delta):
	pass
