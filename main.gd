extends Node

#@onready var hit = $hit
@onready var coin = $coin


# preload obstacles
var man1 = preload("res://man_obstacle.tscn")
var man2 = preload("res://man_2.tscn")
var man3 = preload("res://man_3.tscn")
#var spaceShip = preload("res://space_ship.tscn")
var spaceShip = preload("res://ufo.tscn")
var obstacle_types := [man1, man2, man3]
var obstacles : Array = []
var spaceShip_heights := [100, 390]
var coinCount = 0

var counter = 0

#var rock1 = $StaticBody2D
#var rock2 = $rock3
var rock1 = preload("res://rock_static.tscn")
var rock2 = preload("res://rock_3.tscn")
#var rock3 = preload("res://long_rock.tscn")
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

var longrk1 = preload("res://long_rock.tscn")
var longrk2 = preload("res://long_rock.tscn")
var longrk3 = preload("res://long_rock.tscn")
var lockRocks := [longrk1, longrk2, longrk3]
var longRocksArr : Array = []
var last_longRock

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

@onready var hit = $hit


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
	
	# delete all coins
	for coin in coinsArr:
		coin.queue_free()
	coinsArr.clear()
	
	## delete all rocks
	#for rock in rocksArr:
		#rock.queue_free()
	#rocksArr.clear()
	
	# delete all Longrocks
	for rock in longRocksArr:
		rock.queue_free()
	longRocksArr.clear()
	
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
		#generate_rocksPU()
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
		
		## remove rocks that have gone off screen
		for rock in longRocksArr:
			if rock.position.x < ($Camera2D.position.x - screen_size.x):
				rock.queue_free()
				longRocksArr.erase(rock)
		
		## remove rocks that have gone off screen
		for coin in coinsArr:
			if coin.position.x < ($Camera2D.position.x - screen_size.x):
				coin.queue_free()
				coinsArr.erase(coin)
				
		
		if $CharacterBody2D.position.x < $Camera2D.position.x - screen_size.x / 2:
			game_over()
		
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
			var obs_x : int = screen_size.x + score + 100 + (i * 50) + 540
			var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 15
			last_obs = obs
			#print("------------------ get here ")
			add_obs(obs, obs_x, obs_y + 330)
		
		# for spaceship
		if score > 13500:
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
	#print("------------------ adding obs at y ")s
	#print(y)
	#x = x + randi_range(150, 450)
	obs.position = Vector2i(x, y)
	obs.get_node("CollisionPolygon2D").disabled = false
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)



func generate_rocks():
	#print("in NORMAL rocks")
	#var rando = randi_range(800, 1300)
	#if rocksArr.is_empty() or last_rock.position.x < score - rando:
	#print("score: ")
	#print(score)
	if score > 3600:
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
#CHANGE LATER
	if score > 7200:
		var rando = randi_range(800, 1300)
		if puArr.is_empty() or last_pu.position.x < score - rando:
			var puA = puA[randi() % puA.size()]
			var obs
			var max_obs = 1
			for i in range(randi() % max_obs + 1):
				obs = puA.instantiate()
				var obs_height = 50
				var obs_scale = 50
				var obs_x : int = screen_size.x + score + 950
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
	generate_rocksPUforNo()


func generate_rocksPUforNo():
	for i in range(0, 3):
		generate_rocksPU()


func generate_rocksPU():
	print("in rocks PUUUUUUUUUUUUUUUUUUUUUu")
	if score > 3500:
		var rando = randi_range(800, 1300)
		if longRocksArr.is_empty() or last_longRock.position.x < score - rando:
			var lockRocks = lockRocks[randi() % lockRocks.size()]
			var obs
			var max_obs = 1
			for i in range(randi() % max_obs + 1):
				obs = lockRocks.instantiate()
				var obs_height = 50
				var obs_scale = 50
				var obs_x : int = screen_size.x + score + 700
				var obs_y
				if i % 3 == 0:
					obs_y = screen_size.y - ground_height - 100
				else:
					obs_y = screen_size.y - ground_height - 50
				last_longRock = obs
				add_Lrock(obs, obs_x, obs_y-200)
				#add_rocks(obs, obs_x-200, obs_y)

func add_Lrock(obs, x, y):
	print("add LONG rock func ------------------ at ")
	print(x)
	print(y)
	obs.position = Vector2i(x, y)
	#add_child(obs)
	call_deferred("add_child", obs)
	longRocksArr.append(obs)
	add_rocks(obs, x-200, y)

func add_rocks(obs, x, y):
	print("add rock func ------------------")
	print(x)
	print(y)
	obs.position = Vector2i(x, y)
	#add_child(obs)
	call_deferred("add_child", obs)
	rocksArr.append(obs)



func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)

func hit_obs(body):
	if body.name == "CharacterBody2D":
		print("------------------ character hit an ob ")
		game_running = false
		#hit.play()
		#$hit.play()
		#await get_tree().create_timer(1.0).timeout
		#$hit.play()
		game_over()

#func _on_hit_finished():
	#print("SOUND DONE ")
	##game_over()
	##$hit.play()


func check_high_score():
	if score > high_score:
		high_score = score
		$scoreHUD.get_node("HSLabel").text = "HIGH SCORE: " + str(high_score / SCORE_MODIFIER)

func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func game_over():
	$hit.play()
	check_high_score()
	get_tree().paused = true
	game_running = false
	coinCount = 0
	$GameOver.show()
	










