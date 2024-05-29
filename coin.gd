extends Area2D

@onready var audio_stream_player_2d = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("spin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	audio_stream_player_2d.play()
