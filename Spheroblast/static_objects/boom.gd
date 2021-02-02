extends Particles2D

func _ready():
	emitting = true # turn on explosion
	$AudioStreamPlayer2D.pitch_scale = randf() + 1 # randomize pitch of explosion
	$AudioStreamPlayer2D.play() # play explosion sound
	$Timer.start()


func _on_Timer_timeout():
	queue_free() # remove from scene when explosion done
