extends Node2D
signal gameover

enum STATES {
	GO,
	FROZEN
}
var state
var play_to = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	state = STATES.GO
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("quit"):
		if state == STATES.FROZEN:
			get_tree().quit()
	elif Input.is_action_pressed("escape"):
		get_tree().quit()
	elif Input.is_action_pressed("restart"):
		# TODO: RESTART
		if state == STATES.FROZEN:
			get_tree().quit()

func _on_p2_goal(body):
	if state == STATES.FROZEN: return
	
	var newscore = int($P2Score.text)+1
	$P2Score.text = str(newscore)
	
	if newscore == play_to - 1 and int($P1Score.text) == play_to-1:
		$SuddenDeath.play()
	if newscore >= play_to:
		$Po.text = "P2"
		$Ng.text = "WIN"
		game_over()

func _on_p1_goal(body):
	if state == STATES.FROZEN: return
	
	var newscore = int($P1Score.text)+1
	$P1Score.text = str(newscore)
	if newscore == play_to - 1 and int($P2Score.text) == play_to-1:
		$SuddenDeath.play()
	if newscore >= play_to:
		$Po.text = "P1"
		$Ng.text = "WIN"	
		game_over()
		
func game_over():
	state = STATES.FROZEN
	$GAMESET.play()
	$Restart.visible = true
	$Quit.visible = true
	$P1Score.visible = false
	$P2Score.visible = false
	gameover.emit()
