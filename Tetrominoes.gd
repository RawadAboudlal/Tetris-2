extends Node

const NUMBER_OF_TETROMINOES = 7

onready var i_tetromino = preload("res://tetrominoes/I.tscn")
onready var j_tetromino = preload("res://tetrominoes/J.tscn")
onready var l_tetromino = preload("res://tetrominoes/L.tscn")
onready var o_tetromino = preload("res://tetrominoes/O.tscn")
onready var s_tetromino = preload("res://tetrominoes/S.tscn")
onready var t_tetromino = preload("res://tetrominoes/T.tscn")
onready var z_tetromino = preload("res://tetrominoes/Z.tscn")

onready var i_placeholder = preload("res://gui/tetrominoes/PlaceHolderI.tscn")
onready var j_placeholder = preload("res://gui/tetrominoes/PlaceHolderJ.tscn")
onready var l_placeholder = preload("res://gui/tetrominoes/PlaceHolderL.tscn")
onready var o_placeholder = preload("res://gui/tetrominoes/PlaceHolderO.tscn")
onready var s_placeholder = preload("res://gui/tetrominoes/PlaceHolderS.tscn")
onready var t_placeholder = preload("res://gui/tetrominoes/PlaceHolderT.tscn")
onready var z_placeholder = preload("res://gui/tetrominoes/PlaceHolderZ.tscn")

onready var controllable_tetrominoes = [i_tetromino, j_tetromino, l_tetromino, o_tetromino, s_tetromino, t_tetromino, z_tetromino]
onready var placeholder_tetrominoes = [i_placeholder, j_placeholder, l_placeholder, o_placeholder, s_placeholder, t_placeholder, z_placeholder, ]

func create_controllable_tetromino(tetromino_index):
	return controllable_tetrominoes[tetromino_index].instance()

func create_placeholder_tetromino(tetromino_index):
	return placeholder_tetrominoes[tetromino_index].instance()