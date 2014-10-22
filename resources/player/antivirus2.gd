
extends Sprite

# ANTIVIRUS2 UNIT PARAMS

const attackDuration 		= 5;
const timeUntilNextAttack 	= 3;
var   healt 				= 70;
var   isLaunchingLasers		= false;
var   timeUntilNextLaser	= 0;
const timeBetweenLasers		= 1;
var	  launchedLasers		= 0;
var   isAttacking 			= false;

func _ready():
	set_process(true);
	
	
func _process(delta):
	if(isAttacking==true):
		if(timeUntilNextAttack<=0 && isLaunchingLasers == false):
			timeUntilNextAttack=attackDuration;
			isLaunchingLasers = true;
		elif(isLaunchingLasers==true):
			if(timeUntilNextLaser<=0):
				var pos = get_pos();
				pos.y += get_texture().get_height()/2;
				pos.x += get_texture().get_width()/2;
				get_node("/root/game/").createLaserInMap(pos);
				timeUntilNextLaser=timeBetweenLasers;
				launchedLasers+=1;
				if(launchedLasers==3):
					launchedLasers=0;
					isLaunchingLasers=false;
					timeUntilNextLaser=0;
			else:
				timeUntilNextLaser -= delta;			
		else:
			timeUntilNextAttack-=delta;
	
func takeDamage(damage):
	healt -= damage;
	if(healt<=0):
		print(get_name()+" I'm Dead!!!");
		var pos = get_pos();
		var arrayXPos = get_node("/root/game").getMapCoordinateX(pos.x+get_texture().get_width()/4+1);
		var arrayYPos = get_node("/root/game").getMapCoordinateY(pos.y+get_texture().get_height());
		get_node("/root/game/").deleteFromUnitMap("antivirus2",arrayYPos,arrayXPos);
		

