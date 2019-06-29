extends Control

onready var color_rect = $ColorRect

func set_pos_and_col(position, color):
	set_position(position)
	color_rect.set_frame_color(color)
