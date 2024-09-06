extends Node

var main_theme = AudioStreamPlayer.new()
var location_background_audio = AudioStreamPlayer.new()
var unlock_sound = AudioStreamPlayer.new()

var money = 0.00
var reputation = 0

var current_location = "Community Park"
var current_day = 0
var customers_served = 0
var customers_lost = 0
var daily_sales = 0.0
var daily_tips = 0.0
var daily_ingredients_cost = 0.0
var unlocked_ingredients_cost = 0.0
var reputation_points_earned = 0
var speed_bonus_earned = 0
var reputation_points_lost = 0
var reputation_tier = "Bun Beginner"

var tutorial1 = false
var tutorial2 = false
var tutorial3 = false
var tutorial4 = false
var tutorial5 = false
var tutorial6 = false
var tutorial7 = false
var tutorial8 = false
var tutorial9 = false
var tutorial10 = false
var tutorial11 = false
var tutorial12 = false
var tutorial13 = false
var tutorial14 = false
var tutorial_part_complete = false
var tutorial_complete = false
var first_side_unlocked = false

var held_item = null
var order_correct = false
var current_speed_bonus = 0

var tray_contents = {
	"bun": "",
	"sausage": "",
	"toppings": [],
	"side": ""
}

var sausages = {
	"Hotdog": {"price": 4, "restock": 0.80, "unlocked": true, "reputation_value": 3},
	"Veggie Dog": {"price": 5, "restock": 1.00, "unlocked": false, "unlock_cost": 200, "reputation_value": 4},
	"Bratwurst": {"price": 5.50, "restock": 1.10, "unlocked": false, "unlock_cost": 300, "reputation_value": 5}
}

var buns = {
	"White Bun": {"price": 0, "restock": 0.10, "unlocked": true, "reputation_value": 2},
	"Whole Wheat Bun": {"price": 1, "restock": 0.20, "unlocked": false, "unlock_cost": 100, "reputation_value": 3},
	"Gluten Free Bun": {"price": 2, "restock": 0.40, "unlocked": false, "unlock_cost": 200, "reputation_value": 4}
}

var toppings = {
	"Ketchup": {"price": 0.50, "restock": 0.10, "unlocked": true, "reputation_value": 1},
	"Mustard": {"price": 0.50, "restock": 0.10, "unlocked": true, "reputation_value": 1},
	"Relish": {"price": 0.75, "restock": 0.15, "unlocked": false, "unlock_cost": 40, "reputation_value": 1},
	"Onions": {"price": 0.75, "restock": 0.15, "unlocked": false, "unlock_cost": 50, "reputation_value": 1},
	"Shredded Cheese": {"price": 0.75, "restock": 0.15, "unlocked": false, "unlock_cost": 80, "reputation_value": 1},
	"Jalapeños": {"price": 0.75, "restock": 0.15, "unlocked": false, "unlock_cost": 60, "reputation_value": 1},
	"Chili": {"price": 1, "restock": 0.20, "unlocked": false, "unlock_cost": 120, "reputation_value": 1},
	"Nacho Cheese": {"price": 1, "restock": 0.20, "unlocked": false, "unlock_cost": 100, "reputation_value": 1}
}

var sides = {
	"Potato Chips": {"price": 1.50, "restock": 0.30, "unlocked": false, "unlock_cost": 200, "reputation_value": 1},
	"Coleslaw": {"price": 2, "restock": 0.40, "unlocked": false, "unlock_cost": 250, "reputation_value": 2},
	"French Fries": {"price": 2.50, "restock": 0.50, "unlocked": false, "unlock_cost": 300, "reputation_value": 3},
	"Mac and Cheese": {"price": 4, "restock": 0.80, "unlocked": false, "unlock_cost": 500, "reputation_value": 4}
}

var park_patience = 20.0
var campus_patience = 20.0
var market_patience = 18.0
var boardwalk_patience = 18.0
var plaza_patience = 16.0
var carnival_patience = 16.0
var arena_patience = 15.0

var unlocked_campus = false
var unlocked_market = false
var unlocked_boardwalk = false
var unlocked_plaza = false
var unlocked_carnival = false
var unlocked_arena = false

func _ready():
	add_child(main_theme)
	add_child(location_background_audio)
	add_child(unlock_sound)
	
func play_main_theme():
	if not main_theme.is_playing():
		main_theme.stream = preload("res://assets/audio/mainthememusic.mp3")
		main_theme.volume_db = -4
		main_theme.play()

func stop_main_theme():
	if main_theme.is_playing():
		main_theme.stop()

func play_background_audio():
	if current_location == "Community Park":
		location_background_audio.stream = preload("res://assets/audio/park-background-audio.mp3")
		location_background_audio.volume_db = 26
		location_background_audio.play()
	if current_location == "College Campus":
		location_background_audio.stream = preload("res://assets/audio/campusbackgroundaudio.mp3")
		location_background_audio.play()
		location_background_audio.volume_db = 18
	if current_location == "Farmers Market":
		location_background_audio.stream = preload("res://assets/audio/marketbackgroundaudio.mp3")
		location_background_audio.play()
		location_background_audio.volume_db = 16
	if current_location == "Beach Boardwalk":
		location_background_audio.stream = preload("res://assets/audio/beachbackgroundaudio.mp3")
		location_background_audio.volume_db = 8
		location_background_audio.play()
	if current_location == "City Plaza":
		location_background_audio.stream = preload("res://assets/audio/citybackgroundaudio.mp3")
		location_background_audio.volume_db = 10
		location_background_audio.play()
	if current_location == "Carnival":
		location_background_audio.stream = preload("res://assets/audio/carnivalbackgroundaudio.mp3")
		location_background_audio.volume_db = 14
		location_background_audio.play()
	if current_location == "Sports Arena":
		location_background_audio.stream = preload("res://assets/audio/arenabackgroundaudio.mp3")
		location_background_audio.volume_db = -4
		location_background_audio.play()

func stop_background_audio():
	if location_background_audio.is_playing():
		location_background_audio.stop()

func update_money():
	var money_display = get_node("/root/HotdogCart/UI/MoneyDisplay")
	money_display.text = "Money: $" + str("%.2f" % money)

func update_reputation():
	var reputation_display = get_node("/root/HotdogCart/UI/ReputationDisplay")
	reputation_display.text = "Reputation: " + str(reputation)
	update_tier()

func reset_daily_metrics():
	customers_served = 0
	customers_lost = 0
	daily_sales = 0.0
	daily_tips = 0.0
	daily_ingredients_cost = 0.0
	unlocked_ingredients_cost = 0.0
	reputation_points_earned = 0
	speed_bonus_earned = 0
	reputation_points_lost = 0

func get_net_profit() -> float:
	return daily_sales + daily_tips - daily_ingredients_cost - unlocked_ingredients_cost

func get_net_reputation_gain() -> int:
	return reputation_points_earned + speed_bonus_earned - reputation_points_lost

func update_daily_ingredients_cost(item_type: String, item_name: String):
	match item_type:
		"sausage":
			daily_ingredients_cost += sausages[item_name]["restock"]
		"bun":
			daily_ingredients_cost += buns[item_name]["restock"]
		"topping":
			daily_ingredients_cost += toppings[item_name]["restock"]
		"side":
			daily_ingredients_cost += sides[item_name]["restock"]

func update_tier():
	var reputation_tier_label = get_node("/root/HotdogCart/UI/ReputationTier")
	if reputation <= 1000:
		reputation_tier_label.text = "Bun Beginner"
		reputation_tier = "Bun Beginner"
	if reputation >= 1001 and reputation <= 2000:
		reputation_tier_label.text = "Relish Rookie"
		reputation_tier = "Relish Rookie"
	if reputation >= 2001 and reputation <= 3000:
		reputation_tier_label.text = "Hotdog Hopeful"
		reputation_tier = "Hotdog Hopeful"
	if reputation >= 3001 and reputation <= 4000:
		reputation_tier_label.text = "Grill Greenhorn"
		reputation_tier = "Grill Greenhorn"
	if reputation >= 4001 and reputation <= 5000:
		reputation_tier_label.text = "Ketchup Connoisseur"
		reputation_tier = "Ketchup Connoisseur"
	if reputation >= 5001 and reputation <= 6000:
		reputation_tier_label.text = "Mustard Maestro"
		reputation_tier = "Mustard Maestro"
	if reputation >= 6001 and reputation <= 7000:
		reputation_tier_label.text = "Grill Guru"
		reputation_tier = "Grill Guru"
	if reputation >= 7001 and reputation <= 8000:
		reputation_tier_label.text = "Bun Boss"
		reputation_tier = "Bun Boss"
	if reputation >= 8001 and reputation <= 9000:
		reputation_tier_label.text = "Hotdog Hero"
		reputation_tier = "Hotdog Hero"
	if reputation >= 9001:
		reputation_tier_label.text = "Legendary Linkmaster"
		reputation_tier = "Legendary Linkmaster"
		
func generate_order() -> Dictionary:
	var available_sausages = []
	for sausage in sausages.keys():
		if sausages[sausage].unlocked:
			available_sausages.append(sausage)
	var available_buns = []
	for bun in buns.keys():
		if buns[bun].unlocked:
			available_buns.append(bun)
	var available_toppings = []
	for topping in toppings.keys():
		if toppings[topping].unlocked:
			available_toppings.append(topping)
	var available_sides = []
	for side in sides.keys():
		if sides[side].unlocked:
			available_sides.append(side)
	var sausage = available_sausages[randi() % available_sausages.size()]
	var bun = available_buns[randi() % available_buns.size()]
	var num_toppings = randi() % (available_toppings.size() + 1)
	var order_toppings = []
	for i in range(num_toppings):
		var topping = available_toppings[randi() % available_toppings.size()]
		if topping not in order_toppings:
			order_toppings.append(topping)
	var side = ""
	if available_sides.size() > 0 and randf() > 0.5:
		side = available_sides[randi() % available_sides.size()]
	return {
		"sausage": sausage,
		"bun": bun,
		"toppings": order_toppings,
		"side": side
	}

func unlock_ingredient(ingredient_type: String, ingredient_name: String) -> bool:
	var ingredient_dict = null
	match ingredient_type:
		"sausage":
			ingredient_dict = sausages
		"bun":
			ingredient_dict = buns
		"topping":
			ingredient_dict = toppings
		"side":
			ingredient_dict = sides
		
	if ingredient_dict and ingredient_name in ingredient_dict:
		var ingredient = ingredient_dict[ingredient_name]
		if not ingredient.unlocked and money >= ingredient.unlock_cost:
			money -= ingredient.unlock_cost
			update_money()
			ingredient.unlocked = true
			unlocked_ingredients_cost += ingredient.unlock_cost
			unlock_sound.stream = preload("res://assets/audio/unlock_sound.mp3")
			unlock_sound.volume_db = 8
			unlock_sound.play()
			if ingredient_type == "side" and not Globals.first_side_unlocked:
				Globals.first_side_unlocked = true
				var main_scene = get_tree().root.get_node("HotdogCart")  # Adjust this path to your main scene
				var first_side_label = main_scene.get_node("FirstSideTutorial")  # Adjust this path to your label node
				first_side_label.show()
			return true
	return false

func add_to_tray(item: String, type: String):
	print(item, " ADDED")
	if type == "bun":
		tray_contents["bun"] = item
		money -= buns[item]["restock"]
	elif type == "sausage":
		tray_contents["sausage"] = item
		money -= sausages[item]["restock"]
	elif type == "topping":
		if item not in tray_contents["toppings"]:
			tray_contents["toppings"].append(item)
			money -= toppings[item]["restock"]
	elif type == "side":
		tray_contents["side"] = item
		money -= sides[item]["restock"]
	print("Current money: $", money)
	Globals.update_money() #maybe don't update live so to provide update at end of level, but on for testing

func clear_tray():
	tray_contents = {
		"bun": "",
		"sausage": "",
		"toppings": [],
		"side": ""
	}

func get_order_value(order: Dictionary) -> float:
	var total_value = 0.00
	if order.has("sausage") and order["sausage"] in sausages:
		total_value += sausages[order["sausage"]]["price"]
	if order.has("bun") and order["bun"] in buns:
		total_value += buns[order["bun"]]["price"]
	for topping in order["toppings"]:
		if topping in toppings:
			total_value += toppings[topping]["price"]
	if order.has("side") and order["side"] in sides and order["side"] != "":
		total_value += sides[order["side"]]["price"]
	return total_value

func get_order_reputation(order):
	var total_reputation = 0
	if order.has("sausage") and order["sausage"] in sausages:
		total_reputation += sausages[order["sausage"]]["reputation_value"]
	if order.has("bun") and order["bun"] in buns:
		total_reputation += buns[order["bun"]]["reputation_value"]
	for topping in order["toppings"]:
		if topping in toppings:
			total_reputation += toppings[topping]["reputation_value"]
	if order.has("side") and order["side"] in sides and order["side"] != "":
		total_reputation += sides[order["side"]]["reputation_value"]
	return total_reputation
	
func add_tip(order: float) -> float:
	var tip = 0.0
	if current_location == "Community Park":
		tip = order * 0.1
	elif current_location == "College Campus":
		tip = order * 0.2
	elif current_location == "Farmers Market":
		tip = order * 0.3
	elif current_location == "Beach Boardwalk":
		tip = order * 0.4
	elif current_location == "City Plaza":
		tip = order * 0.5
	elif current_location == "Carnival":
		tip = order * 0.6
	elif current_location == "Sports Arena":
		tip = order * 0.8
	Globals.money += tip
	update_money()
	daily_tips += tip
	print("Tip added: $" + String("%0.2f" % tip))
	return tip

func save_game():
	var save_data = {
		"money": money,
		"reputation": reputation,
		"current_location": current_location,
		"current_day": current_day,
		"tutorial_complete": tutorial_complete,
		"tutorial_part_complete": tutorial_part_complete,
		"first_side_unlocked": first_side_unlocked,
		"unlocked_ingredients": {
			"sausages": sausages,
			"buns": buns,
			"toppings": toppings,
			"sides": sides
		},
		"unlocked_locations": {
			"campus": unlocked_campus,
			"market": unlocked_market,
			"boardwalk": unlocked_boardwalk,
			"plaza": unlocked_plaza,
			"carnival": unlocked_carnival,
			"arena": unlocked_arena
		}
	}
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_var(save_data)
	file.close()
	print("Game saved")

func load_game():
	var save_data = {}
	if FileAccess.file_exists("user://save_game.dat"):
		var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
		save_data = file.get_var()
		file.close()

		money = save_data.money
		reputation = save_data.reputation
		current_location = save_data.current_location
		current_day = save_data.current_day
		tutorial_complete = save_data.tutorial_complete
		tutorial_part_complete = save_data.tutorial_part_complete
		first_side_unlocked = save_data.first_side_unlocked
		sausages = save_data.unlocked_ingredients.sausages
		buns = save_data.unlocked_ingredients.buns
		toppings = save_data.unlocked_ingredients.toppings
		sides = save_data.unlocked_ingredients.sides
		unlocked_campus = save_data.unlocked_locations.campus
		unlocked_market = save_data.unlocked_locations.market
		unlocked_boardwalk = save_data.unlocked_locations.boardwalk
		unlocked_plaza = save_data.unlocked_locations.plaza
		unlocked_carnival = save_data.unlocked_locations.carnival
		unlocked_arena = save_data.unlocked_locations.arena
		get_tree().change_scene_to_file("res://scenes/hotdog_cart.tscn")
		print("Game loaded")
	else:
		print("Failed to load game")
