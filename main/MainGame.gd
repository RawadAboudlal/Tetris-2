extends Node2D

const BLOCK_SIZE = 32

onready var fall_timer = $FallTimer

onready var field = $Field
onready var blocks = $Field/Blocks

onready var spawn_position = $Field/SpawnPosition

onready var i_tetromino = preload("res://tetrominoes/I.tscn")
onready var j_tetromino = preload("res://tetrominoes/J.tscn")
onready var l_tetromino = preload("res://tetrominoes/L.tscn")
onready var o_tetromino = preload("res://tetrominoes/O.tscn")
onready var s_tetromino = preload("res://tetrominoes/S.tscn")
onready var t_tetromino = preload("res://tetrominoes/T.tscn")
onready var z_tetromino = preload("res://tetrominoes/Z.tscn")

onready var settled_block = preload("res://tetrominoes/SettledBlock.tscn")

onready var tetrominoes = [i_tetromino, j_tetromino, l_tetromino, o_tetromino, s_tetromino, t_tetromino, z_tetromino]

onready var sprite = $Sprite

var turn_counter = 0

var current_tetromino = null

func _ready():
	spawn_tetromino()
	fall_timer.start()

func spawn_tetromino():
	
	current_tetromino = tetrominoes[turn_counter % tetrominoes.size()].instance()
	current_tetromino.translate(spawn_position.position)
	
	current_tetromino.connect("on_place", self, "place_tetromino")
	current_tetromino.connect("update_ground_position", self, "update_shadow")
	
	field.call_deferred("add_child", current_tetromino)
	
	turn_counter += 1

func place_tetromino():
	
	var tetromino_blocks = current_tetromino.get_children()
	
	for block in tetromino_blocks:
		
		var new_settled_block = settled_block.instance()
		
		#new_settled_block.transform = block.get_relative_transform_to_parent(field)
		#new_settled_block.set_position(block.get_position())
		#new_settled_block.translate(block.position)
		new_settled_block.transform.origin = block.get_relative_transform_to_parent(field).origin
		new_settled_block.set_block_color(block.get_block_color())
		
		blocks.add_child(new_settled_block)
	
	current_tetromino.queue_free()
	
	spawn_tetromino()

func update_shadow(y):
	sprite.set_position(Vector2(current_tetromino.global_position.x, y - (Block.BLOCK_SIZE)))

func _on_FallTimer_timeout():
	
	if current_tetromino != null:
		current_tetromino.shift_down()

func _on_DelayTimer_timeout():
	
	spawn_tetromino()
	
	fall_timer.start()
