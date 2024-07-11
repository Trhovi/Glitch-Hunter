extends CharacterBody3D

@onready var animated_sprite_2d = $CanvasLayer/Gunbase/AnimatedSprite2D
@onready var ray_cast_3d = $RayCast3D
@onready var shoot_sound = $ShootSound


#VELOCIDADE DE MOVIMENTAÇÃO

const SPEED = 5.0
const MOUSE_SENS = 0.5
const SPEED_SPRINT = 18.0
const ACCEL = 15.0

var can_shoot = true
var dead = false

#PULO

#comentario de teste
const GRAVITY = -40.0 
const JUMP_SPEED = 8.0
var jump_power = 4
var is_jumping = false


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animated_sprite_2d.animation_finished.connect(shoot_anim_done)
	$CanvasLayer/Deathscreen/Panel/Button.button_up.connect(restart)

func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENS
		$Camera3D.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENS * -1)) #rotacionar a cam
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -75, 75)#parar de rodar toda
		
		

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
	if dead:
		return
	
	if Input.is_action_just_pressed("shoot"):
		if can_shoot:
			shoot()
			can_shoot = false

func _physics_process(_delta):
	
	if dead:
		return
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_fowards", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var _speed = SPEED_SPRINT if Input.is_action_just_pressed("sprint") else SPEED
	

	
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	velocity.y += GRAVITY * _delta
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = JUMP_SPEED

	move_and_slide()
	
	
func restart():
	get_tree().reload_current_scene()

func shoot():
	animated_sprite_2d.play("shoot")
	shoot_sound.play()

	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().has_method("kill"):
		ray_cast_3d.get_collider().kill()

func shoot_anim_done():
	can_shoot = true

func kill():
	dead = true
	$CanvasLayer/Deathscreen.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = jump_power
