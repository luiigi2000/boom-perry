extends RigidBody2D

@onready var parry_margin = $ParryMargin
var missed_parry = true
var parry_debounce = true
var SPEED = 1000
var direction: Vector2
var multiplier_count = 5
@onready var cam = 	get_tree().get_first_node_in_group("main_camera")
@onready var score = 	get_tree().get_first_node_in_group("score")
var slow_debounce = false
var parried_key
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(get_global_mouse_position()-global_position)
	linear_velocity = (get_global_mouse_position()-global_position).normalized() * SPEED

	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("blast"):
		apply_central_impulse(-$AnimatedSprite2D.transform.y * 500)
	if event is InputEventKey and event.pressed and parry_debounce:
		parried_key = OS.get_keycode_string(event.keycode)
		parry_margin.start()
		parry_debounce = false
	elif event is InputEventKey and event.pressed and not parry_debounce and parry_margin.is_stopped():
		negate_speed()
	#if parry_debounce and event.is_action_pressed("parry"):
		#parry_margin.start()
		#parry_debounce = false
		#end_slow_mow()
	#elif not parry_debounce and event.is_action_pressed("parry") and parry_margin.is_stopped():
		#negate_speed()
		#end_slow_mow()


func _on_parry_margin_timeout() -> void:
	if missed_parry:
		negate_speed()
	missed_parry = true
	parry_margin.stop()
	
func _process(delta: float) -> void:
	cam.position = lerp(cam.position,position,.001)
	if position.x > get_viewport_rect().size.x/2:
		$AnimatedSprite2D.rotation = lerp_angle($AnimatedSprite2D.rotation,3*PI/2,.1)
	elif position.x < get_viewport_rect().size.x/2:
		$AnimatedSprite2D.rotation = lerp_angle($AnimatedSprite2D.rotation,PI/2,.1)
	if position.y > get_viewport_rect().size.y/2:
		$AnimatedSprite2D.rotation = lerp_angle($AnimatedSprite2D.rotation,2*PI,.1)
	elif position.x < get_viewport_rect().size.y/2:
		$AnimatedSprite2D.rotation = lerp_angle($AnimatedSprite2D.rotation,PI,.1)
	if slow_debounce:
		cam.global_position = cam.global_position.lerp(position, .1)
		cam.zoom = cam.zoom.lerp(Vector2(1.5,1.5),.1)
	else:
		cam.global_position = cam.global_position.lerp(Vector2(1152/2,648/2), .1)
		cam.zoom = cam.zoom.lerp(Vector2(1,1),.1)
	score.text = "[wave] +"+ str(SPEED) + "[/wave]"
		
func _physics_process(delta: float) -> void:
	var bodies = get_colliding_bodies()
	if bodies.size() > 0 and $ResetTimer.is_stopped():
		$ResetTimer.start()
	elif bodies.size() == 0:
		$ResetTimer.stop()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not parry_margin.is_stopped() and body.get_meta("ParryKey") == parried_key:
		linear_velocity = linear_velocity.normalized() * SPEED
		increase_multiplier_count(true)
		missed_parry = false
	else:
		negate_speed()
	parry_debounce = true
	parried_key = ""
		
func negate_speed():
	SPEED -= 10
	increase_multiplier_count(false)
	
func increase_multiplier_count(increase):
	if increase:
		multiplier_count -= 1
		SPEED += 10
		if multiplier_count <= 0:
			boost()
	else:
		multiplier_count = 5

func _on_reset_timer_timeout() -> void:
	get_tree().reload_current_scene()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("SlowDown"):
		slow_debounce = true
		if get_colliding_bodies().size() > 2:
			Engine.time_scale = .15
		else:
			Engine.time_scale = .25

		

func end_slow_mow():
	Engine.time_scale = .5
	slow_debounce = false

func boost():
	multiplier_count = 5
	SPEED += 50
	linear_velocity = linear_velocity.normalized() * SPEED


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("SlowDown"):
		end_slow_mow()
