extends Node2D
@onready var UI = $CalendarUI
@onready var UICalendarBack = $CalendarUI/CalendarDayBack
@onready var UICalendarMax: int = UICalendarBack.size.y
@onready var UITimeElapsed = $CalendarUI/CalendarDayBack/CalendarCovered
@onready var UIDayLabel = $CalendarUI/CalendarDayBack/CalendarHeader/DayLabel
@onready var UITimeLabel = $CalendarUI/CalendarDayBack/TimeLabel
@onready var UIEventMarker = $CalendarUI/CalendarDayBack/EventMarker

#Timing
var TimeElapsed: float = 0.0
@export var DayLength: float = 24
var DayCount: int = 1

#UI
enum ClockTypeList {Twelve = 12, TwentyFour = 24, Raw = 1}
@export var ClockType: ClockTypeList = ClockTypeList.Twelve
var TimeInterval: float = 0
var StylizedTime: int = 0

#Events
@onready var Events = $Events
enum EventModeList {Scheduled = 0, Random = 1, ScheduledRandom = 2}
@export var EventMode: EventModeList = EventModeList.Random
@export var StartingMinEvents: float = 0
@export var MinEventsDayScale: float = 0.1
@export var StartingMaxEvents: float = 3
@export var MaxEventsDayScale: float = 0.2
@export var EventWiggleMod: float = 5.0 ##A higher value means events deviate less from their usual, even placements in random modes.[br]Anything 3.0 or below invites potential overlap.
var random = RandomNumberGenerator.new()
var NumEvents: int = 0
var EventArray: Array = []
var EventMarkerArray: Array = []
var EventIndex: int = 0
var EventDict: Dictionary = {}

func _ready():
	TimeInterval = 24 / DayLength
	InitializeEvents()
	UIDayLabel.text = str("Day ", DayCount)
	#random.seed = 67
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	TimeElapsed += delta
	
	#region UI
	match ClockType:
		ClockTypeList.Twelve:
			StylizedTime = int(TimeElapsed / TimeInterval) % 12
			if StylizedTime == 0:
				StylizedTime = 12

			if TimeElapsed < TimeInterval * 12:
				UITimeLabel.text = str(StylizedTime, " AM")
			else:
				UITimeLabel.text = str(StylizedTime, " PM")
		ClockTypeList.TwentyFour:
			StylizedTime = int(TimeElapsed / TimeInterval)
			
			if StylizedTime < 10:
				UITimeLabel.text = str("0", StylizedTime, "00")
			else:
				UITimeLabel.text = str(StylizedTime, "00")
		ClockTypeList.Raw:
			UITimeLabel.text = str(snapped(TimeElapsed, 0.01))
	#endregion
	
	#region Day Timing and Event Initialization
	if TimeElapsed >= DayLength:
		TimeElapsed = 0
		DayCount += 1
		UIDayLabel.text = str("Day ", DayCount)
		EventIndex = 0
		InitializeEvents()
	
	UITimeElapsed.size.y = (UICalendarMax / DayLength) * TimeElapsed
	#endregion
	
	#region Events
	if EventArray.size() > EventIndex and TimeElapsed > EventArray[EventIndex]:
		print(snapped(EventArray[EventIndex], 0.01), ": ", EventDict[EventIndex], " triggered")
		EventDict[EventIndex].runEvent([])
		EventIndex += 1
	#endregion

func InitializeEvents():
	EventArray.clear()
	for x in EventMarkerArray:
		x.queue_free()
	EventMarkerArray.clear()
	
	print("-------")
	print("Day: ", DayCount)
	print("Event MinMax ", StartingMinEvents + ((DayCount - 1) * MinEventsDayScale), ", ", StartingMaxEvents + ((DayCount - 1) * MaxEventsDayScale))
	
	match EventMode:
		EventModeList.Random:
			NumEvents = round(random.randf_range(StartingMinEvents + ((DayCount - 1) * MinEventsDayScale), StartingMaxEvents + ((DayCount - 1) * MaxEventsDayScale)))
			print("Events: ", NumEvents)
			
			for i in range(NumEvents):
				var EventTime: float = DayLength / (NumEvents + 1) * (i + 1)
				var WiggleRoom: float = DayLength / (NumEvents * EventWiggleMod)
				EventTime = clamp(EventTime + random.randf_range(-WiggleRoom, WiggleRoom), 0, DayLength)
				EventArray.append(EventTime)
				
				var EventMarker = UIEventMarker.duplicate()
				UICalendarBack.add_child(EventMarker)
				EventMarker.position.y = (UICalendarMax / DayLength) * EventTime
				EventMarkerArray.append(EventMarker)
				
				var Event: Node = Events.get_children().pick_random()
				EventDict[i] = Event
				
				print("Event added: ", Event, " @", snapped(EventArray[i], 0.01))
				
		EventModeList.Scheduled:
			NumEvents = 0
			
		EventModeList.ScheduledRandom:
			NumEvents = 0
			
