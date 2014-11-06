##
# Copyright (c) 2014 Cristian Porras (porrascristian@gmail.com)
# Distributed under the GNU GPL v3. For full terms see the file LICENSE.
##

extends Node2D

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
			get_node("anims").play("shoot",1,1);
			get_node("Timer").start()
			timeUntilNextAttack=attackDuration;
			var pos = get_pos();
			pos.y -= 90;
			pos.x += 20;
			get_node("/root/game/").createLaserInMap(pos);
		else:
			if(get_node("Timer").get_time_left()<=0):
				get_node("Timer").stop();
				get_node("Timer").set_wait_time(1);
				get_node("anims").play("stand",1,1);
			timeUntilNextAttack-=delta;
	
func takeDamage(damage):
	healt -= damage;
	if(healt<=0):
		print(get_name()+" I'm Dead!!!");
		var pos = get_pos();
		var arrayXPos = get_node("/root/game").getMapCoordinateX(pos.x-40);
		var arrayYPos = get_node("/root/game").getMapCoordinateY(pos.y);
		get_node("/root/game/").deleteFromUnitMap("antivirus",arrayYPos,arrayXPos);
		

