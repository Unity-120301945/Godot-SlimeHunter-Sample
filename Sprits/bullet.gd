extends Area2D

@export var move_speed :float = 300
var is_back:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_back:
		position += Vector2(move_speed,0) * delta
	else:
		position += Vector2(-move_speed,0) * delta

func fire(isBack:bool,speed:float):
	is_back = isBack
	if speed <=0:
		return
	move_speed = speed
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
