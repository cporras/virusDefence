extends Node2D

func _ready():
	get_node("replay").connect("pressed",self,"_on_replay_pressed");
	get_node("mainMenu").connect("pressed",self,"_on_mainMenu_pressed");
	

func _on_mainMenu_pressed():
		print("Main Menu");
		get_node("/root/global/").goto_scene("res://scenes/mainMenu.xml")
		
func _on_replay_pressed():
		print("Replay");
		get_node("/root/global/").goto_scene_interactive("res://scenes/game.xml")