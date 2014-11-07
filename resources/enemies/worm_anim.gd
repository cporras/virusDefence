##
# Copyright (c) 2014 Cristian Porras (porrascristian@gmail.com)
# Distributed under the GNU GPL v3. For full terms see the file LICENSE.
##

extends Node2D

# WORM ENEMY PARAMS
const velocity 				= 40;
const attackDuration 		= 3;
const attackDamage   		= 12;
var timeUntilNextattack 	= 3;
var   healt 				= 70;
var   isAttacking			= false;
var   isDead				= false;

func _ready():
	set_process(true);
	get_node("anims").play("walk",1,1);

func _process(delta):
	if(isDead==false):
		var pos = get_pos();
		var arrayXPos = get_node("/root/game").getMapCoordinateX(pos.x);
		var arrayYPos = get_node("/root/game").getMapCoordinateY(pos.y);
		var occupiedUnitMap = get_node("/root/game").occupiedUnitMap;
		if(arrayYPos!= null && arrayXPos!= null && occupiedUnitMap[arrayYPos][arrayXPos]!=null):
			if(isAttacking==false):
				get_node("anims").play("attack",1,1);
				isAttacking=true;
			if(timeUntilNextattack<=0 ):
				print(get_name()+" Attack!!!");
				timeUntilNextattack=attackDuration; 
				get_node("/root/game/"+occupiedUnitMap[arrayYPos][arrayXPos]).takeDamage(attackDamage);
			else:
				timeUntilNextattack-=delta;
		else:
			if(isAttacking==true):
				get_node("anims").play("walk",1,1);
				isAttacking= false;
			pos.x -= velocity*delta;
			set_pos(pos);
	else:		
		if(get_node("Timer").get_time_left()<=0):
			print(get_name()+" I'm Dead!!!");
			get_node("/root/game/").deleteEnemyFromMap("worm",get_name());
	

func takeDamage(damage):
	healt -= damage;
	if(healt<=0 && isDead == false):
		var explopos = get_pos();
		explopos.y-=60;
		explopos.x+=40;
		get_node("/root/game").addExplosion(explopos);
		isDead = true;
		get_node("anims").play("die",1,1);
		get_node("Timer").start()
		
