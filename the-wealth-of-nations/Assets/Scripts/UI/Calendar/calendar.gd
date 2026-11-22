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
@onready var Schedules = $Schedules
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
var EventDict: Dictionary = {}
var CurrentSchedule: Dictionary
var canFireEvent: bool = true

func _ready():
	date = Time.get_datetime_dict_from_datetime_string(StartDate, true)

	CalendarMonth(date)
	ScheduleYear()
	ScheduleMonth()
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
		canFireEvent = true
		UpdateCalendar(date)
		TimeBus.day_change.emit(date.day)
	
	if date.day > daysInMonth[date.month]:
		if date.month == 12:
			date.month = 1
			date.year += 1
			TimeBus.year_change.emit(date.year)
			ScheduleYear()
		else:
			date.month += 1
		date.day = 1
		
		TimeBus.month_change.emit(date.month)
		CalendarMonth(date)
		
		ScheduleMonth()
	#endregion
	
	#region Events
	if canFireEvent and EventDict.get(date.day) != null:
		var queued = EventDict[date.day]
		if queued[1] != null:
			queued[0].runEvent([queued[1]])
		else:
			queued[0].runEvent([])
		canFireEvent = false
	#endregion

func ScheduleYear():
	CurrentSchedule = Schedules.find_child(str(date.year)).schedule_dict

func ScheduleMonth():
	if CurrentSchedule == null or CurrentSchedule.get(date.month) == null:
		RandomEvents([-1])
	else:
	
		var month = CurrentSchedule[date.month]
		
		if month[00] == "Random":
			RandomEvents(month[01])
		elif month[00] == "ScheduledRandom":
			ScheduledRandomEvents(month[01])
		elif month[00] == "Scheduled":
			ScheduledEvents(month)

func RandomEvents(eventRange : Array):
	EventDict.clear()
	
	if eventRange[0] == -1:
		print("Events: Full Random")
		NumEvents = round(random.randf_range(StartingMinEvents + ((date.month - 1) * MinEventsScale), StartingMaxEvents + ((date.month - 1) * MaxEventsScale)))
	else:
		if not eventRange[0] is int or not eventRange[1] is int: 
			push_error("Random month " + str(date.month) + " event range from " + str(eventRange[0]) + " to " + str(eventRange[1]) + " should be of type int!")
		else:
			print("Events: Random in range (" + str(eventRange[0]) + "," + str(eventRange[1]) + ")")
			NumEvents = randi_range(eventRange[0], eventRange[1])
	#print("Events: ", NumEvents)
	
	for i in range(NumEvents):
		var EventRange: int = daysInMonth[date.month] / NumEvents
		var EventDay: int = (i * EventRange) + random.randi_range(0, EventRange)
		if EventDay < 1:
			EventDay = 1
		
		var Event: Node = Events.get_children().pick_random()
		EventDict[EventDay] = [Event, null]
		
		#print("Event added: ", Event, " @", EventDay)

func ScheduledRandomEvents(eventDays : Array):
	EventDict.clear()
	
	print("Events: Scheduled random on days " + str(eventDays))
	for x in eventDays:
		if not x is int:
			push_error("Scheduled random month " + str(date.month) + " day \"" + str(x) + "\" should be of type int!")
			
		else:
			EventArray.append(x)
			
			var Event: Node = Events.get_children().pick_random()
			EventDict[x] = [Event, null]
			
			#print("Event added: ", Event, " @", x)

func ScheduledEvents(sMonth : Dictionary):
	EventDict.clear()
	
	print("Events: Scheduled month " + str(sMonth))
	for x in sMonth:
		if not x is int:
			push_error("Month \"" + str(x) + "\" in year " + str(date.year) + " should be of type int!")
			
		elif x != 0:
			if sMonth[x][0] is Array:
				var pickEvent: int = randi_range(0, sMonth[x].size() - 1)
				var Event: Node = Events.find_child(sMonth[x][pickEvent][0])
				
				if Event != null:
					EventDict[x] = [Event, sMonth[x][pickEvent][1]]
					
					#print("Event added: ", Event, " @", x)
					
				else:
					push_error("Scheduled month " + str(date.month) + " day " + str(x) + " option " + str(pickEvent) + ": " + str(sMonth[x][pickEvent][0]) + "is not an event that exists!")
					
			elif sMonth[x][0] is String:
				var Event: Node = Events.find_child(sMonth[x][0])
				
				if Event != null:
					EventDict[x] = [Event, sMonth[x][1]]
					
					#print("Event added: ", Event, " @", x)
					
				else:
					push_error("Scheduled month " + str(date.month) + " day " + str(x) + ": " + str(sMonth[x]) + " is not an event that exists!")

func CalendarMonth(initdate: Dictionary):
	MonthYearLabel.text = monthNames[date.month] + " - " + str(date.year)
	firstOfMonth = Time.get_datetime_dict_from_datetime_string(str(initdate.year) + "-" + str(initdate.month) + "-01", true)
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
