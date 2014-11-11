
extends Node2D

func _ready():	
	get_node("mainMenu").connect("pressed",self,"_on_mainMenu_pressed");
	

func _on_mainMenu_pressed():
	get_node("/root/global").goto_scene("res://scenes/mainMenu.xml")

