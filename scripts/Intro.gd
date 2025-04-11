extends Node2D

@export var slides: Array[Texture2D]    
@export var switch_delay := 2.0         
@export var next_scene_path := "res://scenes/Level1.tscn"

var current_index = 0

func _ready():
	$Timer.wait_time = switch_delay
	$Timer.timeout.connect(_on_timer_timeout)
	show_slide()  # tampilkan gambar pertama
	$Timer.start()

func _on_timer_timeout():
	current_index += 1

	if current_index >= slides.size():
		get_tree().change_scene_to_file(next_scene_path)
	else:
		show_slide()
		$Timer.start()

func show_slide():
	var sprite = $Sprite2D
	sprite.texture = slides[current_index]
	resize_sprite_to_screen()

func resize_sprite_to_screen():
	var sprite = $Sprite2D
	if not sprite.texture:
		return
	var screen_size = get_viewport().get_visible_rect().size
	var texture_size = sprite.texture.get_size()
	sprite.scale = screen_size / texture_size
