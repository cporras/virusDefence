extends Node

var loadingResource = preload("res://resources/ui/loading.xml");
var loadingInstance
var loader
var wait_frames
var time_max = 100 # msec
var current_scene

func _ready():
	var root = get_node("/root/");
	current_scene = root.get_child( root.get_child_count() -1 );

func goto_scene(scene):
	var s = ResourceLoader.load(scene);
	current_scene.queue_free();
	current_scene = s.instance();
	get_node("/root/").add_child(current_scene);

func goto_scene_interactive(path):
	loader = ResourceLoader.load_interactive(path);
	if loader == null:
		show_error();
		return;
		
	set_process(true);
	current_scene.queue_free();
	wait_frames = 20;
	loadingInstance = loadingResource.instance();
	add_child(loadingInstance);    


func _process(time):
	if loader == null:
		set_process(false);
		return;
		
	if wait_frames > 0:
		wait_frames -= 1;
		return;
		
	var t = OS.get_ticks_msec();
	
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control how much time we block this thread
		# poll your loader
		var err = loader.poll();
		
		if err == ERR_FILE_EOF: # load finished
			var resource = loader.get_resource();
			loader = null;
			remove_and_delete_child(loadingInstance);
			set_new_scene(resource);
			break;
		elif err == OK:
			update_progress();
		else: # error during loading
			show_error();
			loader = null;
			break;
			
func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count();
	var len = loadingInstance.get_node("anim").get_current_animation_length()
	# call this on a paused animation. use "true" as the second parameter to force the animation to update
	loadingInstance.get_node("anim").seek(progress * len, true)

func set_new_scene(scene_resource):
	current_scene = scene_resource.instance();
	get_node("/root").add_child(current_scene);