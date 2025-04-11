extends Area2D

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)
	$Label.visible = false

func _on_TripleJumpUnlockZone_body_entered(body):
	if body.name == "Player":
		if not body.can_triple_jump:
			body.can_triple_jump = true
			$Label.visible = true
			$Timer.start()
			print("Triple Jump unlocked! Karakter sekarang bisa melompat tiga kali.")

func _on_timer_timeout():
	$Label.visible = false
