
extends Node2D

func _ready():
	get_node("play").connect("pressed",self,"_on_play_pressed");
	get_node("credits").connect("pressed",self,"_on_credits_pressed");
	get_node("exit").connect("pressed",self,"_on_exit_pressed");
	

func _on_play_pressed():
	get_node("/root/global").goto_scene_interactive("res://scenes/game.xml")


func _on_credits_pressed():
	get_node("/root/global").goto_scene("res://scenes/credits.xml")


func _on_exit_pressed():
	pass
	##Close Game