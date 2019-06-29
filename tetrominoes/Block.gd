extends Node2D
class_name Block

const BLOCK_SIZE = 32
const BOARD_HEIGHT = 20

onready var color_rect = $ColorRect
onready var block_sprite = $BlockSprite
onready var ray = $Ray

signal ray_collision_detected(object)

func _ready():
	# Avoid collisions with other blocks in same tetromino.
	for sibling in get_parent().get_children():
		if self == sibling:
			continue
		ray.add_exception(sibling)
	
	ray.set_cast_to(Vector2(0, BOARD_HEIGHT * BLOCK_SIZE))

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	#var result = space_state.intersect_ray(global_position,
	
	if ray.is_colliding():
		emit_signal("ray_collision_detected", ray.get_collider())

# Change to different name?
func safe_rotate(angle):
	block_sprite.rotate(angle)
	ray.rotate(angle)

# Totally change this. maybe make a global enum with the properties of all the tetrominoes
# (instead of getting them from instances of the specific scenes). Definitely make another
# set of tetrominoes specifically for showing in the placeholder slots (e.g. PlaceHolderI,
# PlaceHolder).
func get_block_color():
	return color_rect.get_frame_color()