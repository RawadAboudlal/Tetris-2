extends StaticBody2D

onready var color_rect = $ColorRect

var color = null

func _ready():
	if color != null:
		color_rect.set_frame_color(color)

func set_block_color(color):
	self.color = color
