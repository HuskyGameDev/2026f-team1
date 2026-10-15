extends Node

signal employee_modified(emp : Employee) ## Emits when any added employee is modified, does not emit when order is changed or employee is added or removed. Binds the modified employee
signal employee_added(emp : Employee) ## Emits when an employee is added. Binds the added employee
signal employee_removed(emp : Employee) ## Emits when an employee is removed. Binds the added employee. Note that this occurs AFTER the removal so the index will be listed as -1
signal before_employee_removed(emp : Employee) ## Like employee_removed, but is called before the removal instead of after. Useful if you want the index

var employees : Array[Employee] ## This array should not be modified directly due to employee indexes needing to be updated! Please use the setters instead. (You can read it tho)

func _on_employee_modified(emp : Employee):
	employee_modified.emit(emp)

func append_employee(emp : Employee) -> void:
	emp.index = employees.size()
	emp.modified.connect(_on_employee_modified.bind(emp))
	employees.append(emp)
	
	employee_added.emit(emp)

func remove_employee(index : int) -> Employee:
	before_employee_removed.emit(employees[index])
	
	var temp : Employee = employees.pop_at(index)
	temp.modified.disconnect(_on_employee_modified.bind(temp))
	temp.index = -1
	
	for i : int in range(index, employees.size()):
		employees[i].index = i
	
	employee_removed.emit(temp)
	
	return temp

func insert_employee(index : int, emp : Employee) -> void:
	emp.index = index
	emp.modified.connect(_on_employee_modified.bind(emp))
	employees.insert(index, emp)
	
	for i : int in range(index + 1, employees.size()):
		employees[i].index = i
	
	employee_added.emit(emp)

func move_employee(from : int, to : int) -> void:
	var temp : Employee = employees.pop_at(from)
	employees.insert(to, temp)
	
	for i : int in range(min(from, to), max(from, to) + 1):
		employees[i].index = i

func get_employee(index : int) -> Employee:
	return employees[index]
