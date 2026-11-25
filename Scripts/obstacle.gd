extends RigidBody2D

@export var meshes: Array[Texture2D]
@onready var sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = meshes.pick_random()
	
func _physics_process(delta: float) -> void:
	if position.y >= get_viewport_rect().size.y+10:
		queue_free()
