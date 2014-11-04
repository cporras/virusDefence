
extends Timer

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true);
	
func timeout():
	 print("TimeOut!");
	 get_parent().destroy();


