extends Node

var sausages = {
	"Regular Hot Dog": {"price": 4, "restock": 0.80, "unlocked": true},
	"Veggie Dog": {"price": 5, "restock": 1.00, "unlocked": true},
	"Bratwurst": {"price": 5.50, "restock": 1.10, "unlocked": true}
}

var buns = {
	"White Bun": {"price": 0, "restock": 0.10, "unlocked": true},
	"Whole Wheat Bun": {"price": 1, "restock": 0.20, "unlocked": true},
	"Gluten Free Bun": {"price": 2, "restock": 0.40, "unlocked": true}
}

var toppings = {
	"Ketchup": {"price": 0.50, "restock": 0.10, "unlocked": true},
	"Mustard": {"price": 0.50, "restock": 0.10, "unlocked": true},
	"Relish": {"price": 0.75, "restock": 0.15, "unlocked": true},
	"Onions": {"price": 0.75, "restock": 0.15, "unlocked": true},
	"Shredded Cheese": {"price": 0.75, "restock": 0.15, "unlocked": true},
	"Jalapeños": {"price": 0.75, "restock": 0.15, "unlocked": true},
	"Chili": {"price": 1, "restock": 0.20, "unlocked": true},
	"Nacho Cheese": {"price": 1, "restock": 0.20, "unlocked": true}
}

var sides = {
	"Potato Chips": {"price": 1.50, "restock": 0.30, "unlocked": true},
	"Coleslaw": {"price": 2, "restock": 0.40, "unlocked": true},
	"French Fries": {"price": 2.50, "restock": 0.50, "unlocked": true},
	"Mac and Cheese": {"price": 4, "restock": 0.80, "unlocked": true}
}

var money = 0
var reputation = 0 

func update_money(amount):
	var money_display = get_node("/root/CommunityPark/UI/MoneyDisplay")
	money += amount
	money_display.text = "Money: $" + str(money)

func update_reputation(points):
	var reputation_display = get_node("/root/CommunityPark/UI/ReputationDisplay")
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
