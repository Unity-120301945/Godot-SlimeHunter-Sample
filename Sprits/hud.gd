extends CanvasLayer

var score = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hit_enemy():
	score+=1
	change_score()

func change_score():
	$ScoreLabel.text = "Score：%s" % score
	
func game_over():
	$"Game Over Label".show()
	$GameOverSound.play()
	
