extends KinematicBody2D

var blastScene = preload("res://player/blast.tscn")

var num_blast = 1
var weapon_index = 0
var charging = false

var velocity = Vector2.ZERO #current speed
var angle = 0 # current direction
var angularVelocity = 0 # current rotational speed
var vector = Vector2.ZERO # current vector (speed and direction combined)

const maxVelocity = 800 # maximum speed
const maxAngular = 1.5 # maximum rotational speed
const weight = 0.11

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		velocity.y = lerp(velocity.y, -1, weight)
		
	if Input.is_action_pressed("ui_down"):
		velocity.y = lerp(velocity.y, 1, weight)
		
	if not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
		velocity.y = lerp(velocity.y, 0, weight)
		
	if Input.is_action_pressed("left"):
		velocity.x = lerp(velocity.x, -1, weight)
		
	if Input.is_action_pressed("right"):
		velocity.x = lerp(velocity.x, 1, weight)
		
	if not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		velocity.x = lerp(velocity.x, 0, weight)
	
	if Input.is_action_pressed("ui_left"):
		angularVelocity = lerp(angularVelocity, -1, weight)
		
	if Input.is_action_pressed("ui_right"):
		angularVelocity = lerp(angularVelocity, 1, weight)
		
	if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		angularVelocity = lerp(angularVelocity, 0, weight)
	
	angle += angularVelocity * maxAngular # update angle
	vector = velocity.rotated(deg2rad(angle)) # rotate by angle
	 # limit the total velocity
	vector.x = clamp(vector.x, -1, 1)
	vector.y = clamp(vector.y, -1, 1)  
	vector *= maxVelocity # scale velocity
	vector = move_and_slide(vector) # move kinematic body
	rotation_degrees = angle # rotate sprite
	
	if velocity.length() >= 0.1 or abs(angularVelocity) >= 0.1: # when high speed reached (translation or rotation speed)
		$dust.emitting = true # make dust particles
	else:
		$dust.emitting = false # turn off the dust particles
		
	if Input.is_action_pressed("fire"):
		
		if weapon_index != 2 and $fire_rate.is_stopped(): # if not super shot and rate timer is done

			for i in range(num_blast):
				var blast = blastScene.instance() # get instance of blastScene
				blast.DIR = i * (360 / num_blast) # set direction of projectile
				blast.weapon_index = weapon_index # pass on current weapon index
				add_child(blast) # add instance to parent
			
			$blast.pitch_scale = randf() + 1  # randomize pitch of blaster
			$blast.play() # play blaster sound
			if weapon_index == 1:
				$fire_rate.wait_time = 0.2
			else:
				$fire_rate.wait_time = 0.1
			$fire_rate.start() # start fire_rate timer
				
		else: # super shot
			$fire_rate.wait_time = 0.5

			# initialise charging
			if not charging and $fire_rate.is_stopped() and $charge_rate.is_stopped():
				$charge_rate.start() # start fire_rate timer
				$charging.pitch_scale = randf() / 4 + 0.9
				$charging.play()
				charging = true
				
			# charging complete
			elif $charge_rate.is_stopped() and charging:
				var blast = blastScene.instance() # get instance of blastScene
				blast.weapon_index = weapon_index # pass on current weapon index
				blast.rotation = rotation
				blast.DIR = rotation_degrees
				blast.position = position
				
				get_tree().get_current_scene().add_child(blast) # add instance to parent
				$fire_rate.start() # start fire_rate timer
				$Camera2D.position = Vector2(0, -200)
				$super_shot.pitch_scale = randf() / 8 + 0.5
				$super_shot.play()
				charging = false
				
			# charging
			else:
				if charging:
					shake()
	
	# cancel charging
	if Input.is_action_just_released("fire"):
		charging = false
		$charge_rate.stop()
		$Camera2D.position.x = lerp($Camera2D.position.x, 0, 0.5)
		$Camera2D.position.y = lerp($Camera2D.position.y, -200, 0.5)
		$charging.stop()
		
func shake():
	var randX = 0
	var randY = 0
	
	if $shake_rate.is_stopped(): # if the fire_rate timer is done
		randX = randi() % 100 - 50
		randY = randi() % 100 - 50
		$Camera2D.position.x = lerp($Camera2D.position.x, 0, 0.5)
		$Camera2D.position.y = lerp($Camera2D.position.y, -200, 0.5)
		$shake_rate.start() # start fire_rate timer
		
	$Camera2D.position.x = lerp($Camera2D.position.x, $Camera2D.position.x + randX, 0.5)
	$Camera2D.position.y = lerp($Camera2D.position.y, $Camera2D.position.y + randY, 0.5)
	
func set_text(string):
	get_node("Camera2D/CanvasLayer/Label").text = string
