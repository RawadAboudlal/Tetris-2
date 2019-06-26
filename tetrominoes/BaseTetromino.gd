extends RigidBody2D

signal on_place()
signal update_ground_position(y)

export var width: int
export var height: int

func _physics_process(delta):
	
	if Input.is_action_just_pressed("rotate_right"):
		rotate_right()
	
	if Input.is_action_just_pressed("rotate_left"):
		rotate_left()
	
	if Input.is_action_just_pressed("shift_right"):
		shift_right()
	
	if Input.is_action_just_pressed("shift_left"):
		shift_left()
	
	var colliders = []
	
	for block in get_children():
		if block.ray.is_colliding():
			var collider = block.ray.get_collider()
			colliders.append(collider)
	
	var highest_object = null
	var highest_y = INF
	
	for collider in colliders:
		
		var current_y = collider.global_position.y
		
		if current_y < highest_y:
			highest_object = collider
			highest_y = current_y
	
	if highest_object == null:
		emit_signal("update_ground_position", -1)
	elif highest_y > self.global_position.y:
		emit_signal("update_ground_position", highest_y)
	

func _process(delta):
	for block in get_children():
		pass

func shift_down():
	_shift(Vector2(0, Block.BLOCK_SIZE))

func shift_right():
	_shift(Vector2(Block.BLOCK_SIZE, 0))

func shift_left():
	_shift(Vector2(-Block.BLOCK_SIZE, 0))

func _shift(vector):
	
	var collision_information = Physics2DTestMotionResult.new()
	var would_collide = test_motion(vector, true, 0.08, collision_information)
	
	if would_collide:
		
		if collision_information.get_collision_normal() == Vector2.UP:
			emit_signal("on_place")
	
	else:
		translate(vector)
	

func rotate_right():
	_rotate(PI / 2)

func rotate_left():
	_rotate(-PI / 2)

func _rotate(angle):
	
	#rotate(angle)
	#var would_collide = test_motion(Vector2(0, 0))
	#if would_collide:
	#	rotate(-angle)
	#else:
	#	update_block_rotations(angle)
	#return
	
	rotate(angle)
	
	var would_collide = test_motion(Vector2(0, 0))
	
	if would_collide:
		
		var maxOffset = int(max(width / 2, height / 2))
		
		var collision = Physics2DTestMotionResult.new()
	
		for offset in range(1, maxOffset + 1):
			
			offset = offset * Block.BLOCK_SIZE
			
			# Based on my testing, this "down kick" seems to cause things
			# to break when under stress... Guess we don't need it.
			#translate(Vector2(0, offset))
			
			#collision = move_and_collide(Vector2(0, 0), true, true, true)
			#would_collide = test_motion(Vector2(0, 0), true, 0.08, collision)
			
			#if !would_collide:
			#	print("Down kick worked, moved by: ", offset)
			#	update_block_rotations(angle)
			#	return
			
			#translate(Vector2(0, -offset))
			
			translate(Vector2(offset, 0))
			
			#collision = move_and_collide(Vector2(0, 0), true, true, true)
			would_collide = test_motion(Vector2(0, 0), true, 0.08, collision)
			
			if !would_collide:
				print("Right kick worked, moved by: ", offset)
				update_block_rotations(angle)
				return
			
			translate(Vector2(-offset, 0))
			
			# -2 to undo right move above.
			translate(Vector2(-offset, 0))
			
			would_collide = test_motion(Vector2(0, 0), true, 0.08, collision)
			
			#collision = move_and_collide(Vector2(0, 0), true, true, true)
			
			if !would_collide:
				print("Left kick worked, moved by: ", offset)
				update_block_rotations(angle)
				return
			
			translate(Vector2(offset, 0))
			
			translate(Vector2(0, -offset))
			
			#collision = move_and_collide(Vector2(0, 0), true, true, true)
			would_collide = test_motion(Vector2(0, 0), true, 0.08, collision)
			
			if !would_collide:
				print("Up kick worked, moved by: ", offset)
				update_block_rotations(angle)
				return
			
			translate(Vector2(0, offset))
			
		
		# Could not wall kick or t-spin so undo rotation.
		rotate(-angle)
		
	else:
		update_block_rotations(angle)
		
	
func update_block_rotations(angle):
	for block in get_children():
		block.safe_rotate(-angle)
	
