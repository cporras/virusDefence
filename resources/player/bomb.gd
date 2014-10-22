##
# Copyright (c) 2014 Cristian Porras (porrascristian@gmail.com)
# Distributed under the GNU GPL v3. For full terms see the file LICENSE.
##

extends Sprite

# BOMB UNIT PARAMS

const attactDamage   		= 100;
var   timeUntilNextAttack 	= 1;
var   healt 				= 70;
var   isAttacking 			= false;

func _ready():
	set_process(true);
	
	
func _process(delta):
	if(isAttacking==true):
		if(timeUntilNextAttack<=0 ):
			print(get_name()+" Bomb!!!");
			var pos = get_pos();
			var arrayXPos = get_node("/root/game").getMapCoordinateX(pos.x+get_texture().get_width()/4+1);
			var arrayYPos = get_node("/root/game").getMapCoordinateY(pos.y+get_texture().get_height());
			
			var virus = get_node("/root/game").virusInstances;
			var trojan = get_node("/root/game").trojanInstances;
			var worm = get_node("/root/game").wormInstances;
			var enemiesInLine = [];
			
			for enemy in virus:
				if(enemy.substr(0,1).to_int()==arrayYPos):
					enemiesInLine.push_back(enemy);
			for enemy in trojan:
				if(enemy.substr(0,1).to_int()==arrayYPos):
					enemiesInLine.push_back(enemy);	
			for enemy in worm:
				if(enemy.substr(0,1).to_int()==arrayYPos):
					enemiesInLine.push_back(enemy);	
			
			var enemyToAttack = [];
			for enemy in enemiesInLine:
				var enemyInstance = get_node("/root/game/"+enemy);
				if(enemyInstance!=null):
					var enemyPos = enemyInstance.get_pos();
					var enemyXPos = get_node("/root/game").getMapCoordinateX(enemyPos.x);
					if(enemyXPos==arrayXPos || enemyXPos==arrayXPos+1 || enemyXPos==arrayXPos-1):
						enemyToAttack.push_back(enemy);
			
			for enemy in enemyToAttack:
				get_node("/root/game/"+enemy).takeDamage(attactDamage);
			
			
			get_node("/root/game/").deleteFromUnitMap("bomb",arrayYPos,arrayXPos)
		else:
			timeUntilNextAttack-=delta;
	
func takeDamage(damage):
	pass
#	healt -= damage;
#	if(healt<=0):
#		print(get_name()+" I'm Dead!!!");
#		var pos = get_pos();
#		var arrayXPos = get_node("/root/game").getMapCoordinateX(pos.x+get_texture().get_width()/4+1);
#		var arrayYPos = get_node("/root/game").getMapCoordinateY(pos.y+get_texture().get_height());
#		get_node("/root/game/").deleteFromUnitMap("firewall",arrayYPos,arrayXPos);
		

