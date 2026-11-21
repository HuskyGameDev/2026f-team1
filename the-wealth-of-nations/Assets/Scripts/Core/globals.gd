extends Node

const starting_money : int = 100000

signal employee_modified(emp : Employee) ## Emits when any added employee is modified, does not emit when order is changed or employee is added or removed. Binds the modified employee
signal employee_added(emp : Employee) ## Emits when an employee is added. Binds the added employee
signal employee_removed(emp : Employee) ## Emits when an employee is removed. Binds the added employee. Note that this occurs AFTER the removal so the index will be listed as -1
signal before_employee_removed(emp : Employee) ## Like employee_removed, but is called before the removal instead of after. Useful if you want the index

var resource_counts : Array[int] ## To get the count of a particular resource, index this array with its ID (enum value)
var regional_building_counts : Array[Array] ## Index with region ID (enum value) as x and building ID as y to get a specific building count of a specific region
var employees : Array[Employee] ## The order of this array should not be modified directly due to employee indexes needing to be updated! Please use the setters instead. (You can read it or edit the individual employees tho)

var money : int :
	get:
		return resource_counts[Enums.GameResource.Money]
	set(val):
		resource_counts[Enums.GameResource.Money] = val

func _ready() -> void:
	resource_counts.resize(Enums.GameResource.size())
	money = starting_money
	
	regional_building_counts.resize(Enums.Region.size())
	for i in Enums.Region.size():
		regional_building_counts[i].resize(Enums.Building.size())
		for j in Enums.Building.size():
			regional_building_counts[i][j] = randi_range(0, 2)

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

@warning_ignore("unused_parameter") # Delete this when implemented
func get_building_progress(in_region : Enums.Region, building : Enums.Building) -> float: ## This will be a stub for now until the actual processing of buildings and their progress is implemented
	return 0.0 # Please return on a scale of zero to one

func get_employee(index : int) -> Employee:
	return employees[index]
