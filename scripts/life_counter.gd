extends Label

func _process(_delta):
	self.text = "Lives : " + str(global.lives)
