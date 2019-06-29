extends Control

var place_holder_tetromino

var held_tetromino_index = -1 setget ,get_held_tetromino_index

func set_tetromino(tetromino_index):
	if tetromino_index <= -1:
		held_tetromino_index = -1
		
		if place_holder_tetromino != null:
			place_holder_tetromino.queue_free()
		
	else:
		
		held_tetromino_index = tetromino_index
		
		if place_holder_tetromino != null:
			place_holder_tetromino.queue_free()
		
		place_holder_tetromino = Tetrominoes.create_placeholder_tetromino(held_tetromino_index)
		add_child(place_holder_tetromino)
		

func get_held_tetromino_index():
	return held_tetromino_index
