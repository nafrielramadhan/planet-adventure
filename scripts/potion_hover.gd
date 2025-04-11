extends Node2D

func _on_hover_unlock_zone_body_entered(body):
	if body.name == "Player":
		if not body.can_hover:
			PlayerState.has_hover = true
			body.can_hover = true
			print("Hover unlocked!")

			# Tampilkan label
			$HoverUnlockZone/Label.visible = true
			$HoverUnlockZone/Timer.start()

			# Duplikat dan mainkan sound
			var audio = $HoverUnlockZone/Sound.duplicate()
			get_parent().add_child(audio)
			audio.play()

			# Sembunyikan sprite (visual potion)
			$PotionImg.visible = false

			# Tunggu suara selesai, lalu hapus node
			await audio.finished
			audio.queue_free()
			queue_free()

func _ready():
	$HoverUnlockZone.connect("body_entered", Callable(self, "_on_hover_unlock_zone_body_entered"))
	$HoverUnlockZone/Timer.timeout.connect(_on_timer_timeout)
	$HoverUnlockZone/Label.visible = false

func _on_timer_timeout():
	$HoverUnlockZone/Label.visible = false
