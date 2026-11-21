class_name Recipe ## A struct for storing recipe data

var input_count : int
var input_resources : Array[Enums.GameResource]
var input_quantities : Array[int]

var output_count : int
var output_resources : Array[Enums.GameResource]
var output_quantities : Array[int]

var time_required : float ## Arbitrary for now, this is for use in the building processing module

func _init(inputs : Array[Array], outputs : Array[Array], time : float) -> void: ## Inputs and outputs should be passed as arrays of pairs in the form {resource, quantity}
	input_count = inputs.size()
	output_count = outputs.size()
	
	input_resources.resize(input_count)
	input_quantities.resize(input_count)
	output_resources.resize(output_count)
	output_quantities.resize(output_count)
	for i in input_count:
		input_resources[i] = inputs[i][0]
		input_quantities[i] = inputs[i][1]
	for i in output_count:
		output_resources[i] = outputs[i][0]
		output_quantities[i] = outputs[i][1]
	
	time_required = time
