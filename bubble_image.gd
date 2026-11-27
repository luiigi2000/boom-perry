extends Sprite2D

@export var meshes: Array[Texture2D]
var outline_array = []
var spawned_bubbles = []
var directions = [Vector2(-1,0),Vector2(0,1),Vector2(1,0),Vector2(0,-1)]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var image = meshes[0].get_image()
	for x in image.get_width():
		for y in image.get_height():
			var pos = Vector2(x,y)
			var pixelv = image.get_pixelv(pos)
			if pixelv != Color(0.0,0.0,0.0,0.0):
				check_neighbor(pos,pixelv,image)
	draw_bubbles()
				

func check_neighbor(pos: Vector2,pixelv: Color, image: Image):
	var push_debounce = false
	for dir in directions:
		var neighbor = pos + dir
		if neighbor.x < 0 or neighbor.x >= image.get_width() or neighbor.y < 0 or neighbor.y >= image.get_height():
			continue
		if image.get_pixelv(neighbor) == Color(0.0,0.0,0.0,0.0):
			push_debounce = true
	if push_debounce:	
		outline_array.append(pos)

func draw_bubbles():
	for pos in outline_array:
		var too_close = false
		for i in spawned_bubbles:
			if pos.distance_to(i) < 30:
				too_close = true
				break
				
		if not too_close:
			spawned_bubbles.append(pos)
			var bubble = preload("res://bubble.tscn").instantiate()
			bubble.position = pos * Vector2(2,2)
			add_child(bubble)
	
