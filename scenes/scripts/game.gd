##
# Copyright (c) 2014 Cristian Porras (porrascristian@gmail.com)
# Distributed under the GNU GPL v3. For full terms see the file LICENSE.
##

extends Node2D

## RESOURCES ##
var virusResource 		= preload("res://resources/enemies/virus.xml");
var virusCount			= 0;
var virusInstances		= [];

var trojanResource 		= preload("res://resources/enemies/trojan.xml");
var trojanCount			= 0;
var trojanInstances		= [];

var wormResource 		= preload("res://resources/enemies/worm.xml");
var wormCount			= 0;
var wormInstances		= [];

var antivirusResource 	= preload("res://resources/player/antivirus.xml");
var antivirusCount		= 0;
var antivirusInstances	= [];

var antivirus2Resource 	= preload("res://resources/player/antivirus2.xml");
var antivirus2Count		= 0;
var antivirus2Instances	= [];

var firewallResource 	= preload("res://resources/player/firewall.xml");
var firewallCount		= 0;
var firewallInstances	= [];

var bombResource	 	= preload("res://resources/player/bomb.xml");
var bombCount			= 0;
var bombInstances		= [];

var laserResource	 	= preload("res://resources/player/laser.xml");
var laserCount			= 0;
var laserInstances  	= [];

var sumResource 		= preload("res://resources/ui/sum.xml");
var sumInstance			= null;

var multiplicationResource = preload("res://resources/ui/multiplication.xml");
var multiplicationInstance = null;

var subtractionResource = preload("res://resources/ui/subtraction.xml");
var subtractionInstance = null;

var divisionResource 	= preload("res://resources/ui/division.xml");
var divisionInstance 	= null;


## WORLD DEFINITION ##
const rowsYPosition			= [220, 340, 450, 560, 670];
const mapPositionHeight		= 110;
const filesXPosition		= [80, 190, 310, 420, 530,640,750,860,970];
const mapPositionWidth 		= 110;
const enemyInitialXPos		= 1300;
const enemySpriteHeight		= 190;
const enemySpriteWidth		= 200;
const enemySpeed			= {"virus":40,  "trojan":50,  "worm":70};
const enemyStrength			= {"virus":10,  "trojan":15,  "worm":12};
const enemyHealth			= {"virus":100, "trojan":200, "worm":150};
const operationPos			= Vector2(0,0);
const operationPosOutside	= Vector2(-1000,-1000);
const TreeOrderOperations 	= 100;
const TreeOrderBackground 	= 0;
const limitXToLose			= 70;

## LEVEL ENEMIES ##
#List of enemies and the seconds they appear in game
var enemyList 			= {	"virus" :[1,10,20,30,40,50],
				 			"trojan":[5,15,25,35,45,55],
				 			"worm"  :[8,18,28,38,48,58] };

## GLOBAL VARIABLES ##
var gameRunning 		= true
var gameSeconds 		= 0;
var enemiesCreated 		= 0;
var enemiesTotal 		= 0;
var unitBoundedToMouse  = null;
var mouseClickPosition  = null;
var sampleMaster	    = null;
var occupiedUnitMap     = {0:[null,null,null,null,null,null,null,null,null],
				 			1:[null,null,null,null,null,null,null,null,null],
				 			2:[null,null,null,null,null,null,null,null,null],
							3:[null,null,null,null,null,null,null,null,null],
							4:[null,null,null,null,null,null,null,null,null] };


func _ready():
	set_process(true);
	set_process_input(true)
	randomize();
	instantiateOperationMenus();
	setGame();
	sampleMaster = get_node("sampleMaster");
	move_child(get_node("background"),0);


func _process(delta):
	if(gameRunning==true):
		game(delta);
		reorderNodeTree();
		checkWinOrLose();
		
func reorderNodeTree():
	move_child(get_node("background"),TreeOrderBackground);
	get_node("background").raise();
	
	var indexMaster={"0" : [],
					 "1" : [],
					 "2" : [],
					 "3" : [],
					 "4" : []};
	
	for enemyName in virusInstances:
		indexMaster[enemyName.substr(0,1)].push_back(enemyName);
	for enemyName in trojanInstances:
		indexMaster[enemyName.substr(0,1)].push_back(enemyName);
	for enemyName in wormInstances:
		indexMaster[enemyName.substr(0,1)].push_back(enemyName);
	for unitName in antivirusInstances:
		indexMaster[unitName.substr(0,1)].push_back(unitName);
	for unitName in antivirus2Instances:
		indexMaster[unitName.substr(0,1)].push_back(unitName);
	for unitName in firewallInstances:
		indexMaster[unitName.substr(0,1)].push_back(unitName);
	for unitName in bombInstances:
		indexMaster[unitName.substr(0,1)].push_back(unitName);
	for laserName in laserInstances:
		indexMaster[laserName.substr(0,1)].push_back(laserName);
		
	for i in ["0","1","2","3","4"]:
		for nodeName in indexMaster[i]:			
			var nodeInstance = get_node(nodeName);
			if(nodeInstance!=null):
				move_child(nodeInstance,i.to_int()+1);
				nodeInstance.raise();

	
	move_child(get_node("menu"),TreeOrderOperations);
	get_node("menu").raise();
	move_child(sumInstance,TreeOrderOperations);
	sumInstance.raise();
	move_child(multiplicationInstance,TreeOrderOperations);
	multiplicationInstance.raise();	
	move_child(subtractionInstance,TreeOrderOperations);
	subtractionInstance.raise();
	move_child(divisionInstance,TreeOrderOperations);
	divisionInstance.raise();
	
	if(unitBoundedToMouse!=null):
		unitBoundedToMouse.raise();
	
	
	

func _input(ev):
	if(gameRunning==true):
		if (ev.type==InputEvent.MOUSE_BUTTON):
			mouseClickPosition = ev.pos;
			if(unitBoundedToMouse!=null):
				unitConfirmPosition(ev.pos);
		elif (ev.type==InputEvent.MOUSE_MOTION):
			if(unitBoundedToMouse!=null):
				unitFollowMouse(ev.pos);  


func setGame():
	gameRunning = true;
	gameSeconds = 0;
	enemiesCreated = 0;
	enemiesTotal = 0;
	enemiesTotal += enemyList["virus"].size();
	enemiesTotal += enemyList["trojan"].size();
	enemiesTotal += enemyList["worm"].size();
	
	

func instantiateOperationMenus():
	sumInstance = sumResource.instance();
	sumInstance.set_pos(operationPosOutside);
	add_child(sumInstance);
	multiplicationInstance = multiplicationResource.instance();
	multiplicationInstance.set_pos(operationPosOutside);
	add_child(multiplicationInstance);
	subtractionInstance = subtractionResource.instance();
	subtractionInstance.set_pos(operationPosOutside);
	add_child(subtractionInstance);	
	divisionInstance = divisionResource.instance();
	divisionInstance.set_pos(operationPosOutside);
	add_child(divisionInstance);
	
func game(delta):
	gameSeconds += delta;
	enemyCreatorManager();


func enemyCreatorManager():
	if(enemiesTotal-enemiesCreated>0):
		if(enemyList["virus"].size()>0 && enemyList["virus"][0]<=gameSeconds):
			createEnemy("virus");
		if(enemyList["trojan"].size()>0 && enemyList["trojan"][0]<=gameSeconds):
			createEnemy("trojan");
		if(enemyList["worm"].size()>0 && enemyList["worm"][0]<=gameSeconds):
			createEnemy("worm");


func createEnemy(enemyType):
	enemyList[enemyType].remove(0);
	enemiesCreated += 1;
	var rowNumber = randi() % 5;
	var enemyInstance;
	var enemyName;
	
	if(enemyType=="virus"):
		enemyInstance = virusResource.instance();
		enemyName = str(rowNumber)+"virus"+str(virusCount);
		virusInstances.push_back(enemyName);
		virusCount+=1;
	elif(enemyType=="trojan"):
		enemyInstance = trojanResource.instance();
		enemyName = str(rowNumber)+"trojan"+str(trojanCount);
		trojanInstances.push_back(enemyName);
		trojanCount+=1;
	elif(enemyType=="worm"):
		enemyInstance = wormResource.instance();
		enemyName = str(rowNumber)+"worm"+str(wormCount);
		wormInstances.push_back(enemyName);
		wormCount+=1;
	
	enemyInstance.set_name(enemyName);
	
	var enemyPos = Vector2(enemyInitialXPos,rowsYPosition[rowNumber]);
	enemyPos.y -= enemyInstance.get_texture().get_height();
	enemyInstance.set_pos(enemyPos);
	add_child(enemyInstance);
	

func showUnitsMenu(unitType):	
	#TODO No se debe poder dar click en ningun elemento de la interfaz cuando se tiene una operacion por resolver
	sampleMaster.play("click");
	if(unitType=="antivirus"):
		sumInstance.setResult();
		sumInstance.set_pos(operationPos); 
	elif(unitType=="antivirus-2"):
		multiplicationInstance.setResult();
		multiplicationInstance.set_pos(operationPos);
	elif(unitType=="firewall"):
		subtractionInstance.setResult();
		subtractionInstance.set_pos(operationPos);
	elif(unitType=="bomb"):
		divisionInstance.setResult();
		divisionInstance.set_pos(operationPos);
		

func goodResultAction(operation):
	sampleMaster.play("result");
	if(operation=="sum"):
		sumInstance.set_pos(operationPosOutside);
		createUnit("antivirus");
		get_node("menu").setUnitCooldown("antivirus",true);
	elif(operation=="multiplication"):
		multiplicationInstance.set_pos(operationPosOutside);
		createUnit("antivirus-2");
		get_node("menu").setUnitCooldown("antivirus2",true);
	elif(operation=="subtraction"):
		subtractionInstance.set_pos(operationPosOutside);
		createUnit("firewall");
		get_node("menu").setUnitCooldown("firewall",true);
	elif(operation=="division"):
		divisionInstance.set_pos(operationPosOutside);
		createUnit("bomb");
		get_node("menu").setUnitCooldown("bomb",true);
	#TODO Se debe rehabilitar la posibilidad de dar click a los elementos de la interfaz una vez se responde una operacion
	
	


func fakeResultAction(operation):
	sampleMaster.play("fakeResult");
	if(operation=="sum"):
		sumInstance.set_pos(operationPosOutside);
		get_node("menu").setUnitCooldown("antivirus",false);
	elif(operation=="multiplication"):
		multiplicationInstance.set_pos(operationPosOutside);
		get_node("menu").setUnitCooldown("antivirus2",false);
	elif(operation=="subtraction"):
		subtractionInstance.set_pos(operationPosOutside);
		get_node("menu").setUnitCooldown("firewall",false);
	elif(operation=="division"):
		divisionInstance.set_pos(operationPosOutside);
		get_node("menu").setUnitCooldown("bomb",false);
	#TODO Se debe rehabilitar la posibilidad de dar click a los elementos de la interfaz una vez se responde una operacion


func createUnit(unitType):	
	var unitInstance;
	var unitName;
	if(unitType=="antivirus"):
		unitInstance = antivirusResource.instance();
		unitName = "antivirus";
	elif(unitType=="antivirus-2"):
		unitInstance = antivirus2Resource.instance();
		unitName = "antivirus-2";
	elif(unitType=="firewall"):
		unitInstance = firewallResource.instance();
		unitName = "firewall";
	elif(unitType=="bomb"):
		unitInstance = bombResource.instance();
		unitName = "bomb";
	
	unitInstance.set_name(unitName);	
	unitBoundedToMouse = unitInstance;
	add_child(unitBoundedToMouse);
	unitFollowMouse(mouseClickPosition);
	#TODO No se debe poder dar click en ningun elemento de la interfaz cuando se tiene una unidad por colocar


func unitFollowMouse(pos):
	var unitWidth = unitBoundedToMouse.get_texture().get_width();
	var unitHeigth = unitBoundedToMouse.get_texture().get_height();
	pos.x -= unitWidth/2;
	pos.y -= (unitHeigth-unitHeigth/4);
	unitBoundedToMouse.set_pos(pos);
	
func unitConfirmPosition(pos):
	var arrayXPos = getMapCoordinateX(pos.x);
	var arrayYPos = getMapCoordinateY(pos.y);
	if(arrayXPos!= null && arrayYPos!= null && occupiedUnitMap[arrayYPos][arrayXPos]==null):		
		var mapPosition = Vector2(filesXPosition[arrayXPos]-unitBoundedToMouse.get_texture().get_width()/4,rowsYPosition[arrayYPos]- unitBoundedToMouse.get_texture().get_height());
		unitBoundedToMouse.set_pos(mapPosition);
		var unitName = "";
		if(unitBoundedToMouse.get_name()=="antivirus"):
			unitName = str(arrayYPos)+"antivirus"+str(antivirusCount);
			unitBoundedToMouse.set_name(unitName);
			unitBoundedToMouse.isAttacking=true;
			antivirusInstances.push_back(unitBoundedToMouse.get_name());
			antivirusCount+=1;
		elif(unitBoundedToMouse.get_name()=="antivirus-2"):
			unitName = str(arrayYPos)+"antivirus-2"+str(antivirus2Count);
			unitBoundedToMouse.set_name(unitName);
			unitBoundedToMouse.isAttacking=true;
			antivirus2Instances.push_back(unitBoundedToMouse.get_name());
			antivirus2Count+=1;
		elif(unitBoundedToMouse.get_name()=="firewall"):
			unitName = str(arrayYPos)+"firewall"+str(firewallCount);
			unitBoundedToMouse.set_name(unitName);
			firewallInstances.push_back(unitBoundedToMouse.get_name());
			firewallCount+=1;
		elif(unitBoundedToMouse.get_name()=="bomb"):
			unitName=str(arrayYPos)+"bomb"+str(bombCount);
			unitBoundedToMouse.set_name(unitName);
			unitBoundedToMouse.isAttacking=true;
			bombInstances.push_back(unitBoundedToMouse.get_name());
			bombCount+=1;
		
		occupiedUnitMap[arrayYPos][arrayXPos]=unitName;
		unitBoundedToMouse = null;
		#TODO Se debe rehabilitar la posibilidad de dar click a los elementos de la interfaz una vez se pone la unidad
	else:
		pass
		#TODO Se debe reproducir un sonido de error, solo se pueden colocar unidades en puestos vacios y dentro de la cuadricula
	
func getMapCoordinateX(x):
	for i in range(9):
		if(filesXPosition[i]<=x && filesXPosition[i]+mapPositionWidth>=x) :
			return i;
	return null;
	
func getMapCoordinateY(y):
	for i in range(5):
		if(rowsYPosition[i]>=y && rowsYPosition[i]-mapPositionHeight<=y) :
			return i;
	return null;
	
func deleteFromUnitMap(unitType,mapY,mapX):
	var unit = occupiedUnitMap[mapY][mapX];
	occupiedUnitMap[mapY][mapX]=null;
	if(unitType=="antivirus"):
		antivirusInstances.erase(unit);
	elif(unitType=="antivirus2"):
		antivirus2Instances.erase(unit);
	elif(unitType=="firewall"):
		firewallInstances.erase(unit);
	elif(unitType=="bomb"):
		bombInstances.erase(unit);
	var node = get_node(unit);
	remove_and_delete_child(node);
	
func deleteEnemyFromMap(enemyType,enemyName):
	if(enemyType=="virus"):
		virusInstances.erase(enemyName);
	elif(enemyType=="worm"):
		wormInstances.erase(enemyName);
	elif(enemyType=="trojan"):
		bombInstances.erase(enemyName);
	var node = get_node(enemyName);
	remove_and_delete_child(node);
	
func createLaserInMap(position):
	var laser = laserResource.instance();
	laser.set_pos(position);
	var mapY = getMapCoordinateY(position.y);
	var laserName = str(mapY)+"laser"+str(laserCount); 
	laser.set_name(laserName);
	laserInstances.push_back(laserName);
	laserCount += 1;
	add_child(laser);


func deleteLaserFromMap(laserName):
	laserInstances.erase(laserName);
	remove_and_delete_child(get_node(laserName));
	
func checkWinOrLose():
	if(enemiesTotal-enemiesCreated<=0 && virusInstances.empty()==true && trojanInstances.empty() && wormInstances.empty()==true):
		winGame();
	else:
		var gameOver = false;
		for enemy in virusInstances:
			var enemyInstance = get_node(enemy);
			if(enemyInstance!=null):
				var enemyXPos = enemyInstance.get_pos().x;
				if(enemyXPos <= limitXToLose):
					gameOver=true;
					break;
		
		if(gameOver==false):
			for enemy in trojanInstances:
				var enemyInstance = get_node(enemy);
				if(enemyInstance!=null):
					var enemyXPos = enemyInstance.get_pos().x;
					if(enemyXPos <= limitXToLose):
						gameOver=true;
						break;
		
		if(gameOver==false):
			for enemy in wormInstances:
				var enemyInstance = get_node(enemy);
				if(enemyInstance!=null):
					var enemyXPos = enemyInstance.get_pos().x;
					if(enemyXPos <= limitXToLose):
						gameOver=true;
						break;
						
		if(gameOver==true):
			gameOver();
			
func winGame():
	print("WIIIIIN!!!!");
	
func gameOver():
	print("GAME OVER!!!!");