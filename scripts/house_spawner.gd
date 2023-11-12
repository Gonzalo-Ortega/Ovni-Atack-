extends Node

var House = preload("res://scenes/house.tscn")

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var house = House.instantiate()
	house.position = Vector2(200, rng.randi_range(16, 85))
	add_child(house)
	$Timer.wait_time = rng.randi_range(0.5, 1)
	$Timer.start()
