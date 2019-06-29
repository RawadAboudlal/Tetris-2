extends Node2D

const BLOCK_SIZE = 32

onready var fall_timer = $FallTimer

onready var field = $Field
onready var blocks = $Field/Blocks

onready var spawn_position = $Field/SpawnPosition
onready var tetromino_holder = $HoldAndScore/TetrominoHolder
onready var next_tetrominoes = $NextTetrominoes

onready var settled_block = preload("res://tetrominoes/SettledBlock.tscn")

onready var sprite = $Sprite

var turn_counter = 0

var current_tetromino = null
var current_tetromino_index = -1

var held_this_turn = false

var tetromino_rand_max = Tetrominoes.NUMBER_OF_TETROMINOES
var tetromino_indices_bag = []

func _ready():
	randomize()
	initialize_game()

func initialize_game():
	
	on_new_turn()
	
	fall_timer.start()
	

func _input(event):
	if event.is_action_pressed("hold"):
		
		if !held_this_turn:
			
			if tetromino_holder.get_held_tetromino_index() <= -1:
				tetromino_holder.set_tetromino(current_tetromino_index)
				on_new_turn()
			else:
				var held_tetromino_index = tetromino_holder.get_held_tetromino_index()
				tetromino_holder.set_tetromino(current_tetromino_index)
				current_tetromino_index = held_tetromino_index
				spawn_tetromino()
			
			held_this_turn = true

func on_new_turn():
	
	if turn_counter == 0:
		
		current_tetromino_index = get_next_tetromino_index()
		
		for i in range(3):
			var next_tetromino_index = get_next_tetromino_index()
			next_tetrominoes.add_tetromino(next_tetromino_index)
	
	else:
		var new_tetromino_index = get_next_tetromino_index()
		current_tetromino_index = next_tetrominoes.get_next_tetromino(new_tetromino_index)
	
	turn_counter += 1
	
	held_this_turn = false
	
	spawn_tetromino()
	

func spawn_tetromino():
	
	if current_tetromino != null:
		current_tetromino.queue_free()
	
	current_tetromino = Tetrominoes.create_controllable_tetromino(current_tetromino_index)
	current_tetromino.translate(spawn_position.position)
	
	current_tetromino.connect("on_place", self, "place_tetromino")
	current_tetromino.connect("update_ground_position", self, "update_shadow")
	
	field.call_deferred("add_child", current_tetromino)
	

func place_tetromino():
	
	var tetromino_blocks = current_tetromino.get_blocks()
	
	for block in tetromino_blocks:
		
		var new_settled_block = settled_block.instance()
		
		#new_settled_block.transform = block.get_relative_transform_to_parent(field)
		#new_settled_block.set_position(block.get_position())
		#new_settled_block.translate(block.position)
		new_settled_block.transform.origin = block.get_relative_transform_to_parent(field).origin
		new_settled_block.set_block_color(block.get_block_color())
		
		blocks.add_child(new_settled_block)
	
	on_new_turn()

func update_shadow(y):
	sprite.set_position(Vector2(current_tetromino.global_position.x, y - (Block.BLOCK_SIZE)))

func get_next_tetromino_index():
	
	if tetromino_indices_bag.empty():
		for i in range(Tetrominoes.NUMBER_OF_TETROMINOES):
			tetromino_indices_bag.append(i)
	
	var tetromino_index = tetromino_indices_bag[randi() % tetromino_indices_bag.size()]
	
	tetromino_indices_bag.erase(tetromino_index)
	
	return tetromino_index

func _on_FallTimer_timeout():
	
	if current_tetromino != null:
		current_tetromino.shift_down()

func _on_DelayTimer_timeout():
	
	initialize_game()
