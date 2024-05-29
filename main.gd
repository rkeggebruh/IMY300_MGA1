#extends Node
#
##preload obstacles
#var man1 = preload("res://man_obstacle.tscn")
#var man2 = preload("res://man_2.tscn")
#var man3 = preload("res://man_3.tscn")
#var spaceShip = preload("res://space_ship.tscn")
#var obstacle_types := [man1, man2, man3]
#var obstacles : Array
#var spaceShip_heights := [200, 390]
#
#var floatRock = preload("res://rock.tscn")
#
##var score: int
#const DINO_START_POS := Vector2i(150, 485)
#const CAM_START_POS := Vector2i(576, 324)
#const MAX_DIFFICULTY : int = 2
#var speed: float
#var difficulty
#const START_SPEED: float = 4
#const MAX_SPEED: int = 25
#const SPEED_MODIFIER : int = 5000
#var screen_size: Vector2i
#var game_running : bool
#var ground_height : int
#var score : int
#const SCORE_MODIFIER : int = 10
#var high_score : int
#var last_obs
#
#var rock
#
#
#func _ready():
	#print("Ready function is called")  # Debug print
	#screen_size = get_window().size
	#ground_height = $ground.get_node("Sprite2D").texture.get_height()
	#$GameOver.get_node("Button").pressed.connect(new_game)
	#new_game()
#
#func new_game():
	#
	#game_running = false
	#get_tree().paused = false
	#difficulty = 0
	## Reset variables
	#score = 0
	#show_score()
	#
		##delete all obstacles
	#for obs in obstacles:
		#obs.queue_free()
	#obstacles.clear()
	#
	## Reset the nodes
	#$CharacterBody2D.position = DINO_START_POS
	#$CharacterBody2D.velocity = Vector2i(0, 0)
	#$Camera2D.position = CAM_START_POS
	#$ground.position = Vector2i(0, 0)
	#$scoreHUD.get_node("start").show()
	#$GameOver.hide()
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if game_running:
		#speed = START_SPEED + score / SPEED_MODIFIER
		#if speed > MAX_SPEED:
			#speed = MAX_SPEED
			#
		#
		#generate_obs()
		#
		#$CharacterBody2D.position.x += speed
		##$CharacterBody2D.position.y -= 1
		#$Camera2D.position.x += speed
		#
		#score += speed
		#show_score()
#
		## Update ground position
		#if $Camera2D.position.x - $ground.position.x > screen_size.x * 1.5:
			#$ground.position.x += screen_size.x
			#
		##remove obstacles that have gone off screen
		#for obs in obstacles:
			#if obs.position.x < ($Camera2D.position.x - screen_size.x):
				#remove_obs(obs)
	#else:
		#if Input.is_action_pressed("ui_accept"):
			#game_running = true
			#$scoreHUD.get_node("start").hide()
#
#func show_score():
	#$scoreHUD.get_node("score").text = "SCORE: " + str(score / SCORE_MODIFIER)
#
#
#func generate_obs():
	##generate ground obstacles
	#if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		#var obs_type = obstacle_types[randi() % obstacle_types.size()]
		#var obs
		#var max_obs = difficulty + 2
		#for i in range(randi() % max_obs + 1):
			#obs = obs_type.instantiate()
			#var obs_height = obs.get_node("Sprite2D").texture.get_height()
			#var obs_scale = obs.get_node("Sprite2D").scale
			#var obs_x : int = screen_size.x + score + 100 + (i * 100)
			#var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 5
			#last_obs = obs
			#add_obs(obs, obs_x, obs_y+330)
		## for spaceship
		#if difficulty == MAX_DIFFICULTY:
			#if (randi() % 2) == 0:
				#obs = spaceShip.instantiate()
				#var obs_x : int = screen_size.x + score + 100
				#var obs_y : int = spaceShip_heights[randi() % spaceShip_heights.size()]
				#add_obs(obs, obs_x, obs_y)
	 	#
		## for ROCK
		#if difficulty == 0:
			#rock = floatRock.instantiate()
			#var rock_x : int = screen_size.x + score + 200  # Adjust rock position as needed
			#var rock_y : int = screen_size.y - ground_height - 100  # Adjust rock position as needed
			#add_rock(rock, rock_x, rock_y)
#
#
#func add_obs(obs, x, y):
	#obs.position = Vector2i(x, y)
	#obs.body_entered.connect(hit_obs)
	#add_child(obs)
	#obstacles.append(obs)
#
#func add_rock(rock, x, y):
	#rock.position = Vector2i(x, y)
	#rock.get_node("CollisionPolygon2D").disabled = false  # Ensure the collision shape is enabled
	#rock.body_entered.connect(jump_off_rock)
	#add_child(rock)
	#obstacles.append(rock)
#
#func remove_obs(obs):
	#obs.queue_free()
	#obstacles.erase(obs)
	#
#func hit_obs(body):
	#if body.name == "CharacterBody2D":
		#game_over()
#
#func jump_off_rock(body):
	##if body.name == "CharacterBody2D":
		##rock.get_node("CollisionPolygon2D").call_deferred("set_disabled", true) 
		##$CharacterBody2D.position.y -= 50
	##rock.get_node("CollisionPolygon2D").disabled = true
	#while rock.body_entered:
		#$CharacterBody2D.position.y -= 50
	#
		#
#
#
#func check_high_score():
	#if score > high_score:
		#high_score = score
		#$scoreHUD.get_node("HSLabel").text = "HIGH SCORE: " + str(high_score / SCORE_MODIFIER)
#
#func adjust_difficulty():
	#difficulty = score / SPEED_MODIFIER
	#if difficulty > MAX_DIFFICULTY:
		#difficulty = MAX_DIFFICULTY
#
#func game_over():
	#check_high_score()
	#get_tree().paused = true
	#game_running = false
	#$GameOver.show()










#
#extends Node
#
## preload obstacles
#var man1 = preload("res://man_obstacle.tscn")
#var man2 = preload("res://man_2.tscn")
#var man3 = preload("res://man_3.tscn")
#var spaceShip = preload("res://space_ship.tscn")
#var obstacle_types := [man1, man2, man3]
#var obstacles : Array = []
#var spaceShip_heights := [200, 390]
#
#var floatRock = preload("res://rock.tscn")
#
#const DINO_START_POS := Vector2(150, 485)
#const CAM_START_POS := Vector2(576, 324)
#const MAX_DIFFICULTY : int = 2
#var speed: float
#var difficulty
#const START_SPEED: float = 4
#const MAX_SPEED: int = 25
#const SPEED_MODIFIER : int = 5000
#var screen_size: Vector2
#var game_running : bool
#var ground_height : int
#var score : int
#const SCORE_MODIFIER : int = 10
#var high_score : int
#var last_obs
#
#var rock
#
#func _ready():
	#print("Ready function is called")  # Debug print
	#screen_size = get_window().size
	#ground_height = $ground.get_node("Sprite2D").texture.get_height()
	#$GameOver.get_node("Button").pressed.connect(new_game)
	#new_game()
#
#func new_game():
	#game_running = false
	#get_tree().paused = false
	#difficulty = 0
	## Reset variables
	#score = 0
	#show_score()
	#
	## delete all obstacles
	#for obs in obstacles:
		#obs.queue_free()
	#obstacles.clear()
	#
	## Reset the nodes
	#$CharacterBody2D.position = DINO_START_POS
	#$CharacterBody2D.velocity = Vector2.ZERO
	#$Camera2D.position = CAM_START_POS
	#$ground.position = Vector2(0, 0)
	#$scoreHUD.get_node("start").show()
	#$GameOver.hide()
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if game_running:
		#speed = START_SPEED + score / SPEED_MODIFIER
		#if speed > MAX_SPEED:
			#speed = MAX_SPEED
			#
		#generate_obs()
		#
		#$CharacterBody2D.position.x += speed
		#$Camera2D.position.x += speed
		#
		#score += speed
		#show_score()
#
		## Update ground position
		#if $Camera2D.position.x - $ground.position.x > screen_size.x * 1.5:
			#$ground.position.x += screen_size.x
			#
		## remove obstacles that have gone off screen
		#for obs in obstacles:
			#if obs.position.x < ($Camera2D.position.x - screen_size.x):
				#remove_obs(obs)
	#else:
		#if Input.is_action_pressed("ui_accept"):
			#game_running = true
			#$scoreHUD.get_node("start").hide()
#
#func show_score():
	#$scoreHUD.get_node("score").text = "SCORE: " + str(score / SCORE_MODIFIER)
#
#func generate_obs():
	## generate ground obstacles
	#if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		#var obs_type = obstacle_types[randi() % obstacle_types.size()]
		#var obs
		#var max_obs = difficulty + 2
		#for i in range(randi() % max_obs + 1):
			#obs = obs_type.instantiate()
			#var obs_height = obs.get_node("Sprite2D").texture.get_height()
			#var obs_scale = obs.get_node("Sprite2D").scale
			#var obs_x : int = screen_size.x + score + 100 + (i * 100)
			#var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 5
			#last_obs = obs
			#add_obs(obs, obs_x, obs_y + 330)
		#
		## for spaceship
		#if difficulty == MAX_DIFFICULTY:
			#if (randi() % 2) == 0:
				#obs = spaceShip.instantiate()
				#var obs_x : int = screen_size.x + score + 100
				#var obs_y : int = spaceShip_heights[randi() % spaceShip_heights.size()]
				#add_obs(obs, obs_x, obs_y)
	 	#
		## for ROCK
		#if difficulty == 0:
			#rock = floatRock.instantiate()
			#var rock_x : int = screen_size.x + score + 200  # Adjust rock position as needed
			#var rock_y : int = screen_size.y - ground_height - 100  # Adjust rock position as needed
			#add_rock(rock, rock_x, rock_y)
#
#func add_obs(obs, x, y):
	#obs.position = Vector2(x, y)
	#obs.get_node("CollisionPolygon2D").disabled = false  # Ensure the collision shape is enabled
	##obs.connect("body_entered", self, "hit_obs")
	#obs.body_entered.connect(hit_obs)
	##rock.body_entered.connect(jump_off_rock)
	#add_child(obs)
	#obstacles.append(obs)
#
#func add_rock(rock, x, y):
	#rock.position = Vector2(x, y)
	#rock.get_node("CollisionPolygon2D").disabled = false  # Ensure the collision shape is enabled
	##rock.connect("body_entered", self, "jump_off_rock")
	#rock.body_entered.connect(jump_off_rock)
	#add_child(rock)
	#obstacles.append(rock)
#
#func remove_obs(obs):
	#obs.queue_free()
	#obstacles.erase(obs)
#
#func hit_obs(body):
	#if body.name == "CharacterBody2D":
		#game_over()
#
#func jump_off_rock(body):
	#if body.name == "CharacterBody2D":
		#var rock_polygon = rock.get_node("CollisionPolygon2D").polygon
		#var rock_height = 0.0
		#for point in rock_polygon:
			#if point.y > rock_height:
				#rock_height = point.y
		#$CharacterBody2D.position.y = rock.position.y - rock_height
#
#func check_high_score():
	#if score > high_score:
		#high_score = score
		#$scoreHUD.get_node("HSLabel").text = "HIGH SCORE: " + str(high_score / SCORE_MODIFIER)
#
#func adjust_difficulty():
	#difficulty = score / SPEED_MODIFIER
	#if difficulty > MAX_DIFFICULTY:
		#difficulty = MAX_DIFFICULTY
#
#func game_over():
	#check_high_score()
	#get_tree().paused = true
	#game_running = false
	#$GameOver.show()




extends Node

@onready var hit = $hit
@onready var coin = $coin


# preload obstacles
var man1 = preload("res://man_obstacle.tscn")
var man2 = preload("res://man_2.tscn")
var man3 = preload("res://man_3.tscn")
#var spaceShip = preload("res://space_ship.tscn")
var spaceShip = preload("res://ufo.tscn")
var obstacle_types := [man1, man2, man3]
var obstacles : Array = []
var spaceShip_heights := [150, 390]
var coinCount = 0

var counter = 0

#var rock1 = $StaticBody2D
#var rock2 = $rock3
var rock1 = preload("res://rock_static.tscn")
var rock2 = preload("res://rock_3.tscn")
var rock3 = preload("res://rock_4.tscn")
#var rock_types := [$StaticBody2D, $rock3]
var rocks := [rock1, rock2, rock3]
var rocksArr : Array = []
var last_rock

var coin1 = preload("res://coin.tscn")
var coin2 = preload("res://coin.tscn")
var coin3 = preload("res://coin.tscn")
var coins := [coin1, coin2, coin3]
var coinsArr : Array = []
var last_coin
var now_coin

#var floatRock = preload("res://rock.tscn")

const DINO_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)
const MAX_DIFFICULTY : int = 2
var speed: float
var difficulty
const START_SPEED: float = 4
const MAX_SPEED: int = 25
const SPEED_MODIFIER : int = 5000
var screen_size: Vector2
var game_running : bool
var ground_height : int
var score : int
const SCORE_MODIFIER : int = 10
var high_score : int
var last_obs

var rockPowerUp = preload("res://rock_pu.tscn")
var rockPowerUp2 = preload("res://rock_pu.tscn")
var puA := [rockPowerUp, rockPowerUp2]
var puArr : Array = []
var last_pu

#var rock
var on_rock : bool = false  # To track if the character is on the rock

func _ready():
	print("Ready function is called")  # Debug print
	screen_size = get_window().size
	ground_height = $ground.get_node("Sprite2D").texture.get_height()-380
	
	$GameOver.get_node("Button").pressed.connect(new_game)
	new_game()

func new_game():
	counter = 0
	game_running = false
	get_tree().paused = false
	difficulty = 0
	# Reset variables
	score = 0
	coinCount = 0
	show_score()
	$scoreHUD.get_node("coins").text = "coins: " + str(coinCount)
	
	# delete all obstacles
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

func _process(delta):
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
			
		generate_obs()
		generate_rocks()
		generate_coins()
		
		generate_PU()
	
		
		
		$CharacterBody2D.position.x += speed
		$Camera2D.position.x += speed
		
		score += speed
		show_score()

		# Update ground position
		if $Camera2D.position.x - $ground.position.x > screen_size.x * 1.5:
			$ground.position.x += screen_size.x
			
		# remove obstacles that have gone off screen
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
	# generate ground obstacles
	var rando = randi_range(100, 200)
	#print("rand ")
	#print(rando)
	if obstacles.is_empty() or last_obs.position.x < score + rando:
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = difficulty + 3
		for i in range(randi() % max_obs + 1):
			#print("------------------ get here ")
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			var obs_x : int = screen_size.x + score + 100 + (i * 50)
			var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 15
			last_obs = obs
			#print("------------------ get here ")
			add_obs(obs, obs_x, obs_y + 330)
		
		# for spaceship
		if score > 9500:
			if (randi() % 2) == 0:
				obs = spaceShip.instantiate()
				var obs_x : int = screen_size.x + score + 100
				var obs_y : int = spaceShip_heights[randi() % spaceShip_heights.size()]
				add_obs(obs, obs_x, obs_y)
	 	
		# for ROCK
		#if difficulty == 0:
			#$StaticBody2D.position.x = screen_size.x + score - 50
			#$StaticBody2D.position.y = screen_size.y - ground_height - 100
			#
			#$coin.position.x = screen_size.x + score - 50
			#$coin.position.y = screen_size.y - ground_height - (20 / 2) + 15
			
			#$rock3.position.x = screen_size.x + score - 800
			#$rock3.position.y = screen_size.y - ground_height - 50


func generate_coins():
	counter = counter + 1
	# generate ground coinsArr
	#print("in coin gen func")
	var rando = randi_range(300, 500)
	#print("counter ")
	#print(counter)
	if coinsArr.is_empty() or last_coin.position.x < score + rando:
		var coins = coins[randi() % coins.size()]
		var obs
		var max_obs = difficulty + 3
		for i in range(randi() % max_obs + 1):
			obs = coins.instantiate()
			var obs_height = 50
			var obs_scale = 50
			var obs_x : int = screen_size.x + score - 50
			#var obs_y : int = screen_size.y - ground_height - (20 / 2) + 15
			var obs_y : int = 0
			
			if counter%2 == 0:
				#print("counter%2 == 0")
				obs_y = screen_size.y - ground_height - 10
				last_coin = obs
				add_coins(obs, obs_x, obs_y)
			else:
				#print("counter%2 == 1")
				obs_y = screen_size.y - ground_height - 100
				last_coin = obs
				add_coins(obs, obs_x, obs_y)



func add_coins(obs, x, y):
	#print("add coin func ------------------")
	obs.position = Vector2i(x, y)
	obs.get_node("CollisionPolygon2D").disabled = false
	#obs.body_entered.connect(collect_coin)
	obs.body_entered.connect(func (body): collect_coin(body, obs))
	add_child(obs)
	coinsArr.append(obs)
	
func collect_coin(body, obs):
	obs.hide()
	coinCount = coinCount + 1;
	coin.play()
	
#func collect_coin(body):
	##obs.hide()
	#coinCount = coinCount + 1;
	#coin.play()
	##now_coin.hide() 
	#if body.name == "CharacterBody2D":
		#print("------------------ collect coin")

func _on_coin_finished():
	$scoreHUD.get_node("coins").text = "coins: " + str(coinCount)


func add_obs(obs, x, y):
	#print("------------------ adding obs at y ")
	#print(y)
	obs.position = Vector2i(x, y)
	obs.get_node("CollisionPolygon2D").disabled = false
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)



func generate_rocks():
	#print("score: ")
	#print(score)
	if score > 3500:
		var rando = randi_range(800, 1300)
		if rocksArr.is_empty() or last_rock.position.x < score - rando:
			var rocks = rocks[randi() % rocks.size()]
			var obs
			var max_obs = 1
			for i in range(randi() % max_obs + 1):
				obs = rocks.instantiate()
				var obs_height = 50
				var obs_scale = 50
				var obs_x : int = screen_size.x + score - 50
				var obs_y
				if i % 3 == 0:
					obs_y = screen_size.y - ground_height - 100
				else:
					obs_y = screen_size.y - ground_height - 50
				last_rock = obs
				add_rocks(obs, obs_x, obs_y)




func generate_PU():
	#print("score: ")
	#print(score)
	if score > 7900:
		var rando = randi_range(1200, 1300)
		if puArr.is_empty() or last_pu.position.x < score - rando:
			var puA = puA[randi() % puA.size()]
			var obs
			var max_obs = 1
			for i in range(randi() % max_obs + 1):
				obs = puA.instantiate()
				var obs_height = 50
				var obs_scale = 50
				var obs_x : int = screen_size.x + score - 50
				var obs_y
				if i % 3 == 0:
					obs_y = screen_size.y - ground_height - 100
				else:
					obs_y = screen_size.y - ground_height - 50
				last_pu = obs
				add_pu(obs, obs_x, obs_y)



func add_pu(obs, x, y):
	print("add pu func ------------------")
	obs.position = Vector2i(x, y)
	obs.get_node("CollisionPolygon2D").disabled = false
	obs.body_entered.connect(func (body): hit_pu(body, obs))
	add_child(obs)
	puArr.append(obs)


func hit_pu(body, obs):
	obs.hide()
	generate_rocksPU()


func generate_rocksPU():
	print("in rocks PUUUUUUUUUUUUUUUUUUUUUu")
	#print(score)
	if score > score + 6000:
		var rando = randi_range(10, 20)
		if rocksArr.is_empty() or last_rock.position.x < score - rando:
			var rocks = rocks[randi() % rocks.size()]
			var obs
			var max_obs = 1
			for i in range(randi() % max_obs + 1):
				obs = rocks.instantiate()
				var obs_height = 50
				var obs_scale = 50
				var obs_x : int = screen_size.x + score - 50
				var obs_y
				if i % 3 == 0:
					obs_y = screen_size.y - ground_height - 100
				else:
					obs_y = screen_size.y - ground_height - 50
				last_rock = obs
				add_pu(obs, obs_x, obs_y)


func add_rocks(obs, x, y):
	#print("add rock func ------------------")
	obs.position = Vector2i(x, y)
	add_child(obs)
	rocksArr.append(obs)



func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)

func hit_obs(body):
	if body.name == "CharacterBody2D":
		print("------------------ character hit an ob ")
		game_running = false
		hit.play()
		
		#game_over()

func _on_hit_finished():
	print("SOUND DONE ")
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
	coinCount = 0
	$GameOver.show()







