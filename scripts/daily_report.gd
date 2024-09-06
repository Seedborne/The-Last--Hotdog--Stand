extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Globals.stop_background_audio()
	$VBoxContainerCustomers/CurrentDay.text = "Day: " + str(Globals.current_day)
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
	if not Globals.tutorial13 and not Globals.tutorial_complete:
		$ReportBackground/Tutorial.show()
	if Globals.tutorial14 and not Globals.tutorial_complete:
		$ReportBackground/TutorialComplete.show()
		Globals.tutorial_complete = true

func _on_next_day_button_pressed():
	Globals.reset_daily_metrics()
	get_tree().change_scene_to_file("res://scenes/hotdog_cart.tscn")

func _on_permits_button_pressed():
	if not Globals.tutorial13 and not Globals.tutorial_complete:
		Globals.tutorial13 = true
		$ReportBackground/Tutorial.hide()
	get_tree().change_scene_to_file("res://scenes/permit_shop.tscn")
	

func _on_save_button_pressed():
	Globals.save_game()
	$SaveNotificationTimer.start()

func _on_save_notification_timer_timeout():
	$SaveNotification.show()
	$SaveNotificationTimer2.start()

func _on_save_notification_timer_2_timeout():
	$SaveNotification.hide()

func _on_save_quit_button_pressed():
	Globals.save_game()
	get_tree().quit()



