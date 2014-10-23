
extends Node2D


func _ready():
	set_process(true);
	
func play(sound):
	var player = get_node("player");
	player.play(sound);


