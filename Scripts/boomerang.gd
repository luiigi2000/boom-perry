extends RigidBody2D

@onready var parry_margin = $ParryMargin
@onready var parry_cd = $ParryCooldown
var missed_parry = true
var parry_debounce = true
var SPEED = 2
var direction: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(get_global_mouse_position()-global_position)
	linear_velocity = (get_global_mouse_position()-global_position)*SPEED

	
func _unhandled_input(event: InputEvent) -> void:
	direction = Vector2.ZERO
	#direction = Input.get_vector("parry_left","parry_right","parry_down","parry_up")*SPEED
	if Input.is_action_just_pressed("parry"):
		direction = Vector2(1,1) * SPEED
		
	if direction != Vector2.ZERO:
		parry_debounce = false
		parry_margin.start()
		parry_cd.start()

func _on_parry_cooldown_timeout() -> void:
	parry_debounce = true



func _on_parry_margin_timeout() -> void:
	if missed_parry:
		linear_velocity /= (SPEED/2)
	missed_parry = true
	parry_margin.stop()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not parry_margin.is_stopped():
		linear_velocity *= direction 
		missed_parry = false
		parry_margin.stop()
