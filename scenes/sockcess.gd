extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
signal animation_done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _playSockcess():
	visible=true
	animation_player.play("sockcess")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="sockcess":
		visible=false
		animation_done.emit()


func _on_exit_player_exited() -> void:
	_playSockcess()
