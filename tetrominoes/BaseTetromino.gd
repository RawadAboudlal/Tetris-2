extends KinematicBody2D

const BLOCK_SIZE = 32

signal on_place()

func shift_down():
	_shift(Vector2(0, BLOCK_SIZE))

func shift_right():
	_shift(Vector2(BLOCK_SIZE, 0))

func shift_left():
	_shift(Vector2(-BLOCK_SIZE, 0))

func _shift(vector):
	var collision = move_and_collide(vector, true, true, true)
	
	if collision != null:
		var collider = collision.collider
		
		if ["Floor", "Blocks"].has(collider.get_name()):
			if collision.normal == Vector2.UP:
				emit_signal("on_place")
				
		elif collider.get_name() == "Walls":
			pass
		else:
			translate(vector)
	else:
		translate(vector)

# TODO: Test rotates if they do not collide.
func rotate_right():
	_rotate(PI / 2)

func rotate_left():
	_rotate(-PI / 2)

func _rotate(angle):
	for block in get_children():
		block.rotate(-angle)
	
	rotate(angle)
	
