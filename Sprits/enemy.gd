extends Area2D
signal hit

@export var move_speed:float = -50
var is_death:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_death:
		position += Vector2(move_speed,0)  * delta
	
func death():
	is_death = true
	$AnimatedSprite2D.play("Death")
	$DeathSound.play()
	await get_tree().create_timer(0.6).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if(body is CharacterBody2D):
		body.death()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		death()
		area.queue_free()
		hit.emit()
