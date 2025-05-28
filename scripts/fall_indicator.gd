extends Control

var target_world_position: Vector2
var linked_enemy: Node = null

@onready var player := get_tree().current_scene.get_node("Player")

func _process(delta):
	if not player:
		return
	
	# Hapus saat falling enemy hilang
	if linked_enemy and not is_instance_valid(linked_enemy):
		queue_free()
		return

	# Posisi sesuai dengan posisi falling enemy
	if linked_enemy:
		target_world_position = linked_enemy.global_position

	var camera_offset_x = target_world_position.x - player.global_position.x
	position = Vector2(camera_offset_x + get_viewport().size.x / 2, 40)
