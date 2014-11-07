
extends Node2D

var timer = 0;
var smokeActive = false;

func _ready():
	set_process(true);
	get_node("electric").set_emitting(true);
	
func _process(delta):
	timer += delta;
	if(timer>1 && smokeActive==false):
		get_node("smoke").set_emitting(true);
		smokeActive=true;
	if(timer>3):
		get_node("/root/game/").deleteExplosion(get_name());


