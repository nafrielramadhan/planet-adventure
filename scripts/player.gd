extends CharacterBody2D

@export var bullet_node: PackedScene

func shoot():
	var bullet = bullet_node.instantiate()
 
	bullet.position = global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	get_tree().current_scene.call_deferred("add_child",bullet)
 
func _input(event):
	if PlayerState.has_shoot and event.is_action("shoot"):
		shoot()

@export var speed: int = 400
@export var sprint_speed: int = 720  
@export var gravity: int = 1200
@export var jump_speed: int = -500
@export var double_jump_speed: int = -500 
@export var triple_jump_speed: int = -700 
@export var sprint_time: float = 0.3 

# Hover-related
@export var hover_time: float = 1.0
@export var hover_gravity_scale: float = 0.1
var can_hover = false
var is_hovering = false
var hover_timer = 0.0

# Jump flags
var can_double_jump = false
var can_triple_jump = false # <-- UNLOCK kontrol
var allow_triple_jump_now = false # <-- digunakan saat lompat
var is_double_jumping = false
var is_triple_jumping = false

# State flags
var is_crouching = false
var is_sprinting = false
var last_input_time = 0
var last_direction = 0

func get_input():
	velocity.x = 0

	# Crouch
	if is_on_floor() and Input.is_action_pressed("ui_down"):
		is_crouching = true
	else:
		is_crouching = false

	# Jump sequence
	if is_on_floor():
		can_double_jump = true
		allow_triple_jump_now = can_triple_jump # hanya boleh triple jump jika sudah di-unlock
		is_double_jumping = false
		is_triple_jumping = false
		if Input.is_action_just_pressed("jump") and not is_crouching:
			velocity.y = jump_speed
	elif can_double_jump and Input.is_action_just_pressed("jump"):
		velocity.y = double_jump_speed
		can_double_jump = false
		is_double_jumping = true
	elif allow_triple_jump_now and Input.is_action_just_pressed("jump"):
		velocity.y = triple_jump_speed
		allow_triple_jump_now = false
		is_triple_jumping = true

	# Sprint
	var current_time = Time.get_ticks_msec() / 1000.0
	if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
		var direction = 1 if Input.is_action_just_pressed("right") else -1
		if direction == last_direction and (current_time - last_input_time) <= sprint_time:
			is_sprinting = true
		else:
			is_sprinting = false
		last_direction = direction
		last_input_time = current_time

	# Move
	var current_speed = sprint_speed if is_sprinting else speed
	if not is_crouching:
		if Input.is_action_pressed("right"):
			velocity.x += current_speed
		if Input.is_action_pressed("left"):
			velocity.x -= current_speed

func _physics_process(delta):
	# Hover logic
	if can_hover and not is_on_floor():
		if Input.is_action_pressed("hover") and hover_timer > 0:
			is_hovering = true
			hover_timer -= delta
		else:
			is_hovering = false
	else:
		is_hovering = false

	# Reset hover timer when on ground
	if is_on_floor():
		hover_timer = hover_time

	# Apply gravity (normal or reduced)
	if is_hovering:
		velocity.y += gravity * hover_gravity_scale * delta
	else:
		velocity.y += gravity * delta

	get_input()
	move_and_slide()

func _process(_delta):
	var animated_sprite = $AnimatedSprite2D

	if is_crouching:
		animated_sprite.play("crouch")
	elif is_triple_jumping:
		animated_sprite.play("double_jump") # pakai animasi double jump dulu
	elif is_double_jumping:
		animated_sprite.play("double_jump")
	elif velocity.y > 0 and not is_on_floor():
		animated_sprite.play("fall")
	elif not is_on_floor():
		animated_sprite.play("jump")
	elif velocity.x != 0:
		if is_sprinting:
			animated_sprite.play("sprint")
		else:
			animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

	if velocity.x != 0:
		animated_sprite.flip_h = velocity.x < 0
		
func _ready():
	can_triple_jump = PlayerState.has_triple_jump
	can_hover = PlayerState.has_hover
