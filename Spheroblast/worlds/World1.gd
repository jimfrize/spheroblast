extends Node2D

var block_scene = preload("res://static_objects/BLOCK.tscn")
var pickup_scene = preload("res://pickups/weapon_pickup.tscn")

const block_size = 128
const num_block = 64
const block_thresh = 0.5
const pickup_thresh = 0.1

func _ready():
	var tex_map = $NOISE.get_texture()
	yield(get_tree(), "idle_frame") # wait until first frame signal before getting texture data, or it will return null
	var pix_map = tex_map.get_data() # get image data from texture
	pix_map.lock() # lock image data

	# iterate through all pixels in image
	for y in range(num_block):
		for x in range(num_block):

			var PIX = pix_map.get_pixel(x,y)[0] # get pixel brightness from red channel (index 0)

			if PIX >= block_thresh: # if the pixel is brighter than the threshold, we add a block to the world
				var block = block_scene.instance() # create instance of block_scene
				add_child(block) # add instance to world
				# move block into position
				block.position.x = x * block_size
				block.position.y = y * block_size
					
			if PIX <= pickup_thresh:
				var pickup = pickup_scene.instance()
				add_child(pickup)
				pickup.position.x = x * block_size
				pickup.position.y = y * block_size
				
func _process(delta):
	if Input.is_action_pressed("reload"):
		get_tree().reload_current_scene()
