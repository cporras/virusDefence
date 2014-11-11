##
# Copyright (c) 2014 Cristian Porras (porrascristian@gmail.com)
# Distributed under the GNU GPL v3. For full terms see the file LICENSE.
##

extends Node2D

## WORLD DEFINITION ##
var cooldownAntivirusResult=8; 
var cooldownAntivirusFake=10;

var cooldownAntivirus2Result=13; 
var cooldownAntivirus2Fake=11;

var cooldownFirewallResult=13; 
var cooldownFirewallFake=11; 

var cooldownBombResult=20; 
var cooldownBombFake=15; 


## GLOBAL VARIABLES ##
var actualCooldownAntivirus=0;
var actualCooldownAntivirus2=0; 
var actualCooldownFirewall=0; 
var actualCooldownBomb=0; 
var selectedAntivirusCooldown=0;
var selectedAntivirus2Cooldown=0;
var selectedFirewallCooldown=0; 
var selectedBombCooldown=0; 

func _ready():
	print("Menu Loaded");	
	get_node("antivirusButton").connect("pressed",self,"_on_antivirusButton_pressed");
	get_node("antivirus2Button").connect("pressed",self,"_on_antivirus2Button_pressed");
	get_node("firewallButton").connect("pressed",self,"_on_firewallButton_pressed");
	get_node("bombButton").connect("pressed",self,"_on_bombButton_pressed");	
	set_process(true);
	
func _process(delta):
	processCooldown(delta);

func _on_antivirusButton_pressed():
		print("Antivirus button");		
		get_node("antivirusButton").disabled = true;
		get_node("/root/game").showUnitsMenu("antivirus");
		
func _on_antivirus2Button_pressed():
		print("Antivirus 2 button");
		get_node("antivirus2Button").disabled = true;
		get_node("/root/game").showUnitsMenu("antivirus-2");
		
func _on_firewallButton_pressed():
		print("Firewall button");
		get_node("firewallButton").disabled = true;
		get_node("/root/game").showUnitsMenu("firewall");
		
func _on_bombButton_pressed():
		print("Bomb button");
		get_node("bombButton").disabled = true;
		get_node("/root/game").showUnitsMenu("bomb");


func processCooldown(delta):	
	if(actualCooldownAntivirus>0):
		actualCooldownAntivirus-=delta;
		if(actualCooldownAntivirus>0):
			get_node("antivirusButton/antivirusCooldown").show();
			get_node("antivirusButton/antivirusCooldown").set_scale(Vector2(1,(actualCooldownAntivirus/selectedAntivirusCooldown)));
		else:
			get_node("antivirusButton/antivirusCooldown").hide();
			get_node("antivirusButton/antivirusCooldown").set_scale(Vector2(1,1));
	elif(actualCooldownAntivirus<0):
		actualCooldownAntivirus=0;
		selectedAntivirusCooldown=0;
		get_node("antivirusButton/antivirusCooldown").hide();
		get_node("antivirusButton/antivirusCooldown").set_scale(Vector2(1,1));
		if !(get_node("antivirus2Button").disabled && get_node("firewallButton").disabled && get_node("bombButton").disabled):
			get_node("antivirusButton").disabled = false;
		
	if(actualCooldownAntivirus2>0):
		actualCooldownAntivirus2-=delta;
		if actualCooldownAntivirus2>0:
			get_node("antivirus2Button/antivirus2Cooldown").show();
			get_node("antivirus2Button/antivirus2Cooldown").set_scale(Vector2(1,(actualCooldownAntivirus2/selectedAntivirus2Cooldown)));
		else:
			get_node("antivirus2Button/antivirus2Cooldown").hide();
			get_node("antivirus2Button/antivirus2Cooldown").set_scale(Vector2(1,1));
	elif(actualCooldownAntivirus2<0):
		actualCooldownAntivirus2=0;
		selectedAntivirus2Cooldown=0;
		get_node("antivirus2Button/antivirus2Cooldown").hide();
		get_node("antivirus2Button/antivirus2Cooldown").set_scale(Vector2(1,1));
		if !(get_node("antivirusButton").disabled && get_node("firewallButton").disabled && get_node("bombButton").disabled):
			get_node("antivirus2Button").disabled = false;
		
	if(actualCooldownFirewall>0):
		actualCooldownFirewall-=delta;
		if actualCooldownFirewall>0:
			get_node("firewallButton/firewallCooldown").show();
			get_node("firewallButton/firewallCooldown").set_scale(Vector2(1,(actualCooldownFirewall/selectedFirewallCooldown)));
		else:
			get_node("firewallButton/firewallCooldown").hide();
			get_node("firewallButton/firewallCooldown").set_scale(Vector2(1,1));
	elif(actualCooldownFirewall<0):
		actualCooldownFirewall=0;
		selectedFirewallCooldown=0;
		get_node("firewallButton/firewallCooldown").hide();
		get_node("firewallButton/firewallCooldown").set_scale(Vector2(1,1));
		if !(get_node("antivirusButton").disabled && get_node("antivirus2Button").disabled && get_node("bombButton").disabled):
			get_node("firewallButton").disabled = false;
		
	if(actualCooldownBomb>0):
		actualCooldownBomb-=delta;
		if actualCooldownBomb>0:
			get_node("bombButton/bombCooldown").show();
			get_node("bombButton/bombCooldown").set_scale(Vector2(1,(actualCooldownBomb/selectedBombCooldown)));
		else:
			get_node("bombButton/bombCooldown").hide();
			get_node("bombButton/bombCooldown").set_scale(Vector2(1,1));
	elif(actualCooldownBomb<0):
		actualCooldownBomb=0;
		selectedBombCooldown=0;
		get_node("bombButton/bombCooldown").hide();
		get_node("bombButton/bombCooldown").set_scale(Vector2(1,1));
		if !(get_node("antivirusButton").disabled && get_node("antivirus2Button").disabled && get_node("firewallButton").disabled):
			get_node("bombButton").disabled = false;


func setUnitCooldown(unitType,result):
	if(unitType=="antivirus"):
		if(result==true):
			actualCooldownAntivirus = cooldownAntivirusResult;
			selectedAntivirusCooldown = cooldownAntivirusResult;
		else:
			actualCooldownAntivirus = cooldownAntivirusFake;
			selectedAntivirusCooldown = cooldownAntivirusFake;
	elif(unitType=="antivirus2"):
		if(result==true):
			actualCooldownAntivirus2 = cooldownAntivirus2Result;
			selectedAntivirus2Cooldown = cooldownAntivirus2Result;
		else:
			actualCooldownAntivirus2 = cooldownAntivirus2Fake;
			selectedAntivirus2Cooldown = cooldownAntivirus2Fake;
	elif(unitType=="firewall"):
		if(result==true):
			actualCooldownFirewall = cooldownFirewallResult;
			selectedFirewallCooldown = cooldownFirewallResult;
		else:
			actualCooldownFirewall = cooldownFirewallFake;
			selectedFirewallCooldown = cooldownFirewallFake;
	elif(unitType=="bomb"):
		if(result==true):
			actualCooldownBomb = cooldownBombResult;
			selectedBombCooldown = cooldownBombResult;
		else:
			actualCooldownBomb = cooldownBombFake;
			selectedBombCooldown = cooldownBombFake;
			
func blockOperations():
	get_node("antivirusButton").disabled = true;
	get_node("antivirus2Button").disabled = true;
	get_node("firewallButton").disabled = true;
	get_node("bombButton").disabled = true;
	
func restoreOperationsExceptOne(unitType):
	if(unitType=="antivirus"):
		if(actualCooldownAntivirus2<=0):
			get_node("antivirus2Button").disabled = false;
		if(actualCooldownFirewall<=0):
			get_node("firewallButton").disabled = false;
		if(actualCooldownBomb<=0):
			get_node("bombButton").disabled = false;
	elif(unitType=="antivirus2"):
		if(actualCooldownAntivirus<=0):
			get_node("antivirusButton").disabled = false;
		if(actualCooldownFirewall<=0):
			get_node("firewallButton").disabled = false;
		if(actualCooldownBomb<=0):
			get_node("bombButton").disabled = false;
	elif(unitType=="firewall"):
		if(actualCooldownAntivirus<=0):
			get_node("antivirusButton").disabled = false;
		if(actualCooldownAntivirus2<=0):
			get_node("antivirus2Button").disabled = false;
		if(actualCooldownBomb<=0):
			get_node("bombButton").disabled = false;
	elif(unitType=="bomb"):
		if(actualCooldownAntivirus<=0):
			get_node("antivirusButton").disabled = false;
		if(actualCooldownAntivirus2<=0):
			get_node("antivirus2Button").disabled = false;
		if(actualCooldownFirewall<=0):
			get_node("firewallButton").disabled = false;
	
	