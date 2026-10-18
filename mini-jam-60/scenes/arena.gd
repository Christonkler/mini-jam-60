extends Control

@export var win: bool

# process vars
var start_time: int = 0
var lunch_time: int = 0
var death_time: int = 0
var univ_ctr: Vector2
var hitbox: Area2D
var init_avel: float
var init_avel2: float
var playa: Blade
var enemy: Blade
var dead_flag: bool = false
var music_started: bool = false
var player_lost: bool = false
var launched: bool = false
var launch_in_prog: bool = false
var launch_force: float
var sped_mod: float
var spin_mod: float
var has_upgrades : bool = false

var immune_start : int
var last_boss : bool = false

var enemy_pos_1 = Vector2(180, -130)
var enemy_pos_2 = Vector2(90, -90)
var playa_pos_1 = Vector2(-180, 130)
var playa_pos_2 = Vector2(-90, 90)



func mse(tim: int) -> int:
	return Time.get_ticks_msec() - tim

func d_curve(dist: float) -> float:
	# how does the arena pull force diminish with distance
	var R = 140
	var curve: float
	if dist >= R:
		curve = dist
	else:
		curve = (R - sqrt(R**2 - dist**2))
	return 6 * curve

func pull_mag(blade: RigidBody2D) -> float:
	return d_curve(blade.global_position.distance_to(univ_ctr))

func pull_dir(blade: RigidBody2D) -> Vector2:
	return (univ_ctr - blade.global_position).normalized()

func walk_mag(blade: RigidBody2D) -> float:
	var retval = 0
	if not randi() % 30:
		retval = 20 * blade.angular_velocity
	elif not randi() % 40:
		retval = -20 * blade.angular_velocity
	return blade.get_parent().walkin_spd * retval

func walk_dir(blade: RigidBody2D) -> Vector2:
	var ctr_dir: Vector2 = (univ_ctr - blade.global_position).normalized()
	return Vector2(-ctr_dir.y, ctr_dir.x)
	
func apply_pull(blade: RigidBody2D) -> void:
	var blade_parent = blade.get_parent()
	if not blade_parent.dead:
		blade.apply_central_force(pull_mag(blade) * pull_dir(blade))
		blade.apply_central_force(walk_mag(blade) * walk_dir(blade))

func apply_joik(blade: RigidBody2D, other: RigidBody2D) -> void:
	$SoundEffects.play_collision_sound()
	var outward_dir = (other.global_position - blade.global_position).normalized()
	outward_dir = Vector2.from_angle(outward_dir.angle() + 0.1*(randf()-0.5))
	blade.apply_central_force(20 * other.get_parent().bounciness / blade.get_parent().bounce_rst * abs(blade.angular_velocity) * outward_dir)
	if blade.get_parent().dmg_rst != 1 or other.get_parent().dmg != 1:
		blade.angular_velocity /= other.get_parent().dmg / blade.get_parent().dmg_rst
	blade.on_body_entered()
	other.on_body_entered()
	
func get_bar_prog() -> float:
	var speed = 1500
	return float(abs((mse(start_time) + speed) % (speed * 2) - speed)) / speed
	
func set_launch_bar_pos() -> void:
	var prog: float = get_bar_prog()
	var x_start = $bar.global_position.x + $barslider.texture.get_width()
	var x_end = x_start + $bar.texture.get_width() - $barslider.texture.get_width()
	var y_start = $bar.global_position.y + $bar.texture.get_height() / 2 - 4
	var ctr_pos = Vector2(x_start + prog*(x_end-x_start), y_start)
	$barslider.global_position = ctr_pos - $barslider.texture.get_size() / 2
	
func set_dont_lower_vel(blade: RigidBody2D, new_vel: Vector2) -> void:
	var cur_mag = blade.linear_velocity.length()
	if new_vel.length() < cur_mag:
		blade.linear_velocity = cur_mag * new_vel.normalized()
	else:
		blade.linear_velocity = new_vel
		
func fancy_pants_spline_vel(end_vel: float, dist: float, tim_left: float) -> float:
	var retval: float = 2 * dist / tim_left / 2 - end_vel
	return retval
	

func set_launch_in_prog_pos(delta: float) -> void:
	var lunch_len = 500
	var time_now = mse(lunch_time)
	if time_now <= lunch_len:
		var prog: float = float(time_now) / lunch_len
		var s_left: float = max(0.1, float(lunch_len - time_now) / 1000)
		# I tried to get fancy here but physics is kicking me in my fancy pants
		# if the launching fails try reverting back to the commented out code
		#playa.fysic.linear_velocity = (playa_pos_2 - playa.fysic.global_position) / s_left
		#enemy.fysic.linear_velocity = (enemy_pos_2 - enemy.fysic.global_position) / s_left
		var playa_offset = playa_pos_2 - playa.fysic.global_position
		playa.fysic.linear_velocity = fancy_pants_spline_vel(playa.init_vel * sped_mod, playa_offset.length(), s_left) * playa_offset.normalized()
		var enemy_offset = enemy_pos_2 - enemy.fysic.global_position
		enemy.fysic.linear_velocity = fancy_pants_spline_vel(enemy.init_vel, enemy_offset.length(), s_left) * enemy_offset.normalized()
		playa.fysic.angular_velocity = prog * playa.init_spin * spin_mod
		enemy.fysic.angular_velocity = prog * enemy.init_spin
	else:
		launch_in_prog = false
		$bar.visible = false
		$barslider.visible = false
		set_vars_post_launch()

func set_vars_post_launch() -> void:
	playa.fysic.linear_velocity = playa.init_vel * sped_mod * Vector2(1, 0)
	enemy.fysic.linear_velocity = enemy.init_vel * Vector2(-1, 0)
	playa.fysic.angular_velocity = playa.init_spin * spin_mod
	enemy.fysic.angular_velocity = enemy.init_spin
	init_avel = playa.fysic.angular_velocity * spin_mod
	init_avel2 = enemy.fysic.angular_velocity


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
		#if event.keycode == KEY_SPACE:  # gonna leave out particular key for now
		if not event.pressed:  # wait for release
			if not launched:
				lunch_time = Time.get_ticks_msec()
				launched = true
				if has_upgrades:
					$Label.visible = true
				launch_in_prog = true
				launch_force = get_bar_prog()
				spin_mod = 0.8 + 0.4 * launch_force
				sped_mod = 0.8 + 0.4 * launch_force

func count(lis, type):
	var total: int = 0
	for item in lis:
		if is_instance_of(item, type):
			total += 1
	return total
	
func remove_first(lis, type):
	var found = false
	var rmv_idx = 0
	for idx in range(lis.size()):
		if is_instance_of(lis[idx], type):
			rmv_idx = idx
			found = true
			break
	if found:
		lis.remove_at(rmv_idx)


func face_the_blade(guy: TextureRect, blade: Blade, offset: float) -> void:
	var guy_ctr = guy.global_position + guy.get_global_rect().size * guy.scale / 2
	var blade_ctr = blade.fysic.global_position
	if guy == $them:
		print(guy_ctr, ' : ', blade_ctr)
	guy.rotation = (blade_ctr-guy_ctr).angle() + offset


func _ready() -> void:
	if enemy == null:
		enemy = $Beyblade2
	else:
		remove_child($Beyblade2)
	for lis in Mappy.enemy_options:
		for dic in lis:
			if dic["blade"] == enemy.scene_file_path:
				$them.texture = load(dic["character_image"])
	playa = $PlayerBeyblade
	start_time = Time.get_ticks_msec()
	hitbox = $TextureRect/Area2D
	$needle.pivot_offset = Vector2(64, 20)
	$needle2.pivot_offset = Vector2(64, 20)
	playa.position = playa_pos_1
	enemy.position = enemy_pos_1
	playa_pos_2 += playa.pos_mod
	enemy_pos_2 += enemy.pos_mod
	univ_ctr.x = 0
	univ_ctr.y = 0
	while count(Global.upgrades, WheelAttaché) > 1:
		remove_first(Global.upgrades, WheelAttaché)
	for upgrade in Global.upgrades:
		if is_instance_of(upgrade, DroppableAttaché):
			has_upgrades = true
		if is_instance_of(upgrade, BreakableAttaché) or is_instance_of(upgrade, DroppableAttaché):
			var pin_joint : PinJoint2D = PinJoint2D.new()
			pin_joint.node_a = playa.fysic.get_path()
			playa.fysic.add_child(pin_joint)
			playa.fysic.add_child(upgrade)
			pin_joint.node_b = upgrade.get_path()
			upgrade.pin_joint = pin_joint
			playa.fysic.add_upgrade(upgrade)
		elif is_instance_of(upgrade,TipAttaché):
			match upgrade.scene_file_path:
				"res://scenes/eraser_tip.tscn":
					playa.walkin_spd *= 1.5
				"res://scenes/pencil_tip.tscn":
					playa.walkin_spd *= 0.66
					playa.fysic.linear_damp *= 0.9
					playa.fysic.angular_damp *= 0.75
					playa.dmg_rst *= 0.95
				"res://scenes/tip.tscn":
					pass
		elif is_instance_of(upgrade,WheelAttaché):
			print(upgrade.scene_file_path)
			for img in Shitems.texture_to_scene:
				if Shitems.texture_to_scene[img] == upgrade.scene_file_path:
					playa.fysic.get_child(1).texture = load(img)
			match upgrade.scene_file_path:
				"res://scenes/fan.tscn":
					playa.can_fly = true
				"res://scenes/brake_rotor.tscn":
					playa.dmg_rst *= 1.5
					playa.dmg *= 1.5
					playa.fysic.linear_damp *= 1.5

func proc_blade(blade: RigidBody2D) -> void:
	apply_pull(blade)
	var blade_parent = blade.get_parent()

	var others = blade.get_colliding_bodies()
	for other in others:
		if other.get_parent() is Blade:
			apply_joik(blade, other)
	if mse(start_time) > 50 and not hitbox.overlaps_body(blade) and mse(immune_start) > 50 and not blade_parent.can_fly:
		blade_parent.falling = true
		blade.disable_collision()
		blade_parent.dead = true
	if blade.angular_velocity < 3:
		blade_parent.dead = true
		
func proc_upgrade(upgrade: RigidBody2D) -> void:
	var fysic = upgrade.get_parent()

	var others = upgrade.get_colliding_bodies()
	for other in others:
		if other.get_parent() is Blade:
			apply_joik(upgrade, other)
	if mse(start_time) > 50 and not hitbox.overlaps_body(upgrade) and mse(immune_start) > 50 and \
		(upgrade.attached == false or fysic.get_parent().falling == true):
		upgrade.falling = true
		upgrade.disable_collision()

func _process(delta: float) -> void:
	face_the_blade($us, playa, -PI/2)
	face_the_blade($them, enemy, PI)
	if not launched:
		set_launch_bar_pos()
	elif launch_in_prog:
		set_launch_in_prog_pos(delta)
	else:
		for child in self.get_children():
			if is_instance_of(child, Blade):
				proc_blade(child.fysic)
				for upgrade in child.fysic.upgrades:
					proc_upgrade(upgrade)
				if child.dead:
					dead_flag = true
		$needle.rotation_degrees = -90 * abs(playa.fysic.angular_velocity / init_avel)
		$needle2.rotation_degrees = 90 + 90 * abs(enemy.fysic.angular_velocity / init_avel2)
		if dead_flag:
			if enemy.dead:
				$MatchResultScreen.displayMatchResultMessage('WINNER')
				if not music_started or player_lost:
					$MatchResultScreen/ResultMusicPlayer.play_results_music(true)
					music_started = true
					player_lost = false
					$BattleMusicPlayer.stop()
			else:
				$MatchResultScreen.displayMatchResultMessage('LOSER')
				if not music_started:
					$MatchResultScreen/ResultMusicPlayer.play_results_music(false)
					music_started = true
					player_lost = true
					$BattleMusicPlayer.stop()
		if dead_flag and not death_time:
			death_time = Time.get_ticks_msec()
		if dead_flag and mse(death_time) > 5000:
			Engine.time_scale = 1 # Resets game speed if fast forwarding
			Global.reset_arena_stuf()
			if enemy.dead:
				if last_boss:
					get_tree().change_scene_to_file("res://scenes/map.tscn")
				else:
					get_tree().change_scene_to_file("res://scenes/shop.tscn")
			else:
				get_tree().change_scene_to_file("res://scenes/mainu.tscn")
			
