extends Node2D

@onready var spawn_obstacle_timer = $SpawnObstacle

@onready var cam = $MainCamera
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainCamera.make_current()
	
func _process(delta: float) -> void:
	if int($Score.text) <= 0:
		get_tree().reload_current_scene()
