extends Area2D

var sound = preload("res://pickups/weapon_pickup_sound.tscn").instance()

func _ready():
	$AnimationPlayer.play("pulse")

func _on_pano_blaster_body_entered(body):
	if randf() < 0.5: # multi shot
		body.num_blast = 12
		body.weapon_index = 1
		body.set_text("MULTI")
	else: # super shot
		body.num_blast = 1
		body.weapon_index = 2
		body.set_text("SUPER")
		
	get_tree().get_current_scene().add_child(sound)
	sound.play()
	queue_free()
