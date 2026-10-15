class_name Employee

signal modified

var bound_display : EmployeeDisplay # For the HR Menu

var index : int = -1 ## Unique ID that points to a position in the employees array. Does not call modified signal when changed bc it shouldn't be touched outside Globals anyway
var name : String :
	get:
		return name
	set(val):
		name = val
		modified.emit()
var job : Enums.Job :
	get:
		return job
	set(val):
		job = val
		modified.emit()

func _init(_name : String, _job : Enums.Job) -> void:
	self.name = _name
	self.job = _job
