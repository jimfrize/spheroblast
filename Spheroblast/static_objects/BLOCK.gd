extends StaticBody2D

var health = 5
var boom_scene = preload("res://static_objects/boom.tscn")
var rico = preload("res://static_objects/ricochetP2D.tscn").instance()

func _ready():
	add_child(rico)
	$AnimationPlayer.play("pulse")

func hit(POS, HIT):
	health -= HIT # reduce health of object
	rico.global_position = POS # move the ricochet particle simulation to the position of the hit
	rico.emitting = true # turn on the ricochet simulation
	$Timer.start() # start particle simulation timeout timer
	$ricochet.pitch_scale = randf() + 0.1 # randomize pitch of ricochet
	$ricochet.play() # play ricochet sound
	
	# if object runs out of health, initiate death sequence
	if health <= 0:
		var boom = boom_scene.instance()
		get_tree().get_current_scene().add_child(boom) # add explosion to main scene
		boom.position = position # move explosion to position of block
		queue_free() # remove block from scene


func _on_Timer_timeout():
	rico.emitting = false # turn off particles after 0.25s in order to avoid offscreen simulations starting late
