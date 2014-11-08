##
# Copyright (c) 2014 Cristian Porras (porrascristian@gmail.com)
# Distributed under the GNU GPL v3. For full terms see the file LICENSE.
##

extends Node2D

## WORLD DEFINITION ##
var cooldownAntivirusResult=5; 
var cooldownAntivirusFake=3; 

var cooldownAntivirus2Result=5; 
var cooldownAntivirus2Fake=3;

var cooldownFirewallResult=9; 
var cooldownFirewallFake=5; 

var cooldownBombResult=12; 
var cooldownBombFake=10; 

## GLOBAL VARIABLES ##
var actualCooldownAntivirus=0;
var actualCooldownAntivirus2=0; 
var actualCooldownFirewall=0; 
var actualCooldownBomb=0; 

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
			get_node("antivirusButton/antivirusCooldown").set_scale(Vector2(1,(actualCooldownAntivirus/1)));
		else:
			get_node("antivirusButton/antivirusCooldown").hide();
			get_node("antivirusButton/antivirusCooldown").set_scale(Vector2(1,1));
	elif(actualCooldownAntivirus<0):
		actualCooldownAntivirus=0;
		get_node("antivirusButton/antivirusCooldown").hide();
		get_node("antivirusButton/antivirusCooldown").set_scale(Vector2(1,1));
		if !(get_node("antivirus2Button").disabled && get_node("firewallButton").disabled && get_node("bombButton").disabled):
			get_node("antivirusButton").disabled = false;
		
	if(actualCooldownAntivirus2>0):
		actualCooldownAntivirus2-=delta;
		if actualCooldownAntivirus2>0:
			get_node("antivirus2Button/antivirus2Cooldown").show();
			get_node("antivirus2Button/antivirus2Cooldown").set_scale(Vector2(1,(actualCooldownAntivirus2/1)));
		else:
			get_node("antivirus2Button/antivirus2Cooldown").hide();
			get_node("antivirus2Button/antivirus2Cooldown").set_scale(Vector2(1,1));
	elif(actualCooldownAntivirus2<0):
		actualCooldownAntivirus2=0;
		get_node("antivirus2Button/antivirus2Cooldown").hide();
		get_node("antivirus2Button/antivirus2Cooldown").set_scale(Vector2(1,1));
		if !(get_node("antivirusButton").disabled && get_node("firewallButton").disabled && get_node("bombButton").disabled):
			get_node("antivirus2Button").disabled = false;
		
	if(actualCooldownFirewall>0):
		actualCooldownFirewall-=delta;
		if actualCooldownFirewall>0:
			get_node("firewallButton/firewallCooldown").show();
			get_node("firewallButton/firewallCooldown").set_scale(Vector2(1,(actualCooldownFirewall/1)));
		else:
			get_node("firewallButton/firewallCooldown").hide();
			get_node("firewallButton/firewallCooldown").set_scale(Vector2(1,1));
	elif(actualCooldownFirewall<0):
		actualCooldownFirewall=0;
		get_node("firewallButton/firewallCooldown").hide();
		get_node("firewallButton/firewallCooldown").set_scale(Vector2(1,1));
		if !(get_node("antivirusButton").disabled && get_node("antivirus2Button").disabled && get_node("bombButton").disabled):
			get_node("firewallButton").disabled = false;
		
	if(actualCooldownBomb>0):
		actualCooldownBomb-=delta;
		if actualCooldownBomb>0:
			get_node("bombButton/bombCooldown").show();
			get_node("bombButton/bombCooldown").set_scale(Vector2(1,(actualCooldownBomb/1)));
		else:
			get_node("bombButton/bombCooldown").hide();
			get_node("bombButton/bombCooldown").set_scale(Vector2(1,1));
	elif(actualCooldownBomb<0):
		actualCooldownBomb=0;
		get_node("bombButton/bombCooldown").hide();
		get_node("bombButton/bombCooldown").set_scale(Vector2(1,1));
		if !(get_node("antivirusButton").disabled && get_node("antivirus2Button").disabled && get_node("firewallButton").disabled):
			get_node("bombButton").disabled = false;


func setUnitCooldown(unitType,result):
	if(unitType=="antivirus"):
		if(result==true):
			actualCooldownAntivirus = cooldownAntivirusResult;
		else:
			actualCooldownAntivirus = cooldownAntivirusFake;
	elif(unitType=="antivirus2"):
		if(result==true):
			actualCooldownAntivirus2 = cooldownAntivirus2Result;
		else:
			actualCooldownAntivirus2 = cooldownAntivirus2Fake;
	elif(unitType=="firewall"):
		if(result==true):
			actualCooldownFirewall = cooldownFirewallResult;
		else:
			actualCooldownFirewall = cooldownFirewallFake;
	elif(unitType=="bomb"):
		if(result==true):
			actualCooldownBomb = cooldownBombResult;
		else:
			actualCooldownBomb = cooldownBombFake;
			
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
	
	