extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var canvas=get_canvas_transform()
	var top_left=-canvas.origin/canvas.get_scale()
	var size =get_viewport_rect().size / canvas.get_scale()
	global_position.x=top_left.x +size.x/2
	global_position.y=top_left.y + 100
	process_material.emission_box_extents=Vector3(size.x,50,1)
