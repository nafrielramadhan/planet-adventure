extends Label

func _process(_delta):
	self.text = "Coins : " + str(global.coins)
