extends Node2D

func _on_live_collected(body):
	if body.get_name() == "Player":
		global.add_live()  # Tambahkan lives ke sistem global
		
		var audio = $Area2D/AudioStreamPlayer2D.duplicate()  
		get_parent().add_child(audio) 
		audio.play()
		
		queue_free()  # Hapus lives setelah dikoleksi
		await audio.finished
		audio.queue_free()  # Hapus audio setelah selesai diputar
