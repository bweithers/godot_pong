extends RigidBody2D
signal goal
signal reset_sig

@export var geom_speed_ = 1.15
@export var torq = 100
@export var initial_velocity = Vector2(150,20)
@onready var initial_position = Vector2(get_viewport_rect().size/2)
var timer = 0
var rng = RandomNumberGenerator.new()

enum STATES {
	GO,
	FROZEN,
	RESET_L,
	RESET_C,
	RESET_R
}
var ballstate = STATES.GO

func _ready():
	reset('left')
	set_contact_monitor(true)
	set_linear_velocity(initial_velocity)
	
func _process(delta):
	if Input.is_action_pressed("reset_ball"):
		ballstate = STATES.RESET_C
	if ballstate != STATES.FROZEN:
		var vx_sign = int(linear_velocity.x > 0)
		var vy_sign = int(linear_velocity.y > 0)
		var r_fx = rng.randf_range(20,100)
		var r_fy = rng.randf_range(20,100)
		var r_dx = rng.randf_range(-100,100)
		var r_dy = rng.randf_range(-100,100)
		var f = Vector2((geom_speed_+r_fx)*vx_sign,(geom_speed_+r_fy)*vy_sign)
		var d = Vector2(r_dx*vx_sign,r_dy*vy_sign)
		apply_force(f*delta,d*delta)
		
	
func _on_goal_entered(body):
	var direction
	if linear_velocity.x < 0:
		direction = 'left'
	else:
		direction = 'right'
	goal.emit(body)
	$Goal_Audio.play()
	reset(direction)
	
func reset(direction):
	match direction:
		'left':
			ballstate = STATES.RESET_L
		'right':
			ballstate = STATES.RESET_R
		_:
			ballstate = STATES.RESET_C
	reset_sig.emit()
	set_linear_velocity(linear_velocity*-0.5)

func _integrate_forces(state):
		var loc = get_position()
		match ballstate:
			STATES.RESET_L:
				loc.x = 100
			STATES.RESET_R:
				loc.x = get_viewport_rect().size.x - 100
			STATES.RESET_C:
				loc = get_viewport_rect().size / 2
			STATES.FROZEN:
				loc = get_viewport_rect().size / 2
				state.transform = Transform2D(0.0, loc)
				set_freeze_enabled(true)
				print('Frozen')
				return
		state.transform = Transform2D(0.0, loc)
		ballstate = STATES.GO 
	
func _on_player_body_entered(body):
	if body.name == 'Ball':
		$Bounce_Audio.play()
		apply_torque(torq*100)

func _on_wall_bounce(body):
	if body.name == 'Ball':
		$Bounce_Audio.play()
		apply_torque(torq*10)


func _on_gameover():
	ballstate = STATES.FROZEN
