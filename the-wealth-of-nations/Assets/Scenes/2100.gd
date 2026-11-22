extends Node
var schedule_dict = {
	01: {
		00: "Scheduled",
		05: ["TestEvent", null],
		10: ["TestEvent", 1200],
		15: ["TestEvent", -100],
		20: [["TestEvent", -150], ["TestEvent", 150]]
	},
	02: {
		00: "Random",
		01: [2, 3]
	},
	03: {
		00: "ScheduledRandom",
		01: [3, 4, 7, 9, 11]
	},
	04: {
		00: "Scheduled",
		05: "IAmError"
	}
}
