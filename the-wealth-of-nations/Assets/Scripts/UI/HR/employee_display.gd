extends Control
class_name EmployeeDisplay

@export var name_display : Label

var bound_employee : Employee = null

func bind_employee(emp : Employee) -> void:
	if (bound_employee != null):
		bound_employee.modified.disconnect(_update)
		bound_employee.bound_display = null
	
	bound_employee = emp
	emp.bound_display = self
	bound_employee.modified.connect(_update)
	_update()

func _update() -> void:
	name_display.text = bound_employee.name

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		bound_employee.modified.disconnect(_update)
		bound_employee.bound_display = null
		bound_employee = null
