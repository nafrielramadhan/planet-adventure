extends Node

var lives= 5

var coins= 0

func add_coin():
	coins += 1  

func decrease_lives():
	if lives > 0:
		lives -= 1
		coins = 0
		
func reset_game():
	lives = 5  
	coins = 0  
