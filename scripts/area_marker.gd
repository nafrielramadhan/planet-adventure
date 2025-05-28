extends Node2D

func _ready():
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	queue_free()  # Hapus otomatis setelah animasi selesai
