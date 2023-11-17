extends Area2D

@onready var screen_size = get_viewport_rect().size
@export var speed = 1.5

enum STATES {
	FROZEN,
	GO
}
var state =	STATES.GO

func _reset_speed():
	speed = 1.5
	#state = STATES.GO

func _freeze():
	speed = 0
	state = STATES.FROZEN
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == STATES.FROZEN:
		return
	speed += delta
	var p = "0"
	if name == 'Player1':
		p = "1"
	else:
		p = "2"
	if Input.is_action_pressed("p"+p+"_move_up"):
		position.y -= speed
	if Input.is_action_pressed("p"+p+"_move_down"):
		position.y += speed
	position = position.clamp(Vector2(5,5), screen_size - Vector2(0, 140))
	
