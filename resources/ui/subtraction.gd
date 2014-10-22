##
# Copyright (c) 2014 Cristian Porras (porrascristian@gmail.com)
# Distributed under the GNU GPL v3. For full terms see the file LICENSE.
##

extends Node2D

var num1 = 0;
var num2 = 0;
var result = 0;
var fakeResult1 = 0;
var fakeResult2 = 0;
var rowYResult = [132,216,300];


func _ready():
	get_node("result").connect("pressed",self,"_on_result_pressed")
	get_node("fakeResult1").connect("pressed",self,"_on_fakeResult_pressed")
	get_node("fakeResult2").connect("pressed",self,"_on_fakeResult_pressed")
	setResult();
	set_process(true);

func setResult():
	randomize();
	num1 = round (rand_range(10,99));
	num2 = round (rand_range(10,99));
	result = num1-num2;
	if(rand_range(0,2)<1):
		fakeResult1 = result + round (rand_range(1,20));
	else:
		fakeResult1 = result - round (rand_range(1,20));
	
	fakeResult2 = round (rand_range(-98,98));
	while (result == fakeResult2):
		randomize();
		fakeResult2 = round (rand_range(-98,98));
	
	
	get_node("num1").set_text(str(num1));	
	get_node("num2").set_text(str(num2));	
	get_node("result").set_text(str(result));	
	get_node("fakeResult1").set_text(str(fakeResult1));	
	get_node("fakeResult2").set_text(str(fakeResult2));
	
	var resultPos = randi() % 3;
	
	var fakePos1 = randi() % 3;
	while (resultPos == fakePos1):
		randomize();
		fakePos1 = randi() % 3;
	
	var fakePos2;
	if(resultPos==0):
		if(fakePos1==1):
			fakePos2 =2;
		else:
			fakePos2 =1;
	elif(resultPos==1):
		if(fakePos1==0):
			fakePos2 =2;
		else:
			fakePos2 =0;
	elif(resultPos==2):
		if(fakePos1==0):
			fakePos2 =1;
		else:
			fakePos2 =0;
	
	var pos = get_node("result").get_pos();
	pos.y = rowYResult[resultPos];
	get_node("result").set_pos(pos);
	
	pos = get_node("fakeResult1").get_pos();
	pos.y = rowYResult[fakePos1];
	get_node("fakeResult1").set_pos(pos);
	
	pos = get_node("fakeResult2").get_pos();
	pos.y = rowYResult[fakePos2];
	get_node("fakeResult2").set_pos(pos);
	
func _on_result_pressed():
		print("Correct Result");
		get_node("/root/game").goodResultAction("subtraction");

func _on_fakeResult_pressed():
		print("Fake Result");
		get_node("/root/game").fakeResultAction("subtraction");
