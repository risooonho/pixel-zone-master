extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
var player_default = globals.selected_player
func _ready():
	add_child(Object(player_default))
	globals._set_player_pos(0,0)
	var true_ = 'false'
	var documents = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	var vconf = ConfigFile.new()
	vconf.load(str(documents) + "/Pixel Zone/.data/settings/game.ini")
	var passed = str(vconf.get_value("saves", "game_pass", true_))
	print(str(passed))
	if str(passed) == 'false':
		var a = File.new()
		a.open_encrypted_with_pass("user://save_data.1", File.WRITE, str(34567865))
		a.store_line("17")
		a.close()
		a.open_encrypted_with_pass("user://save_data.2", File.WRITE, str(34567865))
		a.store_line("17")
		a.close()




func _on_Spikes3x1_body_entered(body):
	if body.name == 'Player':
		remove_child(player_default)
		get_tree().change_scene("res://scenes/GameOver.tscn")


func _on_Spikes1x11_body_entered(body):
	if body.name == 'Player':
		remove_child(player_default)
		get_tree().change_scene("res://scenes/GameOver.tscn")


func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		remove_child(player_default)
		get_tree().change_scene("res://scenes/GameOver.tscn")


func _on_Area2D2_body_entered(body):
	if body.name == 'Player':
		remove_child(player_default)
		get_tree().change_scene("res://scenes/Credits.tscn")
