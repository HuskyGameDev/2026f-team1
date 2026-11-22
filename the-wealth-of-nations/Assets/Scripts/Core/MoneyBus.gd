extends Node

signal money_update(money: int)

var money = 0

func get_value():
	return money

func set_value(value: int):
	money = value
	money_update.emit(money)

func flat_change(change: int):
	money += change
	money_update.emit(money)
