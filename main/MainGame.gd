extends Node2D

const BLOCK_SIZE = 32

onready var fall_timer = $FallTimer
onready var field = $Field
onready var spawn_position = $Field/SpawnPosition

var i_tetromino = preload("res://tetrominoes/I.tscn")
var j_tetromino = preload("res://tetrominoes/J.tscn")
var l_tetromino = preload("res://tetrominoes/L.tscn")
var o_tetromino = preload("res://tetrominoes/O.tscn")
var s_tetromino = preload("res://tetrominoes/S.tscn")
var t_tetromino = preload("res://tetrominoes/T.tscn")
var z_tetromino = preload("res://tetrominoes/Z.tscn")

var current_tetromino = null

func _ready():
	spawn_tetromino()
	fall_timer.start()

func _physics_process(delta):
	return
	var delta_x = 0
	
	if Input.is_action_just_pressed("shift_right"):
		delta_x += BLOCK_SIZE
	
	if Input.is_action_just_pressed("shift_left"):
		delta_x -= BLOCK_SIZE
	
	current_tetromino.translate(Vector2(delta_x, 0))
	
	pass

func _input(event):
	
	if event.is_action_pressed("rotate_right"):
		current_tetromino.rotate_right()
	
	if event.is_action_pressed("rotate_left"):
		current_tetromino.rotate_left()
	
	var delta_x = 0
	
	if event.is_action_pressed("shift_right"):
		current_tetromino.shift_right()
	
	if event.is_action_pressed("shift_left"):
		current_tetromino.shift_left()
	

func spawn_tetromino():
	
	current_tetromino = i_tetromino.instance()
	current_tetromino.translate(spawn_position.position)
	current_tetromino.connect("on_place", self, "place_tetromino")
	
	field.call_deferred("add_child", current_tetromino)

func place_tetromino():
	
	var blocks = current_tetromino.get_children()
	
	for block in blocks:
		
		var new_block = block.duplicate()
		new_block.transform = block.get_relative_transform_to_parent(field)
		
		field.get_node("Blocks").add_child(new_block)
	
	current_tetromino.queue_free()
	
	spawn_tetromino()

func _on_FallTimer_timeout():
	
	if current_tetromino != null:
		
		current_tetromino.shift_down()

func _on_DelayTimer_timeout():
	
	spawn_tetromino()
	
	fall_timer.start()
