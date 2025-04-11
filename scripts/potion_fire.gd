extends Node2D

func _on_unlock_zone_body_entered(body):
	if body.name == "Player":
		if not PlayerState.has_shoot:
			PlayerState.has_shoot = true
			print("Shoot unlocked!")

			$UnlockZone/Label.visible = true
			$UnlockZone/Timer.start()

			var audio = $UnlockZone/Sound.duplicate()
			get_parent().add_child(audio)
			audio.play()

			$PotionImg.visible = false

			await audio.finished
			audio.queue_free()
			queue_free()

func _ready():
	$UnlockZone.connect("body_entered", Callable(self, "_on_unlock_zone_body_entered"))
	$UnlockZone/Timer.timeout.connect(_on_timer_timeout)
	$UnlockZone/Label.visible = false

func _on_timer_timeout():
	$UnlockZone/Label.visible = false
