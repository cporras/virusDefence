
extends Sprite

# LASER PARAMS
const velocity 				= 150;
const attackDamage   		= 10;

func _ready():
	set_process(true);
	
func _process(delta):
	var pos = get_pos();
	var arrayYPos = get_node("/root/game").getMapCoordinateY(pos.y);
	pos.x += velocity*delta;
	
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
	
	var enemyToAttack = null;
	for enemy in enemiesInLine:
		var enemyInstance = get_node("/root/game/"+enemy);
		if(enemyInstance!=null):
			var enemyPos = enemyInstance.get_pos();
			if(enemyPos.x<=pos.x):
				enemyToAttack = enemyInstance;
				break;
			
	var deleteLaser = false;
	if(enemyToAttack!=null):
		enemyToAttack.takeDamage(attackDamage);
		deleteLaser = true;
	
	if(pos.x>1280 || deleteLaser==true):
		get_node("/root/game").deleteLaserFromMap(get_name());
	else:
		set_pos(pos);
