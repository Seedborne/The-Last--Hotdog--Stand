extends Node

var money = 0.00
var reputation = 0
var held_item = null

var tray_contents = {
	"bun": "",
	"sausage": "",
	"toppings": [],
	"side": ""
}

var sausages = {
	"Regular Hot Dog": {"price": 4, "restock": 0.80, "unlocked": true},
	"Veggie Dog": {"price": 5, "restock": 1.00, "unlocked": false, "unlock_cost": 200},
	"Bratwurst": {"price": 5.50, "restock": 1.10, "unlocked": false, "unlock_cost": 300}
}

var buns = {
	"White Bun": {"price": 0, "restock": 0.10, "unlocked": true},
	"Whole Wheat Bun": {"price": 1, "restock": 0.20, "unlocked": false, "unlock_cost": 100},
	"Gluten Free Bun": {"price": 2, "restock": 0.40, "unlocked": false, "unlock_cost": 200}
}

var toppings = {
	"Ketchup": {"price": 0.50, "restock": 0.10, "unlocked": true},
	"Mustard": {"price": 0.50, "restock": 0.10, "unlocked": true},
	"Relish": {"price": 0.75, "restock": 0.15, "unlocked": false, "unlock_cost": 40},
	"Onions": {"price": 0.75, "restock": 0.15, "unlocked": false, "unlock_cost": 50},
	"Shredded Cheese": {"price": 0.75, "restock": 0.15, "unlocked": false, "unlock_cost": 80},
	"Jalapeños": {"price": 0.75, "restock": 0.15, "unlocked": false, "unlock_cost": 60},
	"Chili": {"price": 1, "restock": 0.20, "unlocked": false, "unlock_cost": 120},
	"Nacho Cheese": {"price": 1, "restock": 0.20, "unlocked": false, "unlock_cost": 100}
}

var sides = {
	"Potato Chips": {"price": 1.50, "restock": 0.30, "unlocked": false, "unlock_cost": 200},
	"Coleslaw": {"price": 2, "restock": 0.40, "unlocked": false, "unlock_cost": 250},
	"French Fries": {"price": 2.50, "restock": 0.50, "unlocked": false, "unlock_cost": 300},
	"Mac and Cheese": {"price": 4, "restock": 0.80, "unlocked": false, "unlock_cost": 500}
}

var park_patience = 18.0
var campus_patience = 15.0
var market_patience = 15.0
var boardwalk_patience = 14.0
var plaza_patience = 12.0
var carnival_patience = 12.0
var arena_patience = 10.0

func update_money():
	var money_display = get_node("/root/HotdogCart/UI/MoneyDisplay")
	money_display.text = "Money: $" + str("%.2f" % money)

func update_reputation(points):
	var reputation_display = get_node("/root/HotdogCart/UI/ReputationDisplay")
	reputation += points
	reputation_display.text = "Reputation: " + str(reputation)

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
	if available_sides.size() > 0 and randf() > 0.4:
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
	print("Current money: ", money)
	Globals.update_money() #maybe don't update live so to provide update at end of level, but on for testing

func clear_tray():
	tray_contents = {
		"bun": "",
		"sausage": "",
		"toppings": [],
		"side": ""
	}

func get_order_value(order):
	var total_value = 0
	total_value += sausages[order["sausage"]]["price"]
	total_value += buns[order["bun"]]["price"]
	for topping in order["toppings"]:
		total_value += toppings[topping]["price"]
	if order["side"] != "":
		total_value += sides[order["side"]]["price"]
	return total_value
