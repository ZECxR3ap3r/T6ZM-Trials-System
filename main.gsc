#include codescripts/struct;
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zombies/_zm_score;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/gametypes_zm/_spawning;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_zonemgr;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_power;
#include maps/mp/zombies/_zm_powerups;

// Trials System by ZECxR3ap3r

init() {
	// Precaching
	precachemodel("t6_wpn_zmb_jet_gun_world");
	precachemodel("zombie_pickup_perk_bottle");
	precachemodel("t6_wpn_zmb_raygun_view");
	precachemodel("p6_anim_zm_buildable_pap");
	precachemodel("collision_wall_256x256x10_standard");
	precachemodel("p6_zm_hr_lion_statue_base");
	precachemodel("p6_zm_hr_lion_statue");
	precacheshader("gradient");
	precacheshader("white");
	precacheshader("menu_mp_star_rating");
	precacheshader("gradient_fadein");
	precacheshader("scorebar_zom_1");
	precacheshader("codtv_info");
	// Settings
	setDvar("TrialsCost", 500);// How Much the trials will cost
	setDvar("TrialsAllowFreePerk", 1);// Adds a Free Perk Powerup to the Trials Rewards
	setDvar("TrialsEnableWonderweapons", 1);// Adds Legendary Wonderweapon Rewards
	setDvar("TrialsEnablePapDrop", 1);// Adds Legendary Pap Powerup Reward
	// Setup
	if(level.script == "zm_transit") {
		if(getDvar( "ui_zm_mapstartlocation" ) == "transit" && getDvar( "ui_zm_gamemodegroup" ) != "zsurvival"|| getDvar( "ui_zm_mapstartlocation" ) == "town"){
			Collision = spawn( "script_model", (655.126, -281.746, -61.875));
			Collision.angles = (0, 0, 0);
			Collision setmodel("collision_wall_512x512x10_standard");
    		PodiumModel = "t6_wpn_zmb_jet_gun_world";
    		PodiumOrigin = array((495.129, -289.81, -39.875), (595.129, -289.81, -39.875), (775.129, -289.81, -39.875), (875.129, -289.81, -39.875));
    		PodiumAngles = array((90, 270, 0), (90, 270, 0), (90,270,0), (90,270,0));
    		TrialsMainModel = "zombie_teddybear";
    		TrialsMainOrigin = (685.358, -277.641, -33.0248);
    		TrialsMainAngles = (0, -90, 0);
    		FXOriginOffset = (0,10,18);
    	}
   	 	else if ( getDvar( "ui_zm_mapstartlocation" ) == "farm" ) {
			Collision = spawn( "script_model", (7070.82, -5715.47, -46.2625));
			Collision.angles = (0, 90, 0);
			Collision setmodel("collision_wall_256x256x10_standard");
    		PodiumModel = "t6_wpn_zmb_jet_gun_world";
    		PodiumOrigin = array((7070.94, -5798.61, -28.2646), (7070.94, -5744.61, -28.2646), (7070.94, -5692.61, -28.2646), (7070.94, -5638.61, -28.2646));
    		PodiumAngles = array((90, 0, 0), (90, 0, 0), (90,0,0), (90,0,0));
    		TrialsMainModel = "zombie_teddybear";
    		TrialsMainOrigin = (7670.15, -5562.8, 50.5099);
    		TrialsMainAngles = (0, -50, 0);
    		FXOriginOffset = (-12,0,20);
    	}
    	else if ( getDvar( "ui_zm_mapstartlocation" ) == "transit" && getDvar( "ui_zm_gamemodegroup" ) == "zsurvival") {
			Collision = spawn( "script_model", (-6289.62, 5455.29, 74.125));
			Collision.angles = (0, 90, 0);
			Collision setmodel("collision_wall_256x256x10_standard");
    		PodiumModel = "t6_wpn_zmb_jet_gun_world";
    		PodiumOrigin = array((-6284.36, 5347.11, -35.875), (-6284.36, 5407.11, -35.875), (-6284.36, 5467.11, -35.875), (-6284.36, 5527.11, -35.875));
    		PodiumAngles = array((90, 0, 0), (90, 0, 0), (90,0,0), (90,0,0));
    		TrialsMainModel = "zombie_teddybear";
    		TrialsMainOrigin = (-6097.18, 5610.29, -3.875);
    		TrialsMainAngles = (0, -130, 0);
    		FXOriginOffset = (-12,0,20);
    	}
    }
    else if(level.script == "zm_prison") {
    	Collision = spawn( "script_model", (2250.64, 9891.08, 1964.13));
		Collision.angles = (0, 90, 0);
		Collision setmodel("collision_wall_512x512x10_standard");
    	PodiumModel = "p6_zm_al_electric_chair";
    	PodiumOrigin = array((2232.09, 9754.98, 1704.13), (2232.09, 9844.98, 1704.13), (2232.09, 9934.98, 1704.13), (2232.09, 10025, 1704.13));
    	PodiumAngles = array((0, 0, 0), (0, 0, 0), (0,0,0), (0,0,0));
    	TrialsMainModel = "p6_zm_al_wall_trap_control_red";
    	TrialsMainOrigin = (2470.36, 9752.72, 1764.13);
    	TrialsMainAngles = (0, -180, 0);
    	FXOriginOffset = (17,0,15);
    }
    else if(level.script == "zm_buried") {
    	Collision = spawn( "script_model", (1355.53, 1397.91, 336.474));
		Collision.angles = (0, -20, 0);
		Collision setmodel("collision_wall_256x256x10_standard");
    	PodiumModel = "p6_zm_bu_ether_amplifier";
    	PodiumOrigin = array((1416.2, 1364.68, 200.125), (1365.2, 1383.68, 200.125), (1307.2, 1403.68, 200.125), (1247.2, 1425.68, 200.125));
    	PodiumAngles = array((0, 0, 0), (0, 0, 0), (0,0,0), (0,0,0));
    	TrialsMainModel = "zombie_teddybear";
    	TrialsMainOrigin = (1634.18, 2214.07, 100.125);
    	TrialsMainAngles = (0, -110, 0);
    	FXOriginOffset = (0,0,43);
    }
    else if(level.script == "zm_tomb") {
    	Collision = spawn( "script_model", (401.108, 2118.76, -122.744));
		Collision.angles = (0, 0, 0);
		Collision setmodel("zm_collision_perks1");
    	PodiumModel = "p6_zm_tm_challenge_box";
    	PodiumOrigin = array((538.473, 2119.9, -127.875), (458.473, 2119.9, -127.875), (348.473, 2119.9, -127.875), (268.473, 2119.9, -127.875));
    	PodiumAngles = array((0, 0, 0), (0, 0, 0), (0,0,0), (0,0,0));
    	TrialsMainModel = "p6_zm_tm_puzzle_lever_switch";
    	TrialsMainOrigin = (401.108, 2118.76, -122.744);
    	TrialsMainAngles = (0, 0, 0);
    	FXOriginOffset = (0,0,30);
    }
    else if(level.script == "zm_nuked") {
    	Collision = spawn( "script_model", (578.573, 742.585, -64.1112));
		Collision.angles = (0, -164, 0);
		Collision setmodel("collision_wall_256x256x10_standard");
    	PodiumModel = "dest_zm_nuked_male_01_d0";
    	PodiumOrigin = array((665.924, 740.986, -56.875), (617.924, 726.986, -56.875), (565.924, 712.986, -56.875), (515.924, 698.986, -56.875));
    	PodiumAngles = array((0, -250, 0), (0, -250, 0), (0,-250,0), (0,-250,0));
    	TrialsMainModel = "zombie_teddybear";
    	TrialsMainOrigin = (661.327, 983.586, -52.875);
    	TrialsMainAngles = (0, -150, 0);
    	FXOriginOffset = (-4,15,14);
    }
    else if(level.script == "zm_highrise") {
    	Collision = spawn( "script_model", (1430.19, -348.386, 2624.13));
		Collision.angles = (0, 60, 0);
		Collision setmodel("collision_wall_512x512x10_standard");
		Lion1 = spawn( "script_model", (1347.93, -459.859, 2742.13));
		Lion1.angles = (0, 60, 0);
		Lion1 setmodel("p6_zm_hr_lion_statue");
		Lion2 = spawn( "script_model", (1400.9, -368.924, 2742.13));
		Lion2.angles = (0, 60, 0);
		Lion2 setmodel("p6_zm_hr_lion_statue");
		Lion3 = spawn( "script_model", (1483.22, -226.259, 2742.13));
		Lion3.angles = (0, 60, 0);
		Lion3 setmodel("p6_zm_hr_lion_statue");
		Lion4 = spawn( "script_model", (1534.45, -137.528, 2742.13));
		Lion4.angles = (0, 60, 0);
		Lion4 setmodel("p6_zm_hr_lion_statue");
    	PodiumModel = "p6_zm_hr_lion_statue_base";
    	PodiumOrigin = array((1347.93, -459.859, 2704.13), (1400.9, -368.924, 2704.13), (1483.22, -226.259, 2704.13), (1534.45, -137.528, 2704.13));
    	PodiumAngles = array((0, 60, 0), (0, 60, 0), (0,60,0), (0,60,0));
    	TrialsMainModel = "zombie_teddybear";
    	TrialsMainOrigin = (1434.69, -296.901, 2749.13);
    	TrialsMainAngles = (0, -35, 0);
    	FXOriginOffset = (0,2,55);
    }
	level.ReaperTrialsActive = 0;
	level thread TrialsSystem(FXOriginOffset,PodiumModel, PodiumOrigin, PodiumAngles, TrialsMainModel, TrialsMainOrigin, TrialsMainAngles);
	level thread onPlayerConnect();
	
	// Rewards (i know its a Mess)
	if(level.script != "zm_prison" && level.script != "zm_tomb")
		AddReward("Legendary", undefined, "Skullcrusher", "m16_gl_upgraded_zm", 0);
	AddReward("Legendary", "Zombie_Skull", "Insta Kill", "insta_kill", 1);
	AddReward("Legendary", "zombie_ammocan", "Max Ammo", "full_ammo", 1);
	if(level.script != "zm_highrise")
		AddReward("Legendary", "zombie_z_money_icon", "Bonus Points", "Bonus_Points", 1);
	if(getdvarint("TrialsAllowFreePerk") == 1)
		AddReward("Legendary", "zombie_pickup_perk_bottle", "Free Perk", "free_perk", 1);
	AddReward("Legendary", "t6_wpn_zmb_raygun_view", "Ray Gun", "ray_gun_zm", 0);
	AddReward("Legendary", undefined, "Galil", "galil_upgraded_zm", 0);
	AddReward("Legendary", undefined, "HAMR", "hamr_upgraded_zm", 0);
	if(getdvarint("TrialsEnableWonderweapons") == 1) {
		AddReward("Legendary", undefined, "Ray Gun Mark 2", "raygun_mark2_zm", 0);
		if(level.script == "zm_prison")
			AddReward("Legendary", undefined, "Blundergat", "blundergat_zm", 0);
		if(level.script == "zm_buried")
			AddReward("Legendary", undefined, "Paralyzer", "slowgun_zm", 0);
	}
	if(getdvarint("TrialsEnablePapDrop") == 1)
		AddReward("Legendary", "p6_anim_zm_buildable_pap", "Weapon Upgrade", "WeaponUpgrade", 1);
		
	AddReward("Epic", "Zombie_Skull", "Insta Kill", "insta_kill", 1);
	AddReward("Epic", "zombie_x2_icon", "Double Points", "double_points", 1);
	if(level.script != "zm_highrise" && level.script != "zm_prison")
		AddReward("Epic", "zombie_z_money_icon", "Bonus Points", "Bonus_Points", 1);
	AddReward("Epic", undefined, "DSR-50", "dsr50_zm", 0);
	AddReward("Epic", undefined, "Galil", "galil_zm", 0);
	AddReward("Epic", undefined, "B23r", "beretta93r_zm", 0);
	if(level.script != "zm_prison")
		AddReward("Epic", undefined, "M16", "m16_zm", 0);
	if(level.script != "zm_nuked")
		AddReward("Rare", "zombie_carpenter", "Carpenter", "carpenter", 1);
	if(level.script != "zm_highrise")
		AddReward("Rare", "zombie_z_money_icon", "Bonus Points", "Bonus_Points", 1);
	AddReward("Rare", "zombie_x2_icon", "Double Points", "double_points", 1);
	AddReward("Rare", "zombie_bomb", "Nuke", "nuke", 1);
	AddReward("Rare", undefined, "KAP-40", "kard_zm", 0);
	AddReward("Rare", undefined, "M1911", "m1911_zm", 0);
	AddReward("Rare", undefined, "Remington", "870mcs_zm", 0);
	
	AddReward("Common", "zombie_carpenter", "Carpenter", "carpenter", 1);
	if(level.script != "zm_highrise")
		AddReward("Common", "zombie_z_money_icon", "Bonus Points", "Lose_Points", 1);
	AddReward("Common", "zombie_bomb", "Nuke", "nuke", 1);
	if(level.script != "zm_prison" && level.script != "zm_tomb")
		AddReward("Common", undefined, "SMR", "saritch_zm", 0);
	AddReward("Common", undefined, "M14", "m14_zm", 0);
	if(level.script == "zm_tomb") {
		AddReward("Epic", "p6_zm_tm_blood_power_up", "Zombie Blood", "zombie_blood", 1);
		AddReward("Epic", undefined, "STG44", "mp44_zm", 0);
		AddReward("Rare","p6_zm_tm_blood_power_up", "Zombie Blood", "zombie_blood", 1);
		AddReward("Rare", undefined, "STG44", "mp44_zm", 0);
		AddReward("Common", "p6_zm_tm_blood_power_up", "Zombie Blood", "zombie_blood", 1);
		AddReward("Common", undefined, "Mauser", "c96_zm", 0);
		AddReward("Common", undefined, "Ballista", "ballista_zm", 0);
		flag_wait("initial_blackscreen_passed");
		playfx(level._effect[ "fx_tomb_chamber_glow_blue" ], PodiumOrigin[0] - (0,0,10), (0,90,0), (0,90,0));
		playfx(level._effect[ "fx_tomb_chamber_glow_yellow" ], PodiumOrigin[1] - (0,0,10), (0,0,0), (0,90,0));
		playfx(level._effect[ "fx_tomb_crafting_chamber_glow" ], PodiumOrigin[2] - (0,0,10));
		playfx(level._effect[ "fx_tomb_chamber_glow_red" ], PodiumOrigin[3] - (0,0,10));
	}
	else {
		AddReward("Legendary", undefined, "RPD", "rpd_zm", 0);
		AddReward("Epic", undefined, "MP5", "mp5k_zm", 0);
		AddReward("Epic", undefined, "RPG", "usrpg_zm", 0);
		AddReward("Rare", undefined, "MP5", "mp5k_zm", 0);
		AddReward("Rare", undefined, "RPG", "usrpg_zm", 0);
		AddReward("Common", undefined, "MP5", "mp5k_zm", 0);
		AddReward("Common", undefined, "M1911", "m1911_zm", 0);
		AddReward("Common", undefined, "Olympia", "rottweil72_zm", 0);
	}
}

AddReward(TrialRank, RewardModel, RewardHintname, RewardCodename, Powerup) {
	if(!isdefined(level.Rewards_List))
		level.Rewards_List = [];
	
	Reward = SpawnStruct();
	Reward.Rank = TrialRank;
	if(isdefined(RewardModel))
		Reward.Model = RewardModel;
	else
		Reward.Model = getweaponmodel(RewardCodename);
	Reward.Hint = RewardHintname;
	Reward.Name = RewardCodename;
	Reward.Powerup = Powerup;
		
	level.Rewards_List[level.Rewards_List.size] = Reward;
}

init_trial_hud() {
    // HUD settings such as sizes, position and fallbacks
    self.trials_height = 28;
    self.trials_width = int(self.trials_height * 5);
    self.trials_space = int(self.trials_height * .115);
    self.trials_star = int(self.trials_space * 2.35);
    self.trials_x = 5;
    self.trials_y = -120 - self.trials_height;
    self.trials_reward_color = (.8, 0, 0);
    self.trials_reward_code = "none";
    self.trials_reward_color_code = "^1";
    self.trials_reward_level = "^1None";
    self.do_trial_progress = false;
    self.trials_init = true;
}

onplayerconnect() {
	level endon("end_game");
	for ( ;; ) {
		level waittill( "connected", player );
		player thread onplayerspawned();
    }
}

onplayerspawned() {
	level endon("end_game");
	self endon( "disconnect" );
	for ( ;; ) {
		self waittill( "spawned_player" );
		if(!isdefined(self.initial_spawn)) {
			self.initial_spawn = 1;
			self.ReaperTrialsCurrentMagic = 0;
			self init_trial_hud();
			wait 15;
			self iprintln("^5Trials System Version 1.0 ^7By ^1ZECxR3ap3r ^7& ^1John Kramer");
		}
	}
}

TriggerRewardHandler(player, Name, Powerup) {
	level endon("end_game");
	self endon("Timeout");
	self endon("Grabbed");
	while(1){
		if(player usebuttonpressed() && player istouching(self)){
			if(Powerup == 0){
				if(Name == "ray_gun_zm" && player has_weapon_or_upgrade("raygun_mark2_zm") || Name == "Mark2" && player has_weapon_or_upgrade("ray_gun_zm")){
					player playlocalsound( level.zmb_laugh_alias );
					self notify("Grabbed");
				}
				if(player has_weapon_or_upgrade(Name)){
					player playlocalsound( level.zmb_laugh_alias );
					self notify("Grabbed");
				}
				primaryweapons = player getweaponslistprimaries();
				if ( isDefined( primaryweapons ) && primaryweapons.size > 1 )
					player takeweapon(player getcurrentweapon());
				wait 0.1;
				player giveweapon(Name);
				player switchtoweapon(Name);
				self notify("Grabbed");
			}
			else{
				wait 0.1;
				if(Name == "free_perk")
					free_perk = player maps/mp/zombies/_zm_perks::give_random_perk();
				else if(Name == "Bonus_Points")
					player.score += randomintrange( 1, 50 ) * 100;
				else if(Name == "Lose_Points")
					player.score -= randomintrange( 1, 50 ) * 100;
				else if(Name == "WeaponUpgrade"){
					weapon = player get_upgrade_weapon( player getcurrentweapon(), 0 );
					if(IsDefined( weapon )){
						player takeweapon( player getcurrentweapon());
						player giveweapon( weapon, 0, player get_pack_a_punch_weapon_options( weapon ) );
						player givestartammo( weapon );
						player givemaxammo( weapon );
						player switchtoweapon( weapon );
					}
					else
						player playlocalsound( level.zmb_laugh_alias );
				}
				else
					specific_powerup_drop(Name, player.origin);
				self notify("Grabbed");
			}
		}
		wait 0.2;
	}
}

Random_Reward(TrialLevel) {	
	Choosen = [];
	for(i = 0; i < level.Rewards_List.size;i++){
		if(isdefined(level.Rewards_List[i].Rank) && level.Rewards_List[i].Rank == TrialLevel){
			Choosen[Choosen.size] = i;
		}
	}
	return Choosen[randomint(Choosen.size)];
}

RewardModelMain() {
    self endon("Done");
    level endon("end_game");
    if(level.script == "zm_tomb")
    	playfxontag(level._effect[ "ice_glow" ], self, "tag_origin");
   	else
    	playfxontag(level._effect["powerup_on_solo"], self, "tag_origin");
	while(isDefined( self )){
		waittime = randomfloatrange(2.5, 5);
		yaw = randomint(360);
		if(yaw > 300)
			yaw = 300;
		else{
			if (yaw < 60){
				yaw = 60;
			}
		}
		yaw = self.angles[1] + yaw;
		new_angles = (-60 + randomint(120), yaw, -45 + randomint(90) );
		self rotateto( new_angles, waittime, waittime * 0.5, waittime * 0.5 );
		if ( isDefined( self.worldgundw ) )
			self.worldgundw rotateto( new_angles, waittime, waittime * 0.5, waittime * 0.5 );
		wait randomfloat( waittime - 0.1 );
	}
}

TrialsSystem(CalculatedOrigin,SelectedModel, Origin, Angles, ActivatiorModel, ActivatiorOrigim, ActivatorAngles) {
	level endon("end_game");
	
	Challenges = [];
	Challenges[Challenges.size] = "K_Trial";// Regular Kills
	Challenges[Challenges.size] = "HK_Trial";// Headshot Kills
	Challenges[Challenges.size] = "MK_Trial";// Melee Kills
	Challenges[Challenges.size] = "GO_Trial";// Kill Zombies With Grenades
	Challenges[Challenges.size] = "C_Trial";// Kill Zombies While Crouched
	Challenges[Challenges.size] = "NH_Trial";// No Hits
	Challenges[Challenges.size] = "BRS_Trial";// Buy Stuff
	Challenges[Challenges.size] = "NAIM_Trial";// No Aim
	Challenges[Challenges.size] = "CR_Trial";// Close Range Kills
	Challenges[Challenges.size] = "BR_Trial";// Big Range Kills
	Challenges[Challenges.size] = "TD_Trial";// Take Damage
	Challenges[Challenges.size] = "PK_Trial";// Prone Kills
	if(level.script == "zm_transit" && getDvar( "ui_gametype" ) == "zsurvival" ) {
		if(getDvar( "ui_zm_mapstartlocation" ) == "town") {
			Challenges[Challenges.size] = "KISZ_Trial";// Kill In Random Zone
			Challenges[Challenges.size] = "SISZ_Trial";// Stay In Random Zone
			Challenges[Challenges.size] = "NPAP_Trial";// Kill With no Pap Weapon
			Challenges[Challenges.size] = "PAP_Trial";// Kill With Pap Weapon
		}
	}
	
	TrialPodium_Player1 = spawn( "script_model", Origin[0]);
	TrialPodium_Player1.angles = Angles[0];
	TrialPodium_Player1 setmodel(SelectedModel);
	TrialPodium_Player1 thread PodiumSetupTrigger(Origin[0] + CalculatedOrigin,0);
	TrialPodium_Player1 thread PodiumSetupTrigger(Origin[0] + CalculatedOrigin,4);
	
	TrialPodium_Player2 = spawn( "script_model", Origin[1]);
	TrialPodium_Player2.angles = Angles[1];
	TrialPodium_Player2 setmodel(SelectedModel);
	TrialPodium_Player2 thread PodiumSetupTrigger(Origin[1] + CalculatedOrigin,1);
	TrialPodium_Player2 thread PodiumSetupTrigger(Origin[1] + CalculatedOrigin,5);
	
	TrialPodium_Player3 = spawn( "script_model", Origin[2]);
	TrialPodium_Player3.angles = Angles[2];
	TrialPodium_Player3 setmodel(SelectedModel);
	TrialPodium_Player3 thread PodiumSetupTrigger(Origin[2] + CalculatedOrigin,2);
	TrialPodium_Player3 thread PodiumSetupTrigger(Origin[2] + CalculatedOrigin,6);
	
	TrialPodium_Player4 = spawn( "script_model", Origin[3]);
	TrialPodium_Player4.angles = Angles[3];
	TrialPodium_Player4 setmodel(SelectedModel);
	TrialPodium_Player4 thread PodiumSetupTrigger(Origin[3] + CalculatedOrigin,3);
	TrialPodium_Player4 thread PodiumSetupTrigger(Origin[3] + CalculatedOrigin,7);
	
	TrialMainModel = spawn( "script_model", ActivatiorOrigim);
	TrialMainModel.angles = ActivatorAngles;
	TrialMainModel setmodel(ActivatiorModel);
	
	if(level.script != "zm_prison" && level.script != "zm_tomb")
		TrialMainModel thread MainModelAnimation();
		
	TrialsMainTrigger = spawn("trigger_radius", ActivatiorOrigim, 1, 50, 50);
	TrialsMainTrigger SetCursorHint( "HINT_NOICON" );
	// All Zones For Challenges
	Zones = GetEntArray("player_volume", "script_noteworthy");
	// Zones check for Town
	if ( getDvar( "ui_zm_mapstartlocation" ) == "town" ){
		for(i = 0;i < Zones.size;i++){
			if(Zones[i].targetname == "zone_tow" || Zones[i].targetname == "zone_bar" || Zones[i].targetname == "zone_ban" || Zones[i].targetname == "zone_town_north" || Zones[i].targetname == "zone_town_west" || Zones[i].targetname == "zone_town_east" || Zones[i].targetname == "zone_town_barber" || Zones[i].targetname == "zone_town_south" ){
				if(!isdefined(ZonesForSurvival))
					ZonesForSurvival = [];
				ZonesForSurvival[ZonesForSurvival.size] = Zones[i];
			}
		}
	}
	TrialsCost = getDvarInt("TrialsCost");
	Challenges = array_randomize(Challenges);
	Num = 0;
	while(1){
		if(level.ReaperTrialsActive == 0)
			TrialsMainTrigger SetHintString("Hold ^3&&1^7 to Activate Trial [Cost: " + TrialsCost + "]");
		else
			TrialsMainTrigger SetHintString("Trial is already Running!");
		TrialsMainTrigger waittill("trigger", player);
		if(level.ReaperTrialsActive == 0){
        	if(player UseButtonPressed()){
        		if(player.score < TrialsCost){
               	 	player playsound("evt_perk_deny");
                	wait 1;
            	}
            	else if(player.score >= TrialsCost){
        			player minus_to_player_score(TrialsCost);
        			player playsound("zmb_cha_ching");
        			if(Num >= Challenges.size) {
    					Challenges = cycle_randomize(Challenges);
    					Num = 0;
    				}
    				if(isdefined(ZonesForSurvival))
        				level thread ChallengeHandler(ZonesForSurvival,Challenges[Num]);
        			else
        				level thread ChallengeHandler(Zones,Challenges[Num]);
        			foreach(player in level.players)
        				player playsound( "zmb_meteor_activate" );
        			Num++;
        			level.ReaperTrialsActive++;
				}
            }
		}
	}
}

cycle_randomize(indices) {
    li = indices.size - 1;
    last = indices[li];
    new_indices = array_randomize(indices);

    while (last == new_indices[0])
        new_indices = array_randomize(indices);

    return new_indices;
}

MainModelAnimation(){// Teddy Floating
	level endon("end_game");
	while(1){
		self moveto(self.origin + (0,0,20),randomfloatrange(0.5,4));
		self waittill("movedone");
		self moveto(self.origin + (0,0,-20),randomfloatrange(0.5,4));
		self waittill("movedone");
	}
}

ChallengeHandler(Zones,Challenge){
	if(Challenge == "K_Trial")
		ChallengeDescription = "Kill Zombies";
	else if(Challenge == "HK_Trial"){
		ChallengeDescription = "Kill Zombies With Headshots";
		ChallengePoints = 2;
	}
	else if(Challenge == "MK_Trial"){
		ChallengeDescription = "Kill Zombies with Melee Attacks";
		ChallengePoints = 2;
	}
	else if(Challenge == "KISZ_Trial"){
		Num = randomintrange(0, Zones.size);
		ChoosenZone = Zones[Num];
		ZoneName = get_zone_name(ChoosenZone.targetname);
		ChallengeDescription = "Kill Zombies at Location\n^8"+ZoneName;
		PositiveChallengeDescription = "Kill Zombies at Location\n^2"+ZoneName;
		Time = 120;
	}
	else if(Challenge == "SISZ_Trial"){
		Num = randomintrange(0, Zones.size);
		ChoosenZone = Zones[Num];
		ZoneName = get_zone_name(ChoosenZone.targetname);
		ChallengeDescription = "Stay at Location\n^8"+ZoneName;
		PositiveChallengeDescription = "Stay at Location\n^2"+ZoneName;
		Time = 120;
	}
	else if(Challenge == "GO_Trial")
		ChallengeDescription = "Kill Zombies with Grenades";
	else if(Challenge == "C_Trial")
		ChallengeDescription = "Kill Zombies while Crouched";
	else if(Challenge == "TD_Trial"){
		ChallengeDescription = "Take Damage";
		ChallengePoints = 1.5;
	}
	else if(Challenge == "NH_Trial"){
		ChallengeDescription = "Take No Damage";
		ChallengePoints = 1.5;
	}
	else if(Challenge == "BRS_Trial"){
		ChallengeDescription = "Spend Points";
		Time = 120;
	}
	else if(Challenge == "NPAP_Trial")
		ChallengeDescription = "Kill Zombies with a Non-Upgraded Weapon";
	else if(Challenge == "PAP_Trial")
		ChallengeDescription = "Kill Zombies with an Upgraded Weapon";
	else if(Challenge == "NAIM_Trial")
		ChallengeDescription = "Kill Zombies without Aiming";
	else if(Challenge == "CR_Trial")
		ChallengeDescription = "Kill Zombies in Close Range";
	else if(Challenge == "BR_Trial")
		ChallengeDescription = "Kill Zombies in Long Range";
	else if(Challenge == "PK_Trial")
		ChallengeDescription = "Kill Zombies while Prone";
	
	if(!isdefined(ChallengePoints))// Default
		ChallengePoints = 1;
	if(!isdefined(time))// Default
		time = 90;
	// Setup Challenge For Players
	players = get_players();
	for(i = 0;i < players.size;i++){
		if(Challenge == "SISZ_Trial" || Challenge == "TD_Trial" || Challenge == "NH_Trial" || Challenge == "BRS_Trial"){
			players[i] thread PlayerTrialHandlerTime(Challenge, ChallengePoints, ChoosenZone);
		}
		else{
			players[i] thread PlayerTrialHandlerKill(Challenge, ChallengePoints, ChoosenZone);
		}
		players[i] toggle_trial_challenge_hud();
		players[i] set_trial_challenge(ChallengeDescription);
		players[i] set_trial_timer(time);
		
		if(isdefined(ChoosenZone))
			players[i] thread set_trial_location(ChoosenZone, ChallengeDescription, PositiveChallengeDescription);
	}
	wait time + 1;
	for(i = 0;i < players.size;i++){
		players[i] notify("TrialOver");
		players[i] toggle_trial_challenge_hud();
	}
	level.ReaperTrialsActive = 0;
}

set_trial_location(zone, out_text, in_text) {
	self endon("TrialOver");
	self endon("disconnect");
	level endon("end_game");
	before = false;

	while (true) {
		in_zone = self istouching(zone);

		if(before != in_zone) {
			text = in_zone ? in_text : out_text;
			self set_trial_challenge(text);
			before = in_zone;
		}
		wait 1;
	}
}

// All Kill Based Challenges COme in here
PlayerTrialHandlerKill(trial, Points, SpecificZone){
	level endon("game_ended");
	self endon("TrialOver");
	while(1){
		self waittill( "zom_kill", zombie);
		if(trial == "K_Trial")
			self thread AddPlayerMagicPoints(Points);
		else if(trial == "HK_Trial"){
			if ( zombie.damagelocation == "head" || zombie.damagelocation == "helmet" || zombie.damagelocation == "neck" ) {
				self thread AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "MK_Trial"){
			if ( zombie.damagemod == "MOD_MELEE" || zombie.damagemod == "MOD_IMPACT" ) {
				self thread AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "KISZ_Trial"){
			if(self istouching(SpecificZone) && zombie istouching(SpecificZone)){
				self thread AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "GO_Trial"){
			if ( zombie.damagemod == "MOD_GRENADE" || zombie.damagemod == "MOD_GRENADE_SPLASH" || zombie.damagemod == "MOD_EXPLOSIVE" ){
				self thread AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "C_Trial"){
			if(self GetStance() == "crouch"){
				self thread AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "NPAP_Trial"){
			if(!self has_upgrade(self getcurrentweapon()) && zombie.damagemod == "MOD_RIFLE_BULLET" || !self has_upgrade(self getcurrentweapon()) && zombie.damagemod == "MOD_PISTOL_BULLET"){
				self thread AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "PAP_Trial"){
			if(self has_upgrade(self getcurrentweapon()) && zombie.damagemod == "MOD_RIFLE_BULLET" || self has_upgrade(self getcurrentweapon()) && zombie.damagemod == "MOD_PISTOL_BULLET"){
				self thread AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "NAIM_Trial"){
			if(!isads(self)){
				self thread AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "CR_Trial"){
			if(distancesquared(self.origin,zombie.origin) <= 20000){
				self thread AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "BR_Trial"){
			if(distancesquared(self.origin,zombie.origin) >= 180000){
				self thread AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "PK_Trial"){
			if(self GetStance() == "prone"){
				self thread AddPlayerMagicPoints(Points);
			}
		}
	}
}
// All Time Based Challenges Come in here
PlayerTrialHandlerTime(trial, Points, SpecificZone){
	level endon("game_ended");
	self endon("TrialOver");
	while(1){
		if(trial == "SISZ_Trial"){
			if(isdefined(SpecificZone) && self istouching(SpecificZone)){
				self thread AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "TD_Trial"){
			if((self.health / self.maxhealth) <= 0.8){
				self thread AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "NH_Trial"){
			if(self.health == self.maxhealth){
				self thread AddPlayerMagicPoints(Points);
			}
			else{
				wait 10;
			}
		}
		else if(trial == "BRS_Trial"){
			level waittill("spent_points", player, PointsSpent);
			if(Player == self){
				if(PointsSpent >= 100){
					self thread AddPlayerMagicPoints(Points);
				}
			}
		}
		wait 2.5;
	}
}

PodiumSetupTrigger(CalculatedOrigin,Index){
	level endon("end_game");
	if(level.script == "zm_nuked")
		trigger = Spawn( "trigger_radius", self.origin + (0, 0, 30), 0, 45, 45 );
	else
		trigger = Spawn( "trigger_radius", self.origin + (0, 0, 30), 0, 30, 30 );
	trigger SetCursorHint( "HINT_NOICON" );
	trigger thread ShowToSpecific(CalculatedOrigin,Index);
	while(1){
		players = GetPlayers();
		if(players[Index].ReaperTrialsCurrentMagic >= 25)
			reward_level = "^2Common";
		if(players[Index].ReaperTrialsCurrentMagic >= 50)
			reward_level = "^4Rare";
		if(players[Index].ReaperTrialsCurrentMagic >= 75)
			reward_level = "^6Epic";
		if(players[Index].ReaperTrialsCurrentMagic == 100)
			reward_level = "^3Legendary";
		if(players[Index].ReaperTrialsCurrentMagic >= 25)
			trigger SetHintString("Press ^3&&1^7 To Claim " + reward_level + "^7 Reward");
		else
			trigger SetHintString("Reward Level Too Low");
		trigger waittill( "trigger", player);
		if(player == players[Index]){
			if(!player UseButtonPressed()){
				wait .1;
				continue;
			}
			if(players[Index].ReaperTrialsCurrentMagic < 25){
				wait .1;
				continue;
			}
			if(players[Index].ReaperTrialsCurrentMagic >= 25)
				Reward = Random_Reward("Common");
			if(players[Index].ReaperTrialsCurrentMagic >= 50)
				Reward = Random_Reward("Rare");
			if(players[Index].ReaperTrialsCurrentMagic >= 75)
				Reward = Random_Reward("Epic");
			if(players[Index].ReaperTrialsCurrentMagic == 100)
				Reward = Random_Reward("Legendary");
			players[Index].ReaperTrialsCurrentMagic = 0;
      		players[Index] toggle_trial_reward_hud();
      		players[Index] set_trial_reward("none");
      		trigger SetHintString("Generating Reward!");
      		wait 1;
			RewardModel = Spawn( "script_model", CalculatedOrigin + (0,0,28));
			RewardModel setmodel(level.Rewards_List[Reward].Model);
			RewardModel thread RewardModelMain();
			trigger SetHintString( "Press ^3&&1^7 To Take "+level.Rewards_List[Reward].Hint);
			trigger thread TriggerRewardHandler(players[Index], level.Rewards_List[Reward].Name, level.Rewards_List[Reward].Powerup);
			trigger waittill_any_timeout(30, "Grabbed");
			trigger notify("Timeout");
			RewardModel notify("Done");
			RewardModel delete();
		}
	}
}

toggle_trial_challenge_hud() {
    if (!isdefined(self.trials_init))
        return;

    sq_size = self.trials_height;
    sq_wide = self.trials_width;
    sq_dot = self.trials_space;
    sq_star = self.trials_star;
    x = self.trials_x;
    y = self.trials_y;

    if (isdefined(self.trials_show_challenge) && self.trials_show_challenge) {

        // Wait for last trial progress animation before hide
        while (self.do_trial_progress)
            wait .1;

        self.trials_show_challenge = false;
        self.trials_bg.alpha = 0;
        self.trials_timer_bg.alpha = 0;
        self.trials_timer_bar.alpha = 0;
        self.trials_timer.alpha = 0;
        self.trials_challenge destroy(); // This will glitch if a new challenge starts too fast
		// self.trials_challenge.alpha = 0;
    } 
    else {
        self.trials_show_challenge = true;

        // Main background
        if (!isdefined(self.trials_bg)) {
            self.trials_bg = newclienthudelem(self);
            self.trials_bg.horzalign = "user_left";
            self.trials_bg.alignx = "left";
            self.trials_bg.vertalign = "user_center";
            self.trials_bg.aligny = "middle";
            self.trials_bg.x = x + sq_dot + sq_size;
            self.trials_bg.y = y;
            self.trials_bg.sort = 1;
            self.trials_bg.foreground = true;
            self.trials_bg.hidewheninmenu = true;
            self.trials_bg setshader("gradient", sq_wide, sq_size);
        }
        self.trials_bg.alpha = .6;

        // Timer background
        if (!isdefined(self.trials_timer_bg)) {
            self.trials_timer_bg = newclienthudelem(self);
            self.trials_timer_bg.horzalign = "user_left";
            self.trials_timer_bg.alignx = "left";
            self.trials_timer_bg.vertalign = "user_center";
            self.trials_timer_bg.aligny = "middle";
            self.trials_timer_bg.x = x + sq_dot;
            self.trials_timer_bg.y = y;
            self.trials_timer_bg.sort = 2;
            self.trials_timer_bg.foreground = true;
            self.trials_timer_bg.hidewheninmenu = true;
            self.trials_timer_bg setshader("black", sq_size, sq_size);
        }
        self.trials_timer_bg.alpha = .8;

        // Left timer bar
        if (!isdefined(self.trials_timer_bar)) {
            self.trials_timer_bar = newclienthudelem(self);
            self.trials_timer_bar.horzalign = "user_left";
            self.trials_timer_bar.alignx = "left";
            self.trials_timer_bar.vertalign = "user_center";
            self.trials_timer_bar.aligny = "middle";
            self.trials_timer_bar.x = x;
            self.trials_timer_bar.y = y;
            self.trials_timer_bar.color = self.trials_reward_color;
            self.trials_timer_bar.sort = 3;
            self.trials_timer_bar.foreground = true;
            self.trials_timer_bar.hidewheninmenu = true;
            self.trials_timer_bar setshader("white", sq_dot, sq_size);
        }
        self.trials_timer_bar.alpha = 1;

        // Timer
        if (!isdefined(self.trials_timer)) {
            self.trials_timer = newclienthudelem(self);
            self.trials_timer.horzalign = "user_left";
            self.trials_timer.alignx = "center";
            self.trials_timer.vertalign = "user_center";
            self.trials_timer.aligny = "middle";
            self.trials_timer.x = x + sq_dot + (sq_size / 2);
            self.trials_timer.y = y;
            self.trials_timer.color = self.trials_reward_color;
            self.trials_timer.font = "small";
            self.trials_timer.sort = 3;
            self.trials_timer.foreground = true;
            self.trials_timer.hidewheninmenu = true;
        }
        self.trials_timer.alpha = 1;

        // Challenge text
        if (!isdefined(self.trials_challenge)) {
            self.trials_challenge = newclienthudelem(self);
            self.trials_challenge.horzalign = "user_left";
            self.trials_challenge.alignx = "left";
            self.trials_challenge.vertalign = "user_center";
            self.trials_challenge.aligny = "middle";
            self.trials_challenge.x = x + (sq_dot * 3) + sq_size;
            self.trials_challenge.y = y;
            self.trials_challenge.real_y = self.trials_challenge.y;
            self.trials_challenge.sort = 3;
            self.trials_challenge.foreground = true;
            self.trials_challenge.hidewheninmenu = true;
        }
        self.trials_challenge.alpha = 1;
    }
}

toggle_trial_reward_hud() {
    if (!isdefined(self.trials_init))
        return;

    sq_size = self.trials_height;
    sq_wide = self.trials_width;
    sq_dot = self.trials_space;
    sq_star = self.trials_star;
    x = self.trials_x;
    y = self.trials_y;

    if (isdefined(self.trials_show_reward) && self.trials_show_reward) {
    
    	// Wait for last trial progress animation before hide
        while (self.do_trial_progress)
            wait .1;
     	
        self.trials_show_reward = false;
        self.trials_reward.alpha = 0;
        self.trials_common.alpha = 0;
        self.trials_rare.alpha = 0;
        self.trials_epic.alpha = 0;
        self.trials_legend.alpha = 0;
    }

    else {
        self.trials_show_reward = true;

        // Reward text
        if (!isdefined(self.trials_reward)) {
            self.trials_reward = newclienthudelem(self);
            self.trials_reward.horzalign = "user_left";
            self.trials_reward.alignx = "left";
            self.trials_reward.vertalign = "user_center";
            self.trials_reward.aligny = "top";
            self.trials_reward.x = x + (sq_dot * 3) + sq_size;
            self.trials_reward.y = y + (sq_size / 2) - 1;
            self.trials_reward.font = "small";
            self.trials_reward.color = (.75, .75, .75);
            self.trials_reward.sort = 3;
            self.trials_reward.foreground = true;
            self.trials_reward.hidewheninmenu = true;
            self.trials_reward.label = &"Reward Available: ";
        }
        self.trials_reward.alpha = 1;

        // Common tier dot
        if (!isdefined(self.trials_common)) {
            self.trials_common = newclienthudelem(self);
            self.trials_common.horzalign = "user_left";
            self.trials_common.alignx = "left";
            self.trials_common.vertalign = "user_center";
            self.trials_common.aligny = "top";
            self.trials_common.x = x - 1;
            self.trials_common.y = y + (sq_size / 2) + sq_dot;
            self.trials_common.color = (0, 0, 0);
            self.trials_common.sort = 3;
            self.trials_common.foreground = true;
            self.trials_common.hidewheninmenu = true;
            self.trials_common setshader("menu_mp_star_rating", sq_star, sq_star);
        }
        self.trials_common.alpha = .8;

        // Rare tier dot
        if (!isdefined(self.trials_rare)) {
            self.trials_rare = newclienthudelem(self);
            self.trials_rare.horzalign = "user_left";
            self.trials_rare.alignx = "left";
            self.trials_rare.vertalign = "user_center";
            self.trials_rare.aligny = "top";
            self.trials_rare.x = x + sq_dot + (sq_dot * 2) - 1;
            self.trials_rare.y = y + (sq_size / 2) + sq_dot;
            self.trials_rare.color = (0, 0, 0);
            self.trials_rare.sort = 3;
            self.trials_rare.foreground = true;
            self.trials_rare.hidewheninmenu = true;
            self.trials_rare setshader("menu_mp_star_rating", sq_star, sq_star);
        }
        self.trials_rare.alpha = .8;

        // Epic tier dot
        if (!isdefined(self.trials_epic)) {
            self.trials_epic = newclienthudelem(self);
            self.trials_epic.horzalign = "user_left";
            self.trials_epic.alignx = "left";
            self.trials_epic.vertalign = "user_center";
            self.trials_epic.aligny = "top";
            self.trials_epic.x = x + (sq_dot * 2) + (sq_dot * 4) - 1;
            self.trials_epic.y = y + (sq_size / 2) + sq_dot;
            self.trials_epic.color = (0, 0, 0);
            self.trials_epic.sort = 3;
            self.trials_epic.foreground = true;
            self.trials_epic.hidewheninmenu = true;
            self.trials_epic setshader("menu_mp_star_rating", sq_star, sq_star);
        }
        self.trials_epic.alpha = .8;

        // Legendary tier dot
        if (!isdefined(self.trials_legend)) {
            self.trials_legend = newclienthudelem(self);
            self.trials_legend.horzalign = "user_left";
            self.trials_legend.alignx = "left";
            self.trials_legend.vertalign = "user_center";
            self.trials_legend.aligny = "top";
            self.trials_legend.x = x + (sq_dot * 3) + (sq_dot * 6) - 1;
            self.trials_legend.y = y + (sq_size / 2) + sq_dot;
            self.trials_legend.color = (0, 0, 0);
            self.trials_legend.sort = 3;
            self.trials_legend.foreground = true;
            self.trials_legend.hidewheninmenu = true;
            self.trials_legend setshader("menu_mp_star_rating", sq_star, sq_star);
        }
        self.trials_legend.alpha = .8;
    }
}

draw_reward_alert(text) {
    if (!isdefined(self.trials_init))
        return;

    if (!isdefined(text))
        text = "REWARD UPGRADED";

    width = int(self.trials_height * 6.25);
    height = self.trials_height;

    // Reward upgrade background
    if (!isdefined(self.trials_upgrade_shadow)) {
        self.trials_upgrade_shadow = newclienthudelem(self);
        self.trials_upgrade_shadow.horzalign = "user_center";
        self.trials_upgrade_shadow.alignx = "center";
        self.trials_upgrade_shadow.vertalign = "user_center";
        self.trials_upgrade_shadow.aligny = "middle";
        self.trials_upgrade_shadow.x = 0;
        self.trials_upgrade_shadow.y = -160;
        self.trials_upgrade_shadow.color = (0, 0, 0);
        self.trials_upgrade_shadow.sort = 0;
        self.trials_upgrade_shadow.foreground = true;
        self.trials_upgrade_shadow.hidewheninmenu = true;
        self.trials_upgrade_shadow setshader("scorebar_zom_1", width, height);
    }

    // Reward upgrade background 2
    if (!isdefined(self.trials_upgrade_bg)) {
        self.trials_upgrade_bg = newclienthudelem(self);
        self.trials_upgrade_bg.horzalign = "user_center";
        self.trials_upgrade_bg.alignx = "center";
        self.trials_upgrade_bg.vertalign = "user_center";
        self.trials_upgrade_bg.aligny = "middle";
        self.trials_upgrade_bg.x = 0;
        self.trials_upgrade_bg.y = -160;
        self.trials_upgrade_bg.color = (1, 0, 0);
        self.trials_upgrade_bg.sort = 1;
        self.trials_upgrade_bg.foreground = true;
        self.trials_upgrade_bg.hidewheninmenu = true;
        self.trials_upgrade_bg setshader("scorebar_zom_1", width, height);
    }

    // Reward upgrade text
    if (!isdefined(self.trials_upgrade)) {
        self.trials_upgrade = newclienthudelem(self);
        self.trials_upgrade.horzalign = "user_center";
        self.trials_upgrade.alignx = "center";
        self.trials_upgrade.vertalign = "user_center";
        self.trials_upgrade.aligny = "middle";
        self.trials_upgrade.x = 0;
        self.trials_upgrade.y = -160;
        self.trials_upgrade.fontscale = 1.3;
        self.trials_upgrade.sort = 2;
        self.trials_upgrade.foreground = true;
        self.trials_upgrade.hidewheninmenu = true;
    }
    self.trials_upgrade settext(text);

    // Animation
    self playlocalsound("zmb_cha_ching");
    self.trials_upgrade_shadow.alpha = 0;
    self.trials_upgrade_bg.alpha = 0;
    self.trials_upgrade.alpha = 0;
    self.trials_upgrade_shadow fadeovertime(.5);
    self.trials_upgrade_shadow.alpha = 1;
    self.trials_upgrade_bg fadeovertime(.5);
    self.trials_upgrade_bg.alpha = 1;
    self.trials_upgrade fadeovertime(.5);
    self.trials_upgrade.alpha = 1;
    wait 5;
    self.trials_upgrade_shadow fadeovertime(.25);
    self.trials_upgrade_shadow.alpha = 0;
    self.trials_upgrade_bg fadeovertime(.25);
    self.trials_upgrade_bg.alpha = 0;
    self.trials_upgrade fadeovertime(.25);
    self.trials_upgrade.alpha = 0;
    wait .25;
}

draw_trial_progress() {
    if (!isdefined(self.trials_init))
        return;

    // Drop incoming animation call if the previous one is not completed
    if (self.do_trial_progress)
        return;

    // Drop incoming animation call when highest trial level (legendary) is reached
    if (self.trials_reward_code == "legendary")
        return;

    self.do_trial_progress = true;
    sq_size = self.trials_height;
    sq_wide = self.trials_width + sq_size;
    sq_dot = self.trials_space;
    sq_star = self.trials_star;
    x = self.trials_x;
    y = self.trials_y;

    // Top gradient line
    if (!isdefined(self.trials_top_bar)) {
        self.trials_top_bar = newclienthudelem(self);
        self.trials_top_bar.horzalign = "user_left";
        self.trials_top_bar.vertalign = "user_center";
        self.trials_top_bar.aligny = "top";
        self.trials_top_bar.y = y - int(sq_size / 2);
        self.trials_top_bar.color = self.trials_reward_color;
        self.trials_top_bar.sort = 3;
        self.trials_top_bar.foreground = true;
        self.trials_top_bar.hidewheninmenu = true;
    }

    // Bottom gradient line
    if (!isdefined(self.trials_bottom_bar)) {
        self.trials_bottom_bar = newclienthudelem(self);
        self.trials_bottom_bar.horzalign = "user_left";
        self.trials_bottom_bar.vertalign = "user_center";
        self.trials_bottom_bar.aligny = "bottom";
        self.trials_bottom_bar.y = y + int(sq_size / 2);
        self.trials_bottom_bar.color = self.trials_reward_color;
        self.trials_bottom_bar.sort = 3;
        self.trials_bottom_bar.foreground = true;
        self.trials_bottom_bar.hidewheninmenu = true;
    }
    
    // Animation
    self playlocalsound("cac_cmn_beep");
    self.trials_top_bar setshader("gradient_fadein", 0, 1);
    self.trials_bottom_bar setshader("gradient_fadein", 0, 1);
    self.trials_top_bar.alignx = "left";
    self.trials_top_bar.x = x + sq_dot;
    self.trials_bottom_bar.alignx = "left";
    self.trials_bottom_bar.x = x + sq_dot;
    self.trials_top_bar.alpha = 1;
    self.trials_bottom_bar.alpha = 1;
    self.trials_top_bar scaleovertime(.25, sq_wide, 1);
    self.trials_bottom_bar scaleovertime(.25, sq_wide, 1);
    wait .5;
    self.trials_top_bar.alignx = "right";
    self.trials_bottom_bar.alignx = "right";
    self.trials_top_bar.x = x + sq_dot + sq_wide;
    self.trials_bottom_bar.x = x + sq_dot + sq_wide;
    self.trials_top_bar scaleovertime(.25, 1, 1);
    self.trials_bottom_bar scaleovertime(.25, 1, 1);
    self.trials_top_bar fadeovertime(.25);
    self.trials_bottom_bar fadeovertime(.25);
    self.trials_top_bar.alpha = 0;
    self.trials_bottom_bar.alpha = 0;
    wait .25;

    self.do_trial_progress = false;
}

set_trial_reward(tier) {
    if (!isdefined(self.trials_init))
        return;

    if (isdefined(self.trials_reward_code) && self.trials_reward_code == tier)
        return;

    switch(tier) {
        case "none":
            text = "^1None";
            color = array((.8, 0, 0), (0, 0, 0), (0, 0, 0), (0, 0, 0));
            alpha = array(0, 0, 0, 0);
            break;

        case "common":
            text = "^2Common";
            color = array((0, 1, 0), (0, 0, 0), (0, 0, 0), (0, 0, 0));
            alpha = array(1, .8, .8, .8);
            break;

        case "rare":
            text = "^4Rare";
            color = array((0, .5, 1), (0, .5, 1), (0, 0, 0), (0, 0, 0));
            alpha = array(1, 1, .8, .8);
            break;

        case "epic":
            text = "^6Epic";
            color = array((0.345, 0, 0.576), (0.345, 0, 0.576), (0.345, 0, 0.576), (0, 0, 0));
            alpha = array(1, 1, 1, .8);
            break;

        case "legendary":
            text = "^3Legendary";
            color = array((1, 0.478, 0), (1, 0.478, 0), (1, 0.478, 0), (1, 0.478, 0));
            alpha = array(1, 1, 1, 1);
            break;
    
        default:
            return;
    }
	 previous = self.trials_reward_code;
    self.trials_reward_color = color[0];
    self.trials_reward_code = tier;
    self.trials_reward_color_code = getsubstr(text, 0, 2);
    self.trials_reward_level = text;
    self.trials_reward settext(text);
    self.trials_reward.alpha = alpha[0];
    self.trials_timer.color = color[0];
    self.trials_timer_bar.color = color[0];
    self.trials_top_bar.color = color[0];
    self.trials_bottom_bar.color = color[0];
    self.trials_common.color = color[0];
    self.trials_common.alpha = alpha[0];
    self.trials_rare.color = color[1];
    self.trials_rare.alpha = alpha[1];
    self.trials_epic.color = color[2];
    self.trials_epic.alpha = alpha[2];
    self.trials_legend.color = color[3];
    self.trials_legend.alpha = alpha[3];
    
    // Trigger trial challenge text overwrite or reset
    if (tier == "legendary" || previous == "legendary")
        set_trial_challenge(self.trials_challenge_text);
}

set_trial_challenge(text) {
    if (!isdefined(self.trials_init) || !isdefined(text))
        return;

    self.trials_challenge_text = text;

    // Overwrite trial challenge text if highest trial level (legendary) is reached
    if (self.trials_reward_code == "legendary")
        text = self.trials_reward_color_code + "CLAIM REWARD";

    line_shift = issubstr(text, "\n") ? 6 : 0;
    self.trials_challenge.y = self.trials_challenge.real_y - line_shift;
    self.trials_challenge settext(text);
}

set_trial_timer(time) {
    if (!isdefined(self.trials_init) || !isdefined(time))
        return;

    self.trials_timer settimer(time);
}

AddPlayerMagicPoints(num){
	self.ReaperTrialsCurrentMagic += num;
	self draw_trial_progress();
	if(self.ReaperTrialsCurrentMagic >= 100)
		self.ReaperTrialsCurrentMagic = 100;
	if(self.ReaperTrialsCurrentMagic >= 25){
		if(self.ReaperTrialsCurrentMagic >= 25 && self.ReaperTrialsCurrentMagic < 50){
			if(self.trials_reward_code != "common"){
				self toggle_trial_reward_hud();
				self set_trial_reward("common");
				self thread draw_reward_alert("REWARD AVAILABLE");
			}
		}
		if(self.ReaperTrialsCurrentMagic >= 50 && self.ReaperTrialsCurrentMagic < 75){
			if(self.trials_reward_code != "rare"){
				self set_trial_reward("rare");
				self thread draw_reward_alert();
			}
		}
		if(self.ReaperTrialsCurrentMagic >= 75 && self.ReaperTrialsCurrentMagic < 100){
			if(self.trials_reward_code != "epic"){
				self set_trial_reward("epic");
				self thread draw_reward_alert();
			}
		}
		if(self.ReaperTrialsCurrentMagic == 100){
			if(self.trials_reward_code != "legendary"){
				self set_trial_reward("legendary");
				self thread draw_reward_alert();
			}
		}
	}
}

ShowToSpecific(FXOrigin,Index){
	level endon("game_ended");
	while(1){
		self SetInvisibleToAll(); 
		self SetVisibleToPlayer( GetPlayers()[Index] );
		if(isdefined(GetPlayers()[Index])){
			if(isdefined(GetPlayers()[Index].ReaperTrialsCurrentMagic) && GetPlayers()[Index].ReaperTrialsCurrentMagic >= 25){
				if(level.script == "zm_transit")
					playfx( level._effect[ "character_fire_death_sm" ], FXOrigin);
				else if(level.script == "zm_prison")
					playfx(level._effect[ "fx_alcatraz_elec_chair" ],FXOrigin - (17,0,15),anglesToForward(0,0,0), anglesToUp(0,0,0));// Too Lazy
				else if(level.script == "zm_buried")
					playfx( level._effect[ "character_fire_death_sm" ], FXOrigin);
				else if(level.script == "zm_highrise")
					playfx( level._effect[ "character_fire_death_sm" ], FXOrigin);
			}
		}
		wait 5;
	}
}

get_zone_name(key) {

    // Caching and array lookup is way more efficient
    if (isdefined(level.zone_names))
        return level.zone_names[key];

    level.zone_names = [];

    switch(level.script) {

        case "zm_transit":
            level.zone_names["zone_pri"] = "Bus Depot";
            level.zone_names["zone_pri2"] = "Bus Depot Hallway";
            level.zone_names["zone_station_ext"] = "Outside Bus Depot";
            level.zone_names["zone_trans_2b"] = "Road After Bus Depot";
            level.zone_names["zone_trans_2"] = "Tunnel Entrance";
            level.zone_names["zone_amb_tunnel"] = "Tunnel";
            level.zone_names["zone_trans_3"] = "Tunnel Exit";
            level.zone_names["zone_roadside_west"] = "Outside Diner";
            level.zone_names["zone_gas"] = "Gas Station";
            level.zone_names["zone_roadside_east"] = "Outside Garage";
            level.zone_names["zone_trans_diner"] = "Road Outside Diner";
            level.zone_names["zone_trans_diner2"] = "Road Outside Garage";
            level.zone_names["zone_gar"] = "Garage";
            level.zone_names["zone_din"] = "Diner";
            level.zone_names["zone_diner_roof"] = "Diner Roof";
            level.zone_names["zone_trans_4"] = "Road After Diner";
            level.zone_names["zone_amb_forest"] = "Forest";
            level.zone_names["zone_trans_10"] = "Outside Church";
            level.zone_names["zone_town_church"] = "Upper South Town";
            level.zone_names["zone_trans_5"] = "Road Before Farm";
            level.zone_names["zone_far"] = "Outside Farm";
            level.zone_names["zone_far_ext"] = "Farm";
            level.zone_names["zone_brn"] = "Barn";
            level.zone_names["zone_farm_house"] = "Farmhouse";
            level.zone_names["zone_trans_6"] = "Road After Farm";
            level.zone_names["zone_amb_cornfield"] = "Cornfield";
            level.zone_names["zone_cornfield_prototype"] = "Nacht der Untoten";
            level.zone_names["zone_trans_7"] = "Upper Road Before Power";
            level.zone_names["zone_trans_pow_ext1"] = "Road Before Power";
            level.zone_names["zone_pow"] = "Outside Power Station";
            level.zone_names["zone_prr"] = "Power Station";
            level.zone_names["zone_pcr"] = "Power Control Room";
            level.zone_names["zone_pow_warehouse"] = "Warehouse";
            level.zone_names["zone_trans_8"] = "Road After Power";
            level.zone_names["zone_amb_power2town"] = "Cabin";
            level.zone_names["zone_trans_9"] = "Road Before Town";
            level.zone_names["zone_town_north"] = "North Town";
            level.zone_names["zone_tow"] = "Center Town";
            level.zone_names["zone_town_east"] = "East Town";
            level.zone_names["zone_town_west"] = "West Town";
            level.zone_names["zone_town_west2"] = "West Town 2";
            level.zone_names["zone_town_south"] = "South Town";
            level.zone_names["zone_bar"] = "Bar";
            level.zone_names["zone_town_barber"] = "Above Barbershop";
            level.zone_names["zone_ban"] = "Bank";
            level.zone_names["zone_ban_vault"] = "Bank Vault";
            level.zone_names["zone_tbu"] = "Laboratory";
            level.zone_names["zone_trans_11"] = "Road After Town";
            level.zone_names["zone_amb_bridge"] = "Bridge";
            level.zone_names["zone_trans_1"] = "Road Before Bus Depot";
            break;

        case "zm_nuked":
            level.zone_names["culdesac_yellow_zone"] = "Yellow House Cul-de-sac";
            level.zone_names["culdesac_green_zone"] = "Green House Cul-de-sac";
            level.zone_names["truck_zone"] = "Truck";
            level.zone_names["openhouse1_f1_zone"] = "Green House Downstairs";
            level.zone_names["openhouse1_f2_zone"] = "Green House Upstairs";
            level.zone_names["openhouse1_backyard_zone"] = "Green House Backyard";
            level.zone_names["openhouse2_f1_zone"] = "Yellow House Downstairs";
            level.zone_names["openhouse2_f2_zone"] = "Yellow House Upstairs";
            level.zone_names["openhouse2_backyard_zone"] = "Yellow House Backyard";
            level.zone_names["ammo_door_zone"] = "Yellow House Backyard Door";
            break;

        case "zm_highrise":
            level.zone_names["zone_green_start"] = "Green Highrise Level 3b";
            level.zone_names["zone_green_escape_pod"] = "Escape Pod";
            level.zone_names["zone_green_escape_pod_ground"] = "Escape Pod Shaft";
            level.zone_names["zone_green_level1"] = "Green Highrise Level 3a";
            level.zone_names["zone_green_level2a"] = "Green Highrise Level 2a";
            level.zone_names["zone_green_level2b"] = "Green Highrise Level 2b";
            level.zone_names["zone_green_level3a"] = "Green Highrise Restaurant";
            level.zone_names["zone_green_level3b"] = "Green Highrise Level 1a";
            level.zone_names["zone_green_level3c"] = "Green Highrise Level 1b";
            level.zone_names["zone_green_level3d"] = "Green Highrise Behind Restaurant";
            level.zone_names["zone_orange_level1"] = "Upper Orange Highrise Level 2";
            level.zone_names["zone_orange_level2"] = "Upper Orange Highrise Level 1";
            level.zone_names["zone_orange_elevator_shaft_top"] = "Elevator Shaft Level 3";
            level.zone_names["zone_orange_elevator_shaft_middle_1"] = "Elevator Shaft Level 2";
            level.zone_names["zone_orange_elevator_shaft_middle_2"] = "Elevator Shaft Level 1";
            level.zone_names["zone_orange_elevator_shaft_bottom"] = "Elevator Shaft Bottom";
            level.zone_names["zone_orange_level3a"] = "Lower Orange Highrise Level 1a";
            level.zone_names["zone_orange_level3b"] = "Lower Orange Highrise Level 1b";
            level.zone_names["zone_blue_level5"] = "Lower Blue Highrise Level 1";
            level.zone_names["zone_blue_level4a"] = "Lower Blue Highrise Level 2a";
            level.zone_names["zone_blue_level4b"] = "Lower Blue Highrise Level 2b";
            level.zone_names["zone_blue_level4c"] = "Lower Blue Highrise Level 2c";
            level.zone_names["zone_blue_level2a"] = "Upper Blue Highrise Level 1a";
            level.zone_names["zone_blue_level2b"] = "Upper Blue Highrise Level 1b";
            level.zone_names["zone_blue_level2c"] = "Upper Blue Highrise Level 1c";
            level.zone_names["zone_blue_level2d"] = "Upper Blue Highrise Level 1d";
            level.zone_names["zone_blue_level1a"] = "Upper Blue Highrise Level 2a";
            level.zone_names["zone_blue_level1b"] = "Upper Blue Highrise Level 2b";
            level.zone_names["zone_blue_level1c"] = "Upper Blue Highrise Level 2c";
            break;

        case "zm_prison":
            level.zone_names["zone_start"] = "D-Block";
            level.zone_names["zone_library"] = "Library";
            level.zone_names["zone_cellblock_west"] = "Cellblock 2nd Floor";
            level.zone_names["zone_cellblock_west_gondola"] = "Cellblock 3rd Floor";
            level.zone_names["zone_cellblock_west_gondola_dock"] = "Cellblock Gondola";
            level.zone_names["zone_cellblock_west_barber"] = "Michigan Avenue";
            level.zone_names["zone_cellblock_east"] = "Times Square";
            level.zone_names["zone_cafeteria"] = "Cafeteria";
            level.zone_names["zone_cafeteria_end"] = "Cafeteria End";
            level.zone_names["zone_infirmary"] = "Infirmary 1";
            level.zone_names["zone_infirmary_roof"] = "Infirmary 2";
            level.zone_names["zone_roof_infirmary"] = "Roof 1";
            level.zone_names["zone_roof"] = "Roof 2";
            level.zone_names["zone_cellblock_west_warden"] = "Sally Port";
            level.zone_names["zone_warden_office"] = "Warden's Office";
            level.zone_names["cellblock_shower"] = "Showers";
            level.zone_names["zone_citadel_shower"] = "Citadel To Showers";
            level.zone_names["zone_citadel"] = "Citadel";
            level.zone_names["zone_citadel_warden"] = "Citadel To Warden's Office";
            level.zone_names["zone_citadel_stairs"] = "Citadel Tunnels";
            level.zone_names["zone_citadel_basement"] = "Citadel Basement";
            level.zone_names["zone_citadel_basement_building"] = "China Alley";
            level.zone_names["zone_studio"] = "Building 64";
            level.zone_names["zone_dock"] = "Docks";
            level.zone_names["zone_dock_puzzle"] = "Docks Gates";
            level.zone_names["zone_dock_gondola"] = "Upper Docks";
            level.zone_names["zone_golden_gate_bridge"] = "Golden Gate Bridge";
            level.zone_names["zone_gondola_ride"] = "Gondola";
            break;

        case "zm_buried":
            level.zone_names["zone_start"] = "Processing";
            level.zone_names["zone_start_lower"] = "Lower Processing";
            level.zone_names["zone_tunnels_center"] = "Center Tunnels";
            level.zone_names["zone_tunnels_north"] = "Courthouse Tunnels 2";
            level.zone_names["zone_tunnels_north2"] = "Courthouse Tunnels 1";
            level.zone_names["zone_tunnels_south"] = "Saloon Tunnels 3";
            level.zone_names["zone_tunnels_south2"] = "Saloon Tunnels 2";
            level.zone_names["zone_tunnels_south3"] = "Saloon Tunnels 1";
            level.zone_names["zone_street_lightwest"] = "Outside General Store & Bank";
            level.zone_names["zone_street_lightwest_alley"] = "Outside General Store & Bank Alley";
            level.zone_names["zone_morgue_upstairs"] = "Morgue";
            level.zone_names["zone_underground_jail"] = "Jail Downstairs";
            level.zone_names["zone_underground_jail2"] = "Jail Upstairs";
            level.zone_names["zone_general_store"] = "General Store";
            level.zone_names["zone_stables"] = "Stables";
            level.zone_names["zone_street_darkwest"] = "Outside Gunsmith";
            level.zone_names["zone_street_darkwest_nook"] = "Outside Gunsmith Nook";
            level.zone_names["zone_gun_store"] = "Gunsmith";
            level.zone_names["zone_bank"] = "Bank";
            level.zone_names["zone_tunnel_gun2stables"] = "Stables To Gunsmith Tunnel 2";
            level.zone_names["zone_tunnel_gun2stables2"] = "Stables To Gunsmith Tunnel";
            level.zone_names["zone_street_darkeast"] = "Outside Saloon & Toy Store";
            level.zone_names["zone_street_darkeast_nook"] = "Outside Saloon & Toy Store Nook";
            level.zone_names["zone_underground_bar"] = "Saloon";
            level.zone_names["zone_tunnel_gun2saloon"] = "Saloon To Gunsmith Tunnel";
            level.zone_names["zone_toy_store"] = "Toy Store Downstairs";
            level.zone_names["zone_toy_store_floor2"] = "Toy Store Upstairs";
            level.zone_names["zone_toy_store_tunnel"] = "Toy Store Tunnel";
            level.zone_names["zone_candy_store"] = "Candy Store Downstairs";
            level.zone_names["zone_candy_store_floor2"] = "Candy Store Upstairs";
            level.zone_names["zone_street_lighteast"] = "Outside Courthouse & Candy Store";
            level.zone_names["zone_underground_courthouse"] = "Courthouse Downstairs";
            level.zone_names["zone_underground_courthouse2"] = "Courthouse Upstairs";
            level.zone_names["zone_street_fountain"] = "Fountain";
            level.zone_names["zone_church_graveyard"] = "Graveyard";
            level.zone_names["zone_church_main"] = "Church Downstairs";
            level.zone_names["zone_church_upstairs"] = "Church Upstairs";
            level.zone_names["zone_mansion_lawn"] = "Mansion Lawn";
            level.zone_names["zone_mansion"] = "Mansion";
            level.zone_names["zone_mansion_backyard"] = "Mansion Backyard";
            level.zone_names["zone_maze"] = "Maze";
            level.zone_names["zone_maze_staircase"] = "Maze Staircase";
            break;

        case "zm_tomb":
            level.zone_names["zone_start"] = "Lower Laboratory";
            level.zone_names["zone_start_a"] = "Upper Laboratory";
            level.zone_names["zone_start_b"] = "Generator 1";
            level.zone_names["zone_bunker_1a"] = "Generator 3 Bunker 1";
            level.zone_names["zone_fire_stairs"] = "Fire Tunnel";
            level.zone_names["zone_fire_stairs_1"] = "zone_fire_stairs_1";
            level.zone_names["zone_bunker_1"] = "Generator 3 Bunker 2";
            level.zone_names["zone_bunker_3a"] = "Generator 3";
            level.zone_names["zone_bunker_3b"] = "Generator 3 Bunker 3";
            level.zone_names["zone_bunker_2a"] = "Generator 2 Bunker 1";
            level.zone_names["zone_bunker_2"] = "Generator 2 Bunker 2";
            level.zone_names["zone_bunker_4a"] = "Generator 2";
            level.zone_names["zone_bunker_4b"] = "Generator 2 Bunker 3";
            level.zone_names["zone_bunker_4c"] = "Tank Station";
            level.zone_names["zone_bunker_4d"] = "Above Tank Station";
            level.zone_names["zone_bunker_tank_c"] = "Generator 2 Tank Route 1";
            level.zone_names["zone_bunker_tank_c1"] = "Generator 2 Tank Route 2";
            level.zone_names["zone_bunker_4e"] = "Generator 2 Tank Route 3";
            level.zone_names["zone_bunker_tank_d"] = "Generator 2 Tank Route 4";
            level.zone_names["zone_bunker_tank_d1"] = "Generator 2 Tank Route 5";
            level.zone_names["zone_bunker_4f"] = "zone_bunker_4f";
            level.zone_names["zone_bunker_5a"] = "Workshop Downstairs";
            level.zone_names["zone_bunker_5b"] = "Workshop Upstairs";
            level.zone_names["zone_nml_2a"] = "No Man's Land Walkway";
            level.zone_names["zone_nml_2"] = "No Man's Land Entrance";
            level.zone_names["zone_bunker_tank_e"] = "Generator 5 Tank Route 1";
            level.zone_names["zone_bunker_tank_e1"] = "Generator 5 Tank Route 2";
            level.zone_names["zone_bunker_tank_e2"] = "zone_bunker_tank_e2";
            level.zone_names["zone_bunker_tank_f"] = "Generator 5 Tank Route 3";
            level.zone_names["zone_nml_1"] = "Generator 5 Tank Route 4";
            level.zone_names["zone_nml_4"] = "Generator 5 Tank Route 5";
            level.zone_names["zone_nml_0"] = "Generator 5 Left Footstep";
            level.zone_names["zone_nml_5"] = "Generator 5 Right Footstep Walkway";
            level.zone_names["zone_nml_farm"] = "Generator 5";
            level.zone_names["zone_nml_farm_1"] = "zone_nml_farm_1";
            level.zone_names["zone_nml_celllar"] = "Generator 5 Cellar";
            level.zone_names["zone_bolt_stairs"] = "Lightning Tunnel";
            level.zone_names["zone_bolt_stairs_1"] = "zone_bolt_stairs_1";
            level.zone_names["zone_nml_3"] = "No Man's Land 1st Right Footstep";
            level.zone_names["zone_nml_2b"] = "No Man's Land Stairs";
            level.zone_names["zone_nml_6"] = "No Man's Land Left Footstep";
            level.zone_names["zone_nml_8"] = "No Man's Land 2nd Right Footstep";
            level.zone_names["zone_nml_10a"] = "Generator 4 Tank Route 1";
            level.zone_names["zone_nml_10"] = "Generator 4 Tank Route 2";
            level.zone_names["zone_nml_7"] = "Generator 4 Tank Route 3";
            level.zone_names["zone_nml_7a"] = "zone_nml_7a";
            level.zone_names["zone_bunker_tank_a"] = "Generator 4 Tank Route 4";
            level.zone_names["zone_bunker_tank_a1"] = "Generator 4 Tank Route 5";
            level.zone_names["zone_bunker_tank_a2"] = "zone_bunker_tank_a2";
            level.zone_names["zone_bunker_tank_b"] = "Generator 4 Tank Route 6";
            level.zone_names["zone_nml_9"] = "Generator 4 Left Footstep";
            level.zone_names["zone_nml_9a"] = "zone_nml_9a";
            level.zone_names["zone_air_stairs"] = "Wind Tunnel";
            level.zone_names["zone_air_stairs_1"] = "zone_air_stairs_1";
            level.zone_names["zone_nml_11"] = "Generator 4";
            level.zone_names["zone_nml_11a"] = "zone_nml_11a";
            level.zone_names["zone_nml_12"] = "Generator 4 Right Footstep";
            level.zone_names["zone_nml_12a"] = "zone_nml_12a";
            level.zone_names["zone_nml_16"] = "Excavation Site Front Path";
            level.zone_names["zone_nml_16a"] = "zone_nml_16a";
            level.zone_names["zone_nml_17"] = "Excavation Site Back Path";
            level.zone_names["zone_nml_17a"] = "zone_nml_17a";
            level.zone_names["zone_nml_18"] = "Excavation Site Level 3";
            level.zone_names["zone_nml_19"] = "Excavation Site Level 2";
            level.zone_names["ug_bottom_zone"] = "Excavation Site Level 1";
            level.zone_names["zone_nml_13"] = "Generator 5 To Generator 6 Path";
            level.zone_names["zone_nml_14"] = "Generator 4 To Generator 6 Path";
            level.zone_names["zone_nml_15"] = "Generator 6 Entrance";
            level.zone_names["zone_nml_15a"] = "zone_nml_15a";
            level.zone_names["zone_village_0"] = "Generator 6 Left Footstep";
            level.zone_names["zone_village_5"] = "Generator 6 Tank Route 1";
            level.zone_names["zone_village_5a"] = "Generator 6 Tank Route 2";
            level.zone_names["zone_village_5b"] = "Generator 6 Tank Route 3";
            level.zone_names["zone_village_1"] = "Generator 6 Tank Route 4";
            level.zone_names["zone_village_1a"] = "zone_village_1a";
            level.zone_names["zone_village_4b"] = "Generator 6 Tank Route 5";
            level.zone_names["zone_village_4a"] = "Generator 6 Tank Route 6";
            level.zone_names["zone_village_4"] = "Generator 6 Tank Route 7";
            level.zone_names["zone_village_2"] = "Church";
            level.zone_names["zone_village_3"] = "Generator 6 Right Footstep";
            level.zone_names["zone_village_3a"] = "Generator 6";
            level.zone_names["zone_village_3b"] = "zone_village_3b";
            level.zone_names["zone_ice_stairs"] = "Ice Tunnel";
            level.zone_names["zone_ice_stairs_1"] = "zone_ice_stairs_1";
            level.zone_names["zone_bunker_6"] = "Above Generator 3 Bunker";
            level.zone_names["zone_nml_20"] = "Above No Man's Land";
            level.zone_names["zone_village_6"] = "Behind Church";
            level.zone_names["zone_village_6a"] = "zone_village_6a";
            level.zone_names["zone_chamber_0"] = "The Crazy Place Lightning Chamber";
            level.zone_names["zone_chamber_1"] = "The Crazy Place Lightning & Ice";
            level.zone_names["zone_chamber_2"] = "The Crazy Place Ice Chamber";
            level.zone_names["zone_chamber_3"] = "The Crazy Place Fire & Lightning";
            level.zone_names["zone_chamber_4"] = "The Crazy Place Center";
            level.zone_names["zone_chamber_5"] = "The Crazy Place Ice & Wind";
            level.zone_names["zone_chamber_6"] = "The Crazy Place Fire Chamber";
            level.zone_names["zone_chamber_7"] = "The Crazy Place Wind & Fire";
            level.zone_names["zone_chamber_8"] = "The Crazy Place Wind Chamber";
            level.zone_names["zone_robot_head"] = "Robot's Head";
            break;
    }
    return level.zone_names[key];
}
