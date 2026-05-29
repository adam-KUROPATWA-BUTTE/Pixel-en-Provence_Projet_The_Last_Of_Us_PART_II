@tool
extends EditorScript

func _run():
	var gms = get_scene().find_children("*", "GridMap", true, false)
	if gms.is_empty():
		print("No GridMap found")
		return

	# Index GridMaps by name for fast lookup
	var gm_by_name = {}
	for gm in gms:
		gm_by_name[gm.name] = gm

	var file = FileAccess.open("res://gridmap_hidden_backup.json", FileAccess.READ)
	if not file:
		print("No backup file found")
		return
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	var counts = {}
	for key_str in data:
		# key format: "GridMapName|x,y,z"
		var split = key_str.split("|")
		var gm_name = split[0]
		var parts = split[1].split(",")
		var cell = Vector3i(int(parts[0]), int(parts[1]), int(parts[2]))

		if not gm_by_name.has(gm_name):
			print("Warning: GridMap '%s' not found in scene, skipping." % gm_name)
			continue

		gm_by_name[gm_name].set_cell_item(cell, data[key_str]["item"], data[key_str]["orientation"])
		counts[gm_name] = counts.get(gm_name, 0) + 1

	for gm_name in counts:
		print("%s: restored %d cells" % [gm_name, counts[gm_name]])
