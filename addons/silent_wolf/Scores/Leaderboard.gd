tool
extends Control

const ScoreItem = preload("ScoreItem.tscn")
const SWLogger = preload("../utils/SWLogger.gd")

var list_index = 0
func _process(_delta):
	if $Board/ScoreItemContainer.get_child_count() >=5:
		$Board/VSlider.show()
		$Board/VSlider.max_value = float(($Board/ScoreItemContainer.get_child_count())*3)
		$Board/VSlider.min_value = float(($Board/ScoreItemContainer.get_child_count())*-5)
func _ready():
	if str(OS.get_name()) == 'Android':
		$Board/VSlider.hide()
		$up.show()
		$down.show()
	else:
		$Board/VSlider.show()
		$up.hide()
		$down.hide()
	globals.debug_auth_player()
	var scores = SilentWolf.Scores.scores
	var local_scores = SilentWolf.Scores.local_scores
	
	if scores: 
		render_board(scores, local_scores)
	else:
		# use a signal to notify when the high scores have been returned, and show a "loading" animation until it's the case...
		add_loading_scores_message()
		yield(SilentWolf.Scores.get_high_scores(0), "sw_scores_received")
		hide_message()
		render_board(SilentWolf.Scores.scores, local_scores)

func render_board(scores, local_scores):
	var all_scores = merge_scores_with_local_scores(scores, local_scores)
	if !scores and !local_scores:
		add_no_scores_message()
	for score in scores:
		add_item(score.player_name, str(int(score.score)))

func merge_scores_with_local_scores(scores, local_scores, max_scores=10):
	if local_scores:
		for score in local_scores:
			var in_array = score_in_score_array(scores, score)
			if !in_array:
				scores.append(score)
			scores.sort_custom(self, "sort_by_score");
	var return_scores = scores
	if scores.size() > max_scores:
		return_scores = scores.resize(max_scores)
	return return_scores
func sort_by_score(a, b):
	if a.score > b.score:
		return true;
	else:
		if a.score < b.score:
			return false;
		else:
			return true;
	
func score_in_score_array(scores, new_score):
	var in_score_array =  false
	if new_score and scores:
		for score in scores:
			if score.score_id == new_score.score_id: # score.player_name == new_score.player_name and score.score == new_score.score:
				in_score_array = true
	return in_score_array

func add_item(player_name, score):
	var item = ScoreItem.instance()
	list_index += 1
	item.get_node("HBoxContainer/PlayerName").text = str(list_index) + str(". ") + player_name
	item.get_node("HBoxContainer/Score").text = score
	item.margin_top = list_index * 100
	$"Board/ScoreItemContainer".add_child(item)

func add_no_scores_message():
	$Panel2/LoadingScores.hide()
	$Panel2/NoScores.show()
	$Panel2.show()
	
func add_loading_scores_message():
	$Panel2/LoadingScores.show()
	$Panel2/NoScores.hide()
	$Panel2.show()
	
func hide_message():
	$Panel2/NoScores.hide()
	$Panel2/LoadingScores.hide()
	$Panel2.hide()
func _on_CloseButton_pressed():
	var scene_name = SilentWolf.scores_config.open_scene_on_close
	SWLogger.info("Closing SilentWolf leaderboard, switching to scene: " + str(scene_name))
	#global.reset()
	get_tree().change_scene(scene_name)


func _on_Logout_pressed():
	_on_CloseButton_pressed()
	SilentWolf.Auth.logout_player()


func _on_VSlider_value_changed(value):
	$Board/ScoreItemContainer.set_position(Vector2(50, value*10))


func _on_up_pressed():
	$Board/VSlider.value += 5


func _on_down_pressed():
	$Board/VSlider.value -= 5


func _on_Quit_pressed():
	_on_CloseButton_pressed()


func _on_Quit_leaderboard_pressed():
	$WindowDialog.popup_centered()
