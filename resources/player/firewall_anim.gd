
extends Node2D

# FIREWALL UNIT PARAMS

const attackDuration 		= 5;
var   attactDamage   		= 30;
var   timeUnitNextAttack 	= 0;
var   healt 				= 70;
var   isReady			    = false;
var   appeared				= false;

func _ready():
	set_process(true);
	
	
func _process(delta):
	if(isReady==true && appeared==false):
		print("apearing");
		get_node("anims").play("appear",1,1);
		appeared=true;
	
func takeDamage(damage):
	healt -= damage;
	if(healt<=0):
		print(get_name()+" I'm Dead!!!");
		var pos = get_pos();
		var arrayXPos = get_node("/root/game").getMapCoordinateX(pos.x+40);
		var arrayYPos = get_node("/root/game").getMapCoordinateY(pos.y);
		get_node("/root/game/").deleteFromUnitMap("firewall",arrayYPos,arrayXPos);
		
