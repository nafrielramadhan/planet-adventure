extends Node2D

func _on_triple_jump_unlock_zone_body_entered(body):
	if body.name == "Player":
		if not body.can_triple_jump:
			PlayerState.has_triple_jump = true
			body.can_triple_jump = true
			print("Triple Jump unlocked!")

			# Tampilkan label
			$TripleJumpUnlockZone/Label.visible = true
			$TripleJumpUnlockZone/Timer.start()

			# Duplikat dan mainkan sound tanpa potong
			var audio = $TripleJumpUnlockZone/Sound.duplicate()
			get_parent().add_child(audio)
			audio.play()

			# Sembunyikan sprite (visual potion)
			$PotionImg.visible = false

			# Tunggu suara selesai baru hapus potion node
			await audio.finished
			audio.queue_free()
			queue_free()

func _ready():
	$TripleJumpUnlockZone.connect("body_entered", Callable(self, "_on_triple_jump_unlock_zone_body_entered"))
	$TripleJumpUnlockZone/Timer.timeout.connect(_on_timer_timeout)
	$TripleJumpUnlockZone/Label.visible = false

func _on_timer_timeout():
	$TripleJumpUnlockZone/Label.visible
