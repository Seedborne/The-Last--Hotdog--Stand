extends Control

func _ready():
	$VBoxContainerCustomers/CustomersServed.text = "Customers Served: " + str(Globals.customers_served)
	$VBoxContainerCustomers/CustomersLost.text = "Customers Lost: " + str(Globals.customers_lost)
	$VBoxContainerMoney/Sales.text = "Sales: $" + String("%0.2f" % Globals.daily_sales)
	$VBoxContainerMoney/Tips.text = "Tips: $" + String("%0.2f" % Globals.daily_tips)
	$VBoxContainerMoney/TotalIncome.text = "Total Income: $" + String("%0.2f" % (Globals.daily_sales + Globals.daily_tips))
	$VBoxContainerMoney/IngredientsCost.text = "Ingredients Costs: $" + String("%0.2f" % Globals.daily_ingredients_cost)
	if Globals.new_permit_cost > 0:
		$VBoxContainerMoney/NewPermitCost.text = "New Permit Costs: $" + String("%0.2f" % Globals.new_permit_cost)
	else:
		$VBoxContainerMoney/NewPermitCost.hide()
	$VBoxContainerMoney/NetProfit.text = "Net Profit: $" + String("%0.2f" % Globals.get_net_profit())
	$VBoxContainerRep/ReputationPointsEarned.text = "Reputation Points Earned: " + str(Globals.reputation_points_earned)
	$VBoxContainerRep/SpeedBonus.text = "Speed Bonus Points: " + str(Globals.speed_bonus_earned)
	$VBoxContainerRep/ReputationPointsLost.text = "Reputation Points Lost: " + str(Globals.reputation_points_lost)
	$VBoxContainerRep/NetReputationGain.text = "Net Reputation Gain: " + str(Globals.get_net_reputation_gain())
	$VBoxContainerRep/TotalReputation.text = "Current Reputation Points: " + str(Globals.reputation)
	$VBoxContainerRep/ReputationTier.text = "Reputation Tier: " + Globals.get_reputation_tier()

func _on_next_day_button_pressed():
	Globals.reset_daily_metrics()
	get_tree().change_scene_to_file("res://scenes/hotdog_cart.tscn")
