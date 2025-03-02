extends Node

@export var mob_scene: PackedScene #selects the mob scene we want to insance
var score


func _ready():   #can use new_game to test out the game
	pass


func game_over():          #handles game over
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():      #starts new game
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get ready!")
	get_tree().call_group("mobs", "queue_free") #calls mob to delete itself
	$Music.play()


func _on_mob_timer_timeout():      
	var mob = mob_scene.instantiate() #creates new instance of mob scene

	var mob_spawn_location = $MobPath/MobSpawnLocation #choose random location on Path2D
	mob_spawn_location.progress_ratio = randf()

	var direction = mob_spawn_location.rotation + PI / 2 #sets mob direction perpendicular to path direction

	mob.position = mob_spawn_location.position #sets mob position to random location

	direction += randf_range(-PI / 4, PI / 4) #Add randomness to direction
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0) #choose mob velocity
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob) #spawn mob by adding it to scene


func _on_score_timer_timeout(): #increases score by 1
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout(): #the start timer will start the other 2 timers
	$MobTimer.start()
	$ScoreTimer.start()
