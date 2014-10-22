##
# Copyright (c) 2014 Cristian Porras (porrascristian@gmail.com)
# Distributed under the GNU GPL v3. For full terms see the file LICENSE.
##

extends Sprite

# WORM ENEMY PARAMS
const velocity 			= 45;
const attackDuration 		= 3;
const attackDamage   		= 12;
const timeUnitNextattack 	= 0;
var   healt 			= 70;

func _ready():
	set_process(true);

func _process(delta):
	var pos = get_pos();
	var arrayXPos = get_node("/root/game").getMapCoordinateX(pos.x);
	var arrayYPos = get_node("/root/game").getMapCoordinateY(pos.y+get_texture().get_height());
	var occupiedUnitMap = get_node("/root/game").occupiedUnitMap;
	if(arrayYPos!= null && arrayXPos!= null && occupiedUnitMap[arrayYPos][arrayXPos]!=null):
		if(timeUnitNextattack<=0 ):
			print(get_name()+" Attack!!!");
			timeUnitNextattack=attackDuration; 
			get_node("/root/game/"+occupiedUnitMap[arrayYPos][arrayXPos]).takeDamage(attackDamage);
		else:
			timeUnitNextattack-=delta;
	else:		
		pos.x -=  velocity*delta;
		set_pos(pos);
	

func takeDamage(damage):
	healt -= damage;
	if(healt<=0):
		print(get_name()+" I'm Dead!!!");
		get_node("/root/game/").deleteEnemyFromMap("worm",get_name());