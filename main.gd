extends Node

#preload obstacles
var man1 = preload("res://man_obstacle.tscn")
var man2 = preload("res://man_2.tscn")
var man3 = preload("res://man_3.tscn")
var spaceShip = preload("res://space_ship.tscn")
var obstacle_types := [man1, man2, man3]
var obstacles : Array
var spaceShip_heights := [200, 390]

#var score: int
const DINO_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)
const MAX_DIFFICULTY : int = 2
var speed: float
var difficulty
const START_SPEED: float = 4
const MAX_SPEED: int = 25
const SPEED_MODIFIER : int = 5000
var screen_size: Vector2i
var game_running : bool
var ground_height : int
var score : int
const SCORE_MODIFIER : int = 10
var high_score : int
var last_obs


func _ready():
	print("Ready function is called")  # Debug print
	screen_size = get_window().size
	ground_height = $ground.get_node("Sprite2D").texture.get_height()
	$GameOver.get_node("Button").pressed.connect(new_game)
	new_game()

func new_game():
	
	game_running = false
	get_tree().paused = false
	difficulty = 0
	# Reset variables
	score = 0
	show_score()
	
		#delete all obstacles
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	# Reset the nodes
	$CharacterBody2D.position = DINO_START_POS
	$CharacterBody2D.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$ground.position = Vector2i(0, 0)
	$scoreHUD.get_node("start").show()
	$GameOver.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
			
		
		generate_obs()
		
		$CharacterBody2D.position.x += speed
		$Camera2D.position.x += speed
		
		score += speed
		show_score()

		# Update ground position
		if $Camera2D.position.x - $ground.position.x > screen_size.x * 1.5:
			$ground.position.x += screen_size.x
			
		#remove obstacles that have gone off screen
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$scoreHUD.get_node("start").hide()

func show_score():
	$scoreHUD.get_node("score").text = "SCORE: " + str(score / SCORE_MODIFIER)


func generate_obs():
	#generate ground obstacles
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = difficulty + 2
		for i in range(randi() % max_obs + 1):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			var obs_x : int = screen_size.x + score + 100 + (i * 100)
			var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 5
			last_obs = obs
			add_obs(obs, obs_x, obs_y+330)
		# for spaceship
		if difficulty == MAX_DIFFICULTY:
			if (randi() % 2) == 0:
				obs = spaceShip.instantiate()
				var obs_x : int = screen_size.x + score + 100
				var obs_y : int = spaceShip_heights[randi() % spaceShip_heights.size()]
				add_obs(obs, obs_x, obs_y)


func add_obs(obs, x, y):
	# Check if the obstacle is man1 and adjust the x position
	#if obs == man1:
		#x += 20
	
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)
	
func hit_obs(body):
	if body.name == "CharacterBody2D":
		game_over()


func check_high_score():
	if score > high_score:
		high_score = score
		$scoreHUD.get_node("HSLabel").text = "HIGH SCORE: " + str(high_score / SCORE_MODIFIER)

func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func game_over():
	check_high_score()
	get_tree().paused = true
	game_running = false
	$GameOver.show()
