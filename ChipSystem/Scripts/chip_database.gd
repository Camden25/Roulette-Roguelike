extends Node

var common_chips: Array = []
var rare_chips: Array = []
var epic_chips: Array = []
var elite_chips: Array = []

var unlocked_chips: Array = []

const COMMON_PATH: String = "res://Chips/Common/"
const RARE_PATH: String = "res://Chips/Rare/"
const EPIC_PATH: String = "res://Chips/Epic/"
const ELITE_PATH: String = "res://Chips/Elite/"


func _ready():
	load_chips()
	
	# Load unlocked chips from player data
	# unlocked_chips = PlayerData.get_unlocked_chips()


func load_chips():
	var dirs = [
		{"path": COMMON_PATH, "array": common_chips},
		{"path": RARE_PATH, "array": rare_chips},
		{"path": EPIC_PATH, "array": epic_chips},
		{"path": ELITE_PATH, "array": elite_chips}
	]
	
	for dir_info in dirs:
		var dir = DirAccess.open(dir_info["path"])  # Use DirAccess.open()
		if dir:
			dir.list_dir_begin()  # Begin directory listing
			var file_name = dir.get_next()  # Get the first file in the directory
			while file_name != "":
				if !dir.current_is_dir():  # Ensure it's a file (not a directory)
					print("Found file: ", file_name)  # Debugging print
					if file_name.ends_with(".tscn"):  # Check if it's a scene file
						var chip_scene = load(dir_info["path"] + file_name) as PackedScene
						if chip_scene:
							dir_info["array"].append(chip_scene)
							print("Loaded chip: " + file_name)  # Debugging print
				file_name = dir.get_next()  # Get the next file
			dir.list_dir_end()  # Finish the directory listing
		else:
			print("Failed to open directory: " + dir_info["path"])
	
	print("Common Chips: ", common_chips.size())
	print("Rare Chips: ", rare_chips.size())
	print("Epic Chips: ", epic_chips.size())
	print("Elite Chips: ", elite_chips.size())


func get_random_chips(count: int) -> Array:
	var selected_chips: Array = []
	
	for i in range(count):
		selected_chips.append(get_random_chip(selected_chips))
	
	return selected_chips



func get_random_chip(selected_chips: Array) -> PackedScene:
	var weights = {
		"common": 65,
		"rare": 25,
		"epic": 9,
		"elite": 1
	}
	
	var weighted_rarities: Array = []
	for rarity in weights.keys():
		for i in range(weights[rarity]):  # Manually append based on weight
			weighted_rarities.append(rarity)
	
	# Keep trying to get a unique chip
	for attempt in range(20):  # Avoid infinite loops
		var random_rarity = weighted_rarities[randi_range(0, weighted_rarities.size() - 1)]
		var chip_pool: Array = []
		
		match random_rarity:
			"common": chip_pool = common_chips
			"rare": chip_pool = rare_chips
			"epic": chip_pool = epic_chips
			"elite": chip_pool = elite_chips
		
		# Filter out already selected chips
		var available_chips = chip_pool.filter(func(chip): return not selected_chips.has(chip))
		
		# If there's a valid choice, return it
		if available_chips.size() > 0:
			return available_chips.pick_random()
	
	# If we can't find a unique chip, pick a common one that isn't already selected
	var fallback_chips = common_chips.filter(func(chip): return not selected_chips.has(chip))
	if fallback_chips.size() > 0:
		return fallback_chips.pick_random()
	
	# If we can't find a unique chip, pick a rare one that isn't already selected
	fallback_chips = rare_chips.filter(func(chip): return not selected_chips.has(chip))
	if fallback_chips.size() > 0:
		return fallback_chips.pick_random()
	
	# As a last resort, just pick any common chip (even if it's a duplicate)
	return common_chips.pick_random()


func is_chip_unlocked(chip_scene: PackedScene) -> bool:
	return unlocked_chips.has(chip_scene)


func unlock_chip(chip_scene: PackedScene):
	if !unlocked_chips.has(chip_scene):
		unlocked_chips.append(chip_scene)
		# Save to player data
