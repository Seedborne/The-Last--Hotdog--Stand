extends Control

func _ready():
	$VBoxContainerCustomers/CustomersServed.text = "Customers Served: " + str(Globals.customers_served)
	$VBoxContainerCustomers/CustomersLost.text = "Customers Lost: " + str(Globals.customers_lost)
	$VBoxContainerMoney/Sales.text = "Sales: $" + String("%0.2f" % Globals.daily_sales)
	$VBoxContainerMoney/Tips.text = "Tips: $" + String("%0.2f" % Globals.daily_tips)
	$VBoxContainerMoney/IngredientCost.text = "Ingredients Costs: $" + String("%0.2f" % Globals.daily_ingredients_cost)
	$VBoxContainerMoney/UnlockedIngredientCost.text = "Ingredients Unlock Costs: $" + String("%0.2f" % Globals.unlocked_ingredients_cost)
	$VBoxContainerMoney/TotalCurrency.text = "Total Currency: $" + String("%0.2f" % Globals.money)
	$VBoxContainerMoney/NetProfit.text = "Net Profit: $" + String("%0.2f" % Globals.get_net_profit())
	$VBoxContainerRep/ReputationPointsEarned.text = "Reputation Points Earned: " + str(Globals.reputation_points_earned)
	$VBoxContainerRep/SpeedBonus.text = "Speed Bonus Points: " + str(Globals.speed_bonus_earned)
	$VBoxContainerRep/ReputationPointsLost.text = "Reputation Points Lost: " + str(Globals.reputation_points_lost)
	$VBoxContainerRep/NetReputationGain.text = "Net Reputation Gain: " + str(Globals.get_net_reputation_gain())
	$VBoxContainerRep/TotalReputation.text = "Total Reputation Points: " + str(Globals.reputation)
	$VBoxContainerRep/ReputationTier.text = "Reputation Tier: " + str(Globals.reputation_tier)

func _on_next_day_button_pressed():
	Globals.reset_daily_metrics()
	get_tree().change_scene_to_file("res://scenes/hotdog_cart.tscn")
