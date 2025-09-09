extends CharacterBody2D
signal hit

@export var move_speed:float = 50
@export var bullet_scene:PackedScene
var is_death:bool = false
var is_back:bool = false
var is_walk:bool = false
var fire_cooldown :float= 1.0  # 冷却时间 1 秒
var time_since_last_fire :float= 0.0  # 距离上次开火经过的时间
var bullet_speed_buff:float = 0
var dash_cooldown :float= 2.0  # 冷却时间 1 秒
var time_dash_last_fire :float= 0.0  # 距离上次开火经过的时间

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if velocity == Vector2.ZERO or is_death:
		$WalkSound.stop()
	elif not $WalkSound.playing:
		$WalkSound.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	time_since_last_fire += delta  # 每帧累加经过的时间
	time_dash_last_fire += delta
	if not is_death:
		velocity = Input.get_vector("Left","Right","Up","Down") * move_speed
		is_walk = velocity != Vector2.ZERO
		if(velocity == Vector2.ZERO):
			$AnimatedSprite2D.play("Idle")
		else:
			$AnimatedSprite2D.play("Walk")
			if(velocity.x != 0):
				is_back = velocity.x < 0
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = velocity.x < 0
		
		if Input.is_action_just_pressed("Fire") and time_since_last_fire >= fire_cooldown and not is_walk:
			fire()
			time_since_last_fire = 0.0  # 重置计时
		
		if Input.is_action_just_pressed("Space") and time_dash_last_fire >= dash_cooldown and is_walk :
			velocity = velocity * 30
			time_dash_last_fire  = 0.0
		move_and_slide()

func death():
	is_death = true
	$AnimatedSprite2D.play("Death")
	hit.emit()
	get_tree().current_scene.start_new_game()

func fire():
	var bullet = bullet_scene.instantiate()
	bullet.fire(is_back,bullet_speed_buff)
	if is_back:
		bullet.position = position + Vector2(-20,6)
	else:
		bullet.position = position + Vector2(20,6)
	get_tree().current_scene.add_child(bullet)
	$FireSound.play()

func buff(buff_value:float):
	var t_min := 0.8
	var t_max := 3.0
	var v_min := 300.0
	var v_max := 500.0
	# 线性反向映射：数值越小，速度越高
	var speed = v_min + (t_max - buff_value) * (v_max - v_min) / (t_max - t_min)
	bullet_speed_buff = clamp(speed, v_min, v_max)
