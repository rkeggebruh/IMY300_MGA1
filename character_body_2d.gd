extends CharacterBody2D

var GRAVITY : int = 5500
const JUMP_SPEED : int = -1800

@onready var jump = $jump


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_select"):
		jump.play()
			
	velocity.y += GRAVITY * delta
	if is_on_floor():
		#GRAVITY = 4200
		if not get_parent().game_running:
			$AnimatedSprite2D.play("idle")
		else:
			$runCol.disabled = false
			if Input.is_action_pressed("ui_accept"):
				velocity.y = JUMP_SPEED
				#$JumpSound.play()
			elif Input.is_action_pressed("ui_down"):
				#print("down pressed -------------------------------- DOWN")
				$AnimatedSprite2D.play("duck")
				$runCol.disabled = true
				#velocity.y += GRAVITY * delta
			else:
				$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")
		
	move_and_slide()
	
