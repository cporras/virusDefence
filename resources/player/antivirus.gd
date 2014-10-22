
extends Sprite

# ANTIVIRUS UNIT PARAMS

const attackDuration 		= 3;
var   timeUntilNextAttack 	= 3;
var   healt 				= 50;
var   isAttacking 			= false;

func _ready():
	set_process(true);
	
	
func _process(delta):
	if(isAttacking==true):
		if(timeUntilNextAttack<=0 ):
			print(get_name()+" Laser!!!");
			timeUntilNextAttack=attackDuration;
			var pos = get_pos();
			pos.y += get_texture().get_height()/2;
			pos.x += get_texture().get_width()/2;
			get_node("/root/game/").createLaserInMap(pos);
		else:
			timeUntilNextAttack-=delta;
	
func takeDamage(damage):
	healt -= damage;
	if(healt<=0):
		print(get_name()+" I'm Dead!!!");
		var pos = get_pos();
		var arrayXPos = get_node("/root/game").getMapCoordinateX(pos.x+get_texture().get_width()/4+1);
		var arrayYPos = get_node("/root/game").getMapCoordinateY(pos.y+get_texture().get_height());
		get_node("/root/game/").deleteFromUnitMap("antivirus",arrayYPos,arrayXPos);
		

