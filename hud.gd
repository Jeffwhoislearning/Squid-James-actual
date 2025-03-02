extends CanvasLayer


signal start_game #notifies "Main" node that start button has been pressed

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over(): #called when a player loses
	show_message("You fucking died...") #show for two seconds
	await $MessageTimer.timeout #wait until MessageTimer has counted down
	
	$Message.text = "Please dodge the squids" #return to title screen
	$Message.show()
	await get_tree().create_timer(1.0).timeout #make oneshot timer and wait for it to finish
	$StartButton.show() #show start button

func update_score(score): #updates the score
	score += 1
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
