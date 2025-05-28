extends Control

var target_world_position: Vector2
var linked_enemy: Node = null

@onready var player := get_tree().current_scene.get_node("Player")

func _process(delta):
	if not player:
		return

	if linked_enemy and not is_instance_valid(linked_enemy):
		queue_free()
		return

	if linked_enemy:
		target_world_position = linked_enemy.global_position

	var screen_position: Vector2 = get_viewport().get_canvas_transform() * target_world_position
	position = Vector2(screen_position.x, 40)
