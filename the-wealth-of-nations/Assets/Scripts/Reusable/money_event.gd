extends Node

func runEvent(input: Array):
	if input.size() > 0:
		print("Changing money with input!")
		MoneyBus.flat_change(input[0])
		return
	MoneyBus.flat_change(100)
