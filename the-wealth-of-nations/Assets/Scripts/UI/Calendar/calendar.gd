extends Control

#Timing
var TimeElapsed: float = 0.0
@export var DayLength: float = 1

#UI
@export var StartDate: String = "2100-01-01"
var date: Dictionary
var firstOfMonth: Dictionary
var monthNames: Array = ["Neveruary", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
var daysInMonth: Array = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
@onready var Calendar = $"."
@onready var MonthYearLabel = $"Window/MarginContainer/VBoxContainer/CalendarBG/MarginContainer/VBoxContainer/Month-Year/Label"
@onready var DayGrid = $Window/MarginContainer/VBoxContainer/CalendarBG/MarginContainer/VBoxContainer/Days/DayGrid
@onready var days: Array = DayGrid.get_children()

#Events
@onready var Events = $Events
enum EventModeList {Scheduled = 0, Random = 1, ScheduledRandom = 2}
@export var EventMode: EventModeList = EventModeList.Random
@export var StartingMinEvents: float = 0
@export var MinEventsScale: float = 0.1
@export var StartingMaxEvents: float = 3
@export var MaxEventsScale: float = 0.2
@export var EventWiggleMod: float = 5.0 ##A higher value means events deviate less from their usual, even placements in random modes.[br]Anything 3.0 or below invites potential overlap.
var random = RandomNumberGenerator.new()
var NumEvents: int = 0
var EventArray: Array = []
var EventMarkerArray: Array = []
var EventIndex: int = 0
var EventDict: Dictionary = {}

func _ready():
	date = Time.get_datetime_dict_from_datetime_string(StartDate, true)

	InitializeMonth(date)
	InitializeEvents()
	#InitializeEvents()
	#random.seed = 67
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	TimeElapsed += delta
	
	#region Day Timing and Event Initialization
	if TimeElapsed >= DayLength:
		TimeElapsed = 0
		date.day += 1
		UpdateCalendar(date)
		TimeBus.day_change.emit(date.day)
	
	if date.day > daysInMonth[date.month]:
		if date.month == 12:
			date.month = 1
			date.year += 1
			TimeBus.year_change.emit(date.year)
		else:
			date.month += 1
		date.day = 1
		
		TimeBus.month_change.emit(date.month)
		InitializeMonth(date)
		
		EventIndex = 0
		InitializeEvents()
	#endregion
	
	#region Events
	if EventArray.size() > EventIndex and date.day == EventArray[EventIndex]:
		print(snapped(EventArray[EventIndex], 0.01), ": ", EventDict[EventIndex], " triggered")
		EventDict[EventIndex].runEvent([])
		EventIndex += 1
	#endregion

func InitializeEvents():
	EventArray.clear()
	
	#print("-------")
	#print("Month: ", date.month)
	#print("Event MinMax ", StartingMinEvents + ((date.month - 1) * MinEventsScale), ", ", StartingMaxEvents + ((date.month - 1) * MaxEventsScale))
	
	match EventMode:
		EventModeList.Random:
			NumEvents = round(random.randf_range(StartingMinEvents + ((date.month - 1) * MinEventsScale), StartingMaxEvents + ((date.month - 1) * MaxEventsScale)))
			#print("Events: ", NumEvents)
			
			for i in range(NumEvents):
				var EventRange: int = daysInMonth[date.month] / NumEvents
				var EventDay: int = (i * EventRange) + random.randi_range(0, EventRange)
				if EventDay < 1:
					EventDay = 1
				EventArray.append(EventDay)
				
				var Event: Node = Events.get_children().pick_random()
				EventDict[i] = Event
				
				print("Event added: ", Event, " @", EventArray[i])
				
		EventModeList.Scheduled:
			NumEvents = 0
			
		EventModeList.ScheduledRandom:
			NumEvents = 0
			

func InitializeMonth(initdate: Dictionary):
	MonthYearLabel.text = monthNames[date.month] + " - " + str(date.year)
	firstOfMonth = Time.get_datetime_dict_from_datetime_string(str(initdate.year) + "-" + str(initdate.month) + "-01", true)
	print(firstOfMonth)
	var maximum: int = firstOfMonth.weekday + daysInMonth[initdate.month]
	if initdate.month == 2 and initdate.year % 4 == 0 and (initdate.year % 100 != 0 or initdate.year == 0):
		print("leap")
		maximum += 1
	for i in range(42):
		if i < firstOfMonth.weekday:
			days[i].color = Color(0,0,0,0)
		elif i < initdate.day + firstOfMonth.weekday - 1:
			days[i].color = Color(0.50, 0.50, 0.50, 1.0)
		elif i == initdate.day + firstOfMonth.weekday - 1:
			days[i].color = Color(1.0, 0.541, 0.477, 1.0)
		elif i < maximum:
			days[i].color = Color(1, 1, 1, 1.0)
		else:
			days[i].color = Color(0,0,0,0)

func UpdateCalendar(update: Dictionary):
	DayGrid.get_child(update.day + firstOfMonth.weekday - 1).color = Color(1.0, 0.541, 0.477, 1.0)
	DayGrid.get_child(update.day + firstOfMonth.weekday - 2).color = Color(0.50, 0.50, 0.50, 1.0)
	pass
