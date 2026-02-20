extends Node2D

signal player_exited
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.gravity_scale=0
		body.linear_velocity = Vector2.ZERO
		body.angular_velocity = 0.0
		player_exited.emit()
