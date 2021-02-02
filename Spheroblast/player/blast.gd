extends Area2D

var speed = 2000
var vector = Vector2.UP * speed
var DIR = 0
var hit_points = 1
var weapon_index = 0 # 0 = single shot, 1 = multi shot, 2 = super shot

func _ready():
	if weapon_index == 0:
		hit_points = 1
		$Line2D.scale = Vector2(1,1)
		$CollisionShape2D.scale = Vector2(1,1)
		$Line2D.gradient.colors[1] = Color(0,1,1,1)
		vector = Vector2.UP * 2000

	elif weapon_index == 1:
		hit_points = 1
		$Line2D.scale = Vector2(1,1)
		$CollisionShape2D.scale = Vector2(1,1)
		$Line2D.rotation_degrees = DIR # rotate projectile
		$Line2D.gradient.colors[1] = Color(1,1,0,1)
		vector = Vector2.UP.rotated(deg2rad(DIR)) * 2000 # vector (relative to parent)

	elif weapon_index == 2:
		hit_points = 5
		$Line2D.scale = Vector2(10,8)
		$CollisionShape2D.scale = Vector2(10,8)
		$Line2D.gradient.colors[1] = Color(1,0,1,1)
		vector = Vector2.UP.rotated(deg2rad(DIR)) * 1400 # vector (relative to parent)


func _process(delta):
	position += vector * delta # update projectile position

# destroy projectile after 1 second
func _on_Timer_timeout():
	queue_free()

# if the projectile hits something
func _on_blast_body_entered(body):
	body.hit(global_position, hit_points) # run hit function on object that's been hit

	if weapon_index != 2: # if not super shot
		queue_free() # destroy projectile
