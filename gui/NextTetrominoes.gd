extends VBoxContainer

onready var tetromino_holders = [$TetrominoHolder1, $TetrominoHolder2, $TetrominoHolder3]

var current_head = -1

func add_tetromino(tetromino_index):
	
	# Next tetromino panels are full.
	if current_head >= tetromino_holders.size() - 1:
		return
	
	current_head += 1
	
	tetromino_holders[current_head].set_tetromino(tetromino_index)

func get_next_tetromino(new_tetromino_index):
	
	var next_tetromino = tetromino_holders[0].get_held_tetromino_index()
	
	# Push next tetrominoes up.
	for i in range(0, current_head):
		var next_tetromino_holder = tetromino_holders[i + 1]
		tetromino_holders[i].set_tetromino(next_tetromino_holder.get_held_tetromino_index())
		next_tetromino_holder.set_tetromino(-1)
	
	current_head -= 1
	
	add_tetromino(new_tetromino_index)
	
	return next_tetromino