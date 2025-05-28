extends Node2D

@export var obstacle : PackedScene

func _ready():
	repeat()

func spawn():
	var spawned = obstacle.instantiate()
	get_parent().call_deferred("add_child", spawned) 

	var spawn_pos = global_position
	spawn_pos.x = spawn_pos.x + randf_range(-1600, 2500)

	spawned.global_position = spawn_pos

	# Visual Cue
	var player = get_tree().current_scene.get_node("Player")
	var camera_offset_x = spawn_pos.x - player.global_position.x

	var indicator = load("res://scenes/FallIndicator.tscn").instantiate()
	indicator.target_world_position = spawn_pos
	indicator.linked_enemy = spawned
	get_tree().current_scene.get_node("CanvasLayer").add_child(indicator)

func repeat():
	spawn()
	await get_tree().create_timer(1.3).timeout
	repeat()
