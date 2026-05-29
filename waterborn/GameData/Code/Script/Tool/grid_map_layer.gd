@tool
extends EditorScript

const TARGET_Y = 0

func _run():
	var gms = get_scene().find_children("*", "GridMap", true, false)
	if gms.is_empty():
		print("No GridMap found")
		return
	
	var all_hidden = {}
	
	for gm in gms:
		var gm_data = {}
		for cell in gm.get_used_cells():
			if cell.y != TARGET_Y:
				var k = "%s|%d,%d,%d" % [gm.name, cell.x, cell.y, cell.z]
				gm_data[k] = {
					"item": gm.get_cell_item(cell),
					"orientation": gm.get_cell_item_orientation(cell)
				}
				gm.set_cell_item(cell, GridMap.INVALID_CELL_ITEM)
		all_hidden.merge(gm_data)
		print("%s: hid %d cells" % [gm.name, gm_data.size()])
	
	var file = FileAccess.open("res://gridmap_hidden_backup.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(all_hidden))
	file.close()
	print("Backup saved — total %d cells." % all_hidden.size())
