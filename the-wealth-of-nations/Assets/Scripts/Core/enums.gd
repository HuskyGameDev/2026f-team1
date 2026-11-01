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
