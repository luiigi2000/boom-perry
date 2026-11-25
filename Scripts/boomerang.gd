extends RigidBody2D

@onready var parry_margin = $ParryMargin
var missed_parry = true
var parry_debounce = true
var SPEED = 2000
var direction: Vector2
var multiplier_count = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(get_global_mouse_position()-global_position)
	linear_velocity = (get_global_mouse_position()-global_position)*2

	
func _unhandled_input(event: InputEvent) -> void:
	if parry_debounce and event.is_action_pressed("parry"):
		parry_margin.start()
		parry_debounce = false
	elif not parry_debounce and event.is_action_pressed("parry") and parry_margin.is_stopped():
		negate_speed()


func _on_parry_margin_timeout() -> void:
	if missed_parry:
		negate_speed()
	missed_parry = true
	parry_margin.stop()
	
func _physics_process(delta: float) -> void:
	var bodies = get_colliding_bodies()
	if bodies.size() > 0 and $ResetTimer.is_stopped():
		$ResetTimer.start()
	elif bodies.size() == 0:
		$ResetTimer.stop()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not parry_margin.is_stopped():
		SPEED = wrap(SPEED,0,5000)
		linear_velocity = linear_velocity.normalized() * SPEED
		increase_multiplier_count(true)
		missed_parry = false
	else:
		negate_speed()
	parry_debounce = true
		
func negate_speed():
	SPEED -= 50
	increase_multiplier_count(false)
	
func increase_multiplier_count(increase):
	if increase:
		multiplier_count -= 1
		if multiplier_count <= 0:
			multiplier_count = 5
			SPEED *= 2
			linear_velocity = linear_velocity.normalized() * SPEED
	else:
		multiplier_count = 5

func _on_reset_timer_timeout() -> void:
	get_tree().reload_current_scene()
