
extends Node2D

# BOMB UNIT PARAMS

const attactDamage   		= 100;
var   timeUntilNextAttack 	= 1.2;
var   healt 				= 70;
var   isAttacking 			= false;

func _ready():
	set_process(true);
	
	
func _process(delta):
	if(isAttacking==true):
		if(timeUntilNextAttack<=0 ):
			print(get_name()+" Bomb!!!");
			var pos = get_pos();
			var arrayXPos = get_node("/root/game").getMapCoordinateX(pos.x+40);
			var arrayYPos = get_node("/root/game").getMapCoordinateY(pos.y);
			
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
			
			var explopos = get_pos();
			explopos.y-=60;
			get_node("/root/game").addExplosion(explopos);
			
			get_node("/root/game/sampleMaster").play("explosion");
			
			get_node("/root/game/").deleteFromUnitMap("bomb",arrayYPos,arrayXPos)
		else:
			timeUntilNextAttack-=delta;

func takeDamage():
	pass
	