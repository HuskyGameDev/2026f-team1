class_name Enums

const job_category_count : int = 5

enum Job {
	# Values with an underscore mark the beginning of a category
	_EXECUTIVE,
	CEO,
	Secretary,
	Treasurer,
	Head_of_Research,
	
	_LEGAL,
	Copyright_Attorney,
	Attorney,
	Paralegal,
	Legal_Intern,
	
	_CONSTRUCTION,
	Foreman,
	Construction_Worker,
	Machinist,
	
	_RESEARCH,
	Product_Designer,
	Chemical_Researcher,
	Electrical_Researcher,
	Mechanical_Researcher,
	Research_Intern,
	
	_OTHER,
	PR_Manager
}

enum GameResource {
	Money,
	Iron,
	Steel,
	Wood,
	Furniture
}

enum Building {
	Iron_Mine,
	Steel_Foundry,
	Timber_Mill,
	Furniture_Factory
}

enum Region {
	North_America,
	South_America,
	Africa,
	Europe,
	Asia,
	Australia,
	Antarctica
}

#region Job Methods
# Also see job_get_category_id
# If you get a weird category or an error for a job you implemented it may because you forgot to implement its ID and name here
static func job_get_category_name(job : Job) -> String:
	return job_get_category_name_from_category_id(job_get_category_id(job))

static func job_get_category_name_from_category_id(id : int) -> String:
	match id:
		0:
			return "Executive"
		1:
			return "Legal"
		2:
			return "Construction"
		3:
			return "Research"
		4:
			return "Other"
		_:
			push_error("Name not implemented for category ID " + str(id) + "! Returning empty string...")
			return ""

static func job_get_category_id(job : Job) -> int:
	match job:
		# These should be in reverse order of value
		var v when v >= Job._OTHER:
			return 4
		var v when v >= Job._RESEARCH:
			return 3
		var v when v >= Job._CONSTRUCTION:
			return 2
		var v when v >= Job._LEGAL:
			return 1
		var v when v >= Job._EXECUTIVE:
			return 0
		_:
			push_error("Category not implemented for job ID " + str(job) + "! Returning -1...")
			return -1

static func job_get_name(job : Job) -> String:
	match job:
		Job.CEO:
			return "CEO"
		Job.Secretary:
			return "Secretary"
		Job.Treasurer:
			return "Treasurer"
		Job.Head_of_Research:
			return "Head of Research"
		Job.Copyright_Attorney:
			return "Copyright Attorney"
		Job.Attorney:
			return "Attorney"
		Job.Paralegal:
			return "Paralegal"
		Job.Legal_Intern:
			return "Legal Intern"
		Job.Foreman:
			return "Foreman"
		Job.Construction_Worker:
			return "Construction Worker"
		Job.Machinist:
			return "Machinist"
		Job.Product_Designer:
			return "Product Designer"
		Job.Chemical_Researcher:
			return "Chemical Researcher"
		Job.Electrical_Researcher:
			return "Electrical Researcher"
		Job.Mechanical_Researcher:
			return "Mechanical Researcher"
		Job.Research_Intern:
			return "Research Intern"
		Job.PR_Manager:
			return "PR Manager"
		_:
			push_error("Name not implemented for job ID " + str(job) + "! Returning empty string...")
			return ""
#endregion
#region Resource Methods
static func resource_get_name(res : GameResource) -> String:
	match res:
		GameResource.Money:
			return "Money"
		GameResource.Iron:
			return "Iron"
		GameResource.Steel:
			return "Steel"
		GameResource.Wood:
			return "Wood"
		GameResource.Furniture:
			return "Furniture"
		_:
			push_error("Name not implemented for resource ID " + str(res) + "! Returning empty string...")
			return ""

static func resource_get_icon(res : GameResource) -> CompressedTexture2D:
	match res:
		GameResource.Money:
			return preload("res://icon.svg")
		GameResource.Iron:
			return preload("res://icon.svg")
		GameResource.Steel:
			return preload("res://icon.svg")
		GameResource.Wood:
			return preload("res://icon.svg")
		GameResource.Furniture:
			return preload("res://icon.svg")
		_:
			push_error("Icon not implemented for resource ID " + str(res) + "! Returning null...")
			return null
#endregion
#region Building Methods
static func building_get_name(bui : Building) -> String:
	match bui:
		Building.Iron_Mine:
			return "Iron Mine"
		Building.Steel_Foundry:
			return "Steel Foundry"
		Building.Timber_Mill:
			return "Timber Mill"
		Building.Furniture_Factory:
			return "Furniture Factory"
		_:
			push_error("Name not implemented for building ID " + str(bui) + "! Returning empty string...")
			return ""

static func building_get_recipe(bui : Building) -> Recipe:
	match bui:
		Building.Iron_Mine:
			return Recipe.new(
				[ # Inputs
					
				], [ # Outputs
					[GameResource.Iron, 1]
				], 1.5 # Time
			)
		Building.Steel_Foundry:
			return Recipe.new(
				[ # Inputs
					[GameResource.Iron, 2]
				], [ # Outputs
					[GameResource.Steel, 1]
				], 3.0 # Time
			)
		Building.Timber_Mill:
			return Recipe.new(
				[ # Inputs
					
				], [ # Outputs
					[GameResource.Wood, 1]
				], 2.0 # Time
			)
		Building.Furniture_Factory:
			return Recipe.new(
				[ # Inputs
					[GameResource.Steel, 1],
					[GameResource.Wood, 3]
				], [ # Outputs
					[GameResource.Furniture, 1]
				], 5.0 # Time
			)
		_:
			push_error("Recipe not implemented for building ID " + str(bui) + "! Returning null...")
			return null

static func building_get_cost(bui : Building) -> int:
	match bui:
		Building.Iron_Mine:
			return 10000
		Building.Steel_Foundry:
			return 25000
		Building.Timber_Mill:
			return 15000
		Building.Furniture_Factory:
			return 40000
		_:
			push_error("Cost not implemented for building ID " + str(bui) + "! Returning zero...")
			return 0
#endregion
#region Region Methods
static func region_get_name(reg : Region) -> String:
	match reg:
		Region.North_America:
			return "North America"
		Region.South_America:
			return "South America"
		Region.Africa:
			return "Africa"
		Region.Europe:
			return "Europe"
		Region.Asia:
			return "Asia"
		Region.Australia:
			return "Australia"
		Region.Antarctica:
			return "Antarctica"
		_:
			push_error("Name not implemented for region ID " + str(reg) + "! Returning empty string...")
			return ""
#endregion
