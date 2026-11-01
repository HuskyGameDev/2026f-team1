extends Control

@onready var MoneyLabel = $MoneyLabel
@onready var ModTimer = $MoneyLabel/ModulateTimer

var lastvalue = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MoneyBus.money_update.connect(_on_money_update)

func _on_money_update(value: int):
	MoneyLabel.text = "$" + str(value)
	if value > lastvalue:
		MoneyLabel.modulate = Color(0.312, 0.579, 0.371, 1.0)
		ModTimer.start()
	elif value < lastvalue:
		MoneyLabel.modulate = Color(0.51, 0.139, 0.18, 1.0)
		ModTimer.start()

func _on_modulate_timer_timeout() -> void:
	MoneyLabel.modulate = Color(1.0, 1.0, 1.0, 1.0)
