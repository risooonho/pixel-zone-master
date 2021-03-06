extends Node2D


func _ready():
	settings.connect("window_size_changed", self, "_on_window_size_changed")

func _on_window_size_changed(prev, now):
	var width = settings.default_window_size.x
	var height = settings.default_window_size.y
	scale.x = now.x / width
	scale.y = now.y / height
func save():
    var save_dict = {
        "filename" : get_filename(),
        "parent" : get_parent().get_path(),
		"pos_x" : get_position().x,
		"pos_y" : get_position().y,
    }
    return save_dict
