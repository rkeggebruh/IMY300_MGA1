extends Node

var score: int
const DINO_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)

var speed: float
const START_SPEED: float = 4.0
const MAX_SPEED: int = 25
var screen_size: Vector2i

func _init():
	print("Script is initialized")  # Debug print

func _enter_tree():
	print("Node entered the scene tree")  # Debug print

func _ready():
	print("Ready function is called")  # Debug print
	screen_size = get_window().size
	new_game()

func new_game():
	print("in newgame")  # Debug print
	# Reset variables
	score = 0
	# Reset the nodes
	$CharacterBody2D.position = DINO_START_POS
	$CharacterBody2D.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$ground.position = Vector2i(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = START_SPEED
	$CharacterBody2D.position.x += speed
	$Camera2D.position.x += speed

	# Update ground position
	if $Camera2D.position.x - $ground.position.x > screen_size.x * 1.5:
		$ground.position.x += screen_size.x
