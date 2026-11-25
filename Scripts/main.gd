extends Node2D

@onready var spawn_obstacle_timer = $SpawnObstacle
@onready var obstacle_scene = preload("res://Scenes/RigidBodies/obstacle.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_spawn_obstacle_timeout() -> void:
	spawn_obstacle_timer.wait_time = randf_range(0,1)
	spawn_obstacle_timer.start()
	
	var obstacle = obstacle_scene.instantiate()
	obstacle.position = Vector2(randf_range(0,get_viewport_rect().size.x),-5)
	add_child(obstacle)
	
