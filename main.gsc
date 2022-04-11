#include codescripts/struct;
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_melee_weapon;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_globallogic;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zombies/_zm_equipment;
#include maps/mp/zombies/_zm_pers_upgrades_functions;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_score;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_weap_cymbal_monkey;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/gametypes_zm/_spawning;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_zonemgr;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_weap_claymore;
#include maps/mp/zombies/_zm_ai_avogadro;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/zombies/_zm_power;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_devgui;
#include maps/mp/zombies/_zm_weap_jetgun;
#include maps/mp/zombies/_zm_ai_dogs;
#include maps/mp/zombies/_zm_ai_screecher;
#include maps/mp/zombies/_zm_ai_basic;
#include maps/mp/zombies/_zm_blockers;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zombies/_zm_powerups;

// Trials System by ZECxR3ap3r

init()
{
	// Precaching
	precacheshader("gradient");
	precacheshader("white");
	precacheshader("menu_mp_star_rating");
	precacheshader("gradient_fadein");
	precacheshader("scorebar_zom_1");
	// Settings
	setDvar("TrialsHigherThePrice", 1);// Cost of the Trials will be add every 10 rounds + Default TrialsCost
	setDvar("TrialsCost", 500);// How Much the trials will cost
	setDvar("TrialsTime", 90);// How Long a Trial Stays Active
	// Setup
	if(getdvar( "mapname" ) == "zm_transit"){
		// Player Podiums
    	PodiumModel = "t6_wpn_zmb_jet_gun_world";
    	PodiumOrigin = array((878.738, -785.876, 150.125), (962.979, -785.876, 150.125), (1139.96, -1024.87, 150.125), (1139.47, -1107.2, 150.125));
    	PodiumAngles = array((90,80,0), (90,82,0), (90,0,0), (90,0,0));
    	// Trials Main Activate
    	TrialsMainModel = "p6_anim_zm_bus_driver";
    	TrialsMainOrigin = (887.39, -1043.72, 150.125);
    	TrialsMainAngles = (90, 60, 0);
    }
	level.ReaperTrialsActive = 0;
	level thread TrialsSystem(PodiumModel, PodiumOrigin, PodiumAngles, TrialsMainModel, TrialsMainOrigin, TrialsMainAngles);
	level thread onPlayerConnect();
}

init_trial_hud() {

    // HUD settings such as sizes, position and fallbacks
    self.trials_height = 28;
    self.trials_width = int(self.trials_height * 5);
    self.trials_space = int(self.trials_height * .115);
    self.trials_star = int(self.trials_space * 2.35);
    self.trials_x = 5;
    self.trials_y = 0 - self.trials_height;
    self.trials_reward_color = (.8, 0, 0);
    self.trials_reward_code = "^1";
    self.trials_reward_level = "^1None";
    self.trials_init = true;
}

onPlayerConnect()
{
    for(;;){
        level waittill("connected", player); 
        player.ReaperTrialsCurrentMagic = 0;
        wait 20;
        player.score += 100000;
        player giveweapon("galil_zm");
        flag_wait("initial_blackscreen_passed");
    	player init_trial_hud();
    }
}

TrialsSystem(SelectedModel, Origin, Angles, ActivatiorModel, ActivatiorOrigim, ActivatorAngles)
{
	Challenges = [];
	Challenges[0] = "K_Trial";//Regular Kills
	Challenges[1] = "HK_Trial";//Headshot Kills
	Challenges[2] = "MK_Trial";//Melee Kills
	Challenges[4] = "KISZ_Trial";//Kill In Random Zone
	Challenges[5] = "SISZ_Trial";//Stay In Random Zone
	Challenges[6] = "GO_Trial";//Kill Zombies With Grenades
	Challenges[7] = "C_Trial";//Kill Zombies While Crouched
	
	TrialPodium_Player1 = spawn( "script_model", Origin[0]);
	TrialPodium_Player1.angles = Angles[0];
	TrialPodium_Player1 setmodel(SelectedModel);
	TrialPodium_Player1 thread PodiumSetupTrigger(0);
	
	TrialPodium_Player2 = spawn( "script_model", Origin[1]);
	TrialPodium_Player2.angles = Angles[1];
	TrialPodium_Player2 setmodel(SelectedModel);
	TrialPodium_Player2 thread PodiumSetupTrigger(1);
	
	TrialPodium_Player3 = spawn( "script_model", Origin[2]);
	TrialPodium_Player3.angles = Angles[2];
	TrialPodium_Player3 setmodel(SelectedModel);
	TrialPodium_Player3 thread PodiumSetupTrigger(2);
	
	TrialPodium_Player4 = spawn( "script_model", Origin[3]);
	TrialPodium_Player4.angles = Angles[3];
	TrialPodium_Player4 setmodel(SelectedModel);
	TrialPodium_Player4 thread PodiumSetupTrigger(3);
	
	TrialMainModel = spawn( "script_model", ActivatiorOrigim);
	TrialMainModel.angles = ActivatorAngles;
	TrialMainModel setmodel(ActivatiorModel);
	
	TrialsMainTrigger = spawn("trigger_radius", ActivatiorOrigim, 1, 50, 50);
	TrialsMainTrigger SetCursorHint( "HINT_NOICON" );
	while(1){
		TrialsCost = getDvarInt("TrialsCost");
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
      				Num = randomintrange(0, Challenges.size);
      				if(isdefined(LastChallenge) && LastChallenge == Challenges[Num])
      					Num = randomintrange(0, Challenges.size);
        			level thread ChallengeHandler(Challenges[Num]);
        			LastChallenge = Challenges[Num];
        			level.ReaperTrialsActive++;
				}
            }
		}
	}
}

ChallengeHandler(Challenge)
{
	time = getdvarint("TrialsTime");
	if(Challenge == "K_Trial"){
		ChallengeDescription = "Kill Zombies";
		ChallengePoints = 0.5;
	}
	else if(Challenge == "HK_Trial"){
		ChallengeDescription = "Kill Zombies With Headshots";
		ChallengePoints = 1.5;
	}
	else if(Challenge == "MK_Trial"){
		ChallengeDescription = "Kill Zombies with Melee Attacks";
		ChallengePoints = 1.5;
	}
	else if(Challenge == "KISZ_Trial"){
		keys = getarraykeys( level.zones );
		Num = randomintrange(0, keys.size);
		ZoneName = get_zone_name(level.zones[ keys[Num] ]);
		Zone = level.zones[ keys[Num] ];
		ChallengeDescription = "Kill Zombies at Location\n^3"+ZoneName;
		ChallengePoints = 1;
	}
	else if(Challenge == "SISZ_Trial"){
		keys = getarraykeys( level.zones );
		Num = randomintrange(0, keys.size);
		ZoneName = get_zone_name(level.zones[ keys[Num] ]);
		Zone = level.zones[ keys[Num] ];
		ChallengeDescription = "Remain Inside Location As Long As Possible\n^3"+ZoneName;
		ChallengePoints = 1;
	}
	else if(Challenge == "GO_Trial"){
		ChallengeDescription = "Kill Zombies with Grenades";
		ChallengePoints = 1;
	}
	else if(Challenge == "C_Trial"){
		ChallengeDescription = "Kill Zombies while Crouched";
		ChallengePoints = 1;
	}
	// Setup Challenge For Players
	players = get_players();
	for(i = 0;i < players.size;i++){
		if(Challenge != "SISZ_Trial")
			players[i] thread PlayerTrialHandlerKill(challenge, ChallengePoints, Zone);
		else
			players[i] thread PlayerTrialHandlerTime(challenge, ChallengePoints, Zone);
			
		players[i] toggle_trial_challenge_hud(ZoneName);
		players[i] set_trial_challenge(ChallengeDescription);
		players[i] set_trial_timer(time);
	}
	wait time;
	for(i = 0;i < players.size;i++){
		players[i] notify("TrialOver");
		players[i] toggle_trial_challenge_hud();
	}
	level.ReaperTrialsActive = 0;
}
// All Kill Based Challenges COme in here
PlayerTrialHandlerKill(trial, Points, SpecificZone)
{
	level endon("game_ended");
	self endon("TrialOver");
	while(1){
		self waittill( "zom_kill", zombie);
		if(trial == "K_Trial")
			self AddPlayerMagicPoints(Points);
		else if(trial == "HK_Trial"){
			if ( zombie.damagelocation == "head" || zombie.damagelocation == "helmet" || zombie.damagelocation == "neck" ) {
				self AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "MK_Trial"){
			if ( zombie.damagemod == "MOD_MELEE" || zombie.damagemod == "MOD_IMPACT" ) {
				self AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "KISZ_Trial"){
			if(isdefined(SpecificZone.volume)){
				if(self istouching(SpecificZone.volumes) && zombie istouching(SpecificZone.volumes)){
					self AddPlayerMagicPoints(Points);
				}
			}
		}
		else if(trial == "GO_Trial"){
			if ( zombie.damagemod == "MOD_GRENADE" || zombie.damagemod == "MOD_GRENADE_SPLASH" || zombie.damagemod == "MOD_EXPLOSIVE" ){
				self AddPlayerMagicPoints(Points);
			}
		}
		else if(trial == "C_Trial"){
			if(self GetStance() == "crouch"){
				self AddPlayerMagicPoints(Points);
			}
		}
	}
}
// All Time Based Challenges Come in here
PlayerTrialHandlerTime(trial, Points, SpecificZone)
{
	level endon("game_ended");
	self endon("TrialOver");
	while(1)
	{
		if(trial == "SISZ_Trial"){
			if(isdefined(SpecificZone)){
				if(isdefined(SpecificZone.volumes) && self istouching(SpecificZone.volumes)){
					self AddPlayerMagicPoints(Points);
				}
			}
		}
		wait 2;
	}
}

toggle_trial_challenge_hud(SpecificZone) {
    if (!isdefined(self.trials_init))
        return;

    sq_size = self.trials_height;
    sq_wide = self.trials_width;
    sq_dot = self.trials_space;
    sq_star = self.trials_star;
    x = self.trials_x;
    y = self.trials_y;

    if (isdefined(self.trials_show_challenge) && self.trials_show_challenge) {
        self.trials_show_challenge = false;
        self.trials_bg.alpha = 0;
        self.trials_timer_bg.alpha = 0;
        self.trials_timer_bar.alpha = 0;
        self.trials_timer.alpha = 0;
        self.trials_challenge destroy();
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
            if(isdefined(SpecificZone))
        		self.trials_challenge.y = y - 8;
        	else
 	        	self.trials_challenge.y = y;
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
        self.trials_upgrade settext("REWARD UPGRADED");
    }

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
}

set_trial_reward(tier) {
    if (!isdefined(self.trials_init))
        return;

    if (!isdefined(tier))
        tier = "common";

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

    self.trials_reward_color = color[0];
    self.trials_reward_code = getsubstr(text, 0, 2);
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
}

set_trial_challenge(text) {
    if (!isdefined(self.trials_init) || !isdefined(text))
        return;

    self.trials_challenge settext(text);    
}

set_trial_timer(time) {
    if (!isdefined(self.trials_init) || !isdefined(time))
        return;

    self.trials_timer settimer(time);
}

AddPlayerMagicPoints(num){
	Original_Value = self.ReaperTrialsCurrentMagic;
	self.ReaperTrialsCurrentMagic += num;
	self draw_trial_progress();
	if(self.ReaperTrialsCurrentMagic >= 100){
		if(Original_Value < self.ReaperTrialsCurrentMagic){
		
		}
		else
			self.ReaperTrialsCurrentMagic = 100;
	}
	if(self.ReaperTrialsCurrentMagic >= 25){
		if(self.ReaperTrialsCurrentMagic >= 25){
			if(self.trials_reward_color != (0,1,0)){
				self toggle_trial_reward_hud();
				self set_trial_reward("common");
				self thread draw_reward_alert();
			}
		}
		if(self.ReaperTrialsCurrentMagic >= 50){
			if(self.trials_reward_color != (0,.5,1)){
				self set_trial_reward("rare");
				self thread draw_reward_alert();
			}
		}
		if(self.ReaperTrialsCurrentMagic >= 75){
			if(self.trials_reward_color != (0.345, 0, 0.576)){
				self set_trial_reward("epic");
				self thread draw_reward_alert();
			}
		}
		if(self.ReaperTrialsCurrentMagic == 100){
			if(self.trials_reward_color != (1, 0.478, 0)){
				self set_trial_reward("legendary");
				self thread draw_reward_alert();
			}
		}
	}
}

PodiumSetupTrigger(num)
{
	trig = Spawn( "trigger_radius", self.origin + (0, 0, 30), 0, 60, 80 );
	trig SetCursorHint( "HINT_NOICON" );
	trig thread show_only_to_player(num);
	
	Legendary_Reward_list = [];
	Legendary_Reward_list[0] = "full_ammo";
	Legendary_Reward_list[1] = "insta_kill";
	Legendary_Reward_list[2] = "free_perk";
	Legendary_Reward_list[3] = 5000; //Points
	
	Epic_Reward_list = [];
	Epic_Reward_list[0] = "full_ammo";
	Epic_Reward_list[1] = "double_points";
	Epic_Reward_list[2] = "free_perk";
	Epic_Reward_list[3] = 3500; //Points
	Epic_Reward_list[4] = "insta_kill";
	
	Rare_Reward_list = [];
	Rare_Reward_list[0] = "carpenter";
	Rare_Reward_list[1] = "double_points";
	Rare_Reward_list[2] = "nuke";
	Rare_Reward_list[3] = 2000;
	
	Common_Reward_list = [];
	Common_Reward_list[0] = "nuke";
	Common_Reward_list[1] = "carpenter";
	Common_Reward_list[2] = 1000;		
	
	while(1){
		players = GetPlayers();
		if(players[num].ReaperTrialsCurrentMagic > 25)
			reward_level = "^2Common";
		if(players[num].ReaperTrialsCurrentMagic > 50)
			reward_level = "^4Rare";
		if(players[num].ReaperTrialsCurrentMagic > 75)
			reward_level = "^6Epic";
		if(players[num].ReaperTrialsCurrentMagic == 100)
			reward_level = "^3Legendary";
		if(players[num].ReaperTrialsCurrentMagic > 25)
			trig SetHintString( "Press ^3[{+activate}]^7 To Claim " + reward_level + "^7 Reward");
		else
			trig SetHintString( "Reward Level ^3Too Low^7" );
		trig waittill( "trigger", player);
		if(!player UseButtonPressed() || player != GetPlayers()[num] || isdefined(trig.has_reward) ){
			wait .01;
			continue;
		}
		if(players[num].ReaperTrialsCurrentMagic <= 25){
			wait .01;
			continue;
		}
		trig.has_reward = 1;
		trig waittill( "trigger", player);
		if(!player UseButtonPressed() || player != GetPlayers()[num] || isdefined(trig.has_reward) ){
			wait .01;
			continue;
		}
		trig SetHintString( "Press & Hold ^3[{+activate}]^7 To Take Reward" );
		if(players[num].ReaperTrialsCurrentMagic == 100){
			legendary_reward_num = randomintrange(0, Legendary_Reward_list.size);
			final_legendary_reward = Legendary_Reward_list[legendary_reward_num];
   			players[num] spawn_powerup_a(num,final_legendary_reward);
		}
		if(players[num].ReaperTrialsCurrentMagic > 75){
			epic_reward_num = randomintrange(0, Epic_Reward_list.size);
			final_epic_reward = Epic_Reward_list[epic_reward_num];
   			players[num] spawn_powerup_a(num,final_epic_reward);
		}
		if(players[num].reaper_challenge_power > 50){
			rare_reward_num = randomintrange(0, rare_Reward_list.size);
			final_rare_reward = rare_Reward_list[rare_reward_num];
   			players[num] spawn_powerup_a(num,final_rare_reward);
		}
		else{
			common_reward_num = randomintrange(0, common_Reward_list.size);
			final_common_reward = common_Reward_list[common_reward_num];
   			players[num] spawn_powerup_a(num,final_common_reward);
		}
      	players[num].ReaperTrialsCurrentMagic = 0;
      	players[num] toggle_trial_reward_hud();
		wait 0.5;
	}
}

show_only_to_player(num)
{
	level endon("game_ended");
	while(1){
		self SetInvisibleToAll(); 
		self SetVisibleToPlayer( GetPlayers()[num] );
		wait 1;
	}
}

spawn_powerup_a(num,pow)
{
	if(num == 0)
		self thread maps/mp/zombies/_zm_powerups::specific_powerup_drop(pow, ((878.738, -785.876, 150.125) + (0, 0, 30)));
	if(num == 1)
		self thread maps/mp/zombies/_zm_powerups::specific_powerup_drop(pow, ((962.979, -785.636, 150.125) + (0, 0, 30)));
	if(num == 2)
		self thread maps/mp/zombies/_zm_powerups::specific_powerup_drop(pow, ((1135.96, -1024.87, 150.125) + (0, 0, 30)));
	if(num == 3)
		self thread maps/mp/zombies/_zm_powerups::specific_powerup_drop(pow, ((1139.47, -1107.2, 150.125) + (0, 0, 30)));
}

// Credits to Jbleezy
get_zone_name(zone)
{
	if (level.script == "zm_transit")
	{
		if(zone == "zone_pri")
		{
			name = "Bus Depot";
		}
		else if (zone == "zone_pri2")
		{
			name = "Bus Depot Hallway";
		}
		else if (zone == "zone_station_ext")
		{
			name = "Outside Bus Depot";
		}
		else if (zone == "zone_trans_2b")
		{
			name = "Fog After Bus Depot";
		}
		else if (zone == "zone_trans_2")
		{
			name = "Tunnel Entrance";
		}
		else if (zone == "zone_amb_tunnel")
		{
			name = "Tunnel";
		}
		else if (zone == "zone_trans_3")
		{
			name = "Tunnel Exit";
		}
		else if (zone == "zone_roadside_west")
		{
			name = "Outside Diner";
		}
		else if (zone == "zone_gas")
		{
			name = "Gas Station";
		}
		else if (zone == "zone_roadside_east")
		{
			name = "Outside Garage";
		}
		else if (zone == "zone_trans_diner")
		{
			name = "Fog Outside Diner";
		}
		else if (zone == "zone_trans_diner2")
		{
			name = "Fog Outside Garage";
		}
		else if (zone == "zone_gar")
		{
			name = "Garage";
		}
		else if (zone == "zone_din")
		{
			name = "Diner";
		}
		else if (zone == "zone_diner_roof")
		{
			name = "Diner Roof";
		}
		else if (zone == "zone_trans_4")
		{
			name = "Fog After Diner";
		}
		else if (zone == "zone_amb_forest")
		{
			name = "Forest";
		}
		else if (zone == "zone_trans_10")
		{
			name = "Outside Church";
		}
		else if (zone == "zone_town_church")
		{
			name = "Upper South Town";
		}
		else if (zone == "zone_trans_5")
		{
			name = "Fog Before Farm";
		}
		else if (zone == "zone_far")
		{
			name = "Outside Farm";
		}
		else if (zone == "zone_far_ext")
		{
			name = "Farm";
		}
		else if (zone == "zone_brn")
		{
			name = "Barn";
		}
		else if (zone == "zone_farm_house")
		{
			name = "Farmhouse";
		}
		else if (zone == "zone_trans_6")
		{
			name = "Fog After Farm";
		}
		else if (zone == "zone_amb_cornfield")
		{
			name = "Cornfield";
		}
		else if (zone == "zone_cornfield_prototype")
		{
			name = "Nacht der Untoten";
		}
		else if (zone == "zone_trans_7")
		{
			name = "Upper Fog Before Power";
		}
		else if (zone == "zone_trans_pow_ext1")
		{
			name = "Fog Before Power";
		}
		else if (zone == "zone_pow")
		{
			name = "Outside Power Station";
		}
		else if (zone == "zone_prr")
		{
			name = "Power Station";
		}
		else if (zone == "zone_pcr")
		{
			name = "Power Control Room";
			level notify("custom_power_event");
		}
		else if (zone == "zone_pow_warehouse")
		{
			name = "Warehouse";
		}
		else if (zone == "zone_trans_8")
		{
			name = "Fog After Power";
		}
		else if (zone == "zone_amb_power2town")
		{
			name = "Cabin";
		}
		else if (zone == "zone_trans_9")
		{
			name = "Fog Before Town";
		}
		else if (zone == "zone_town_north")
		{
			name = "North Town";
		}
		else if (zone == "zone_tow")
		{
			name = "Center Town";
		}
		else if (zone == "zone_town_east")
		{
			name = "East Town";
		}
		else if (zone == "zone_town_west")
		{
			name = "West Town";
		}
		else if (zone == "zone_town_south")
		{
			name = "South Town";
		}
		else if (zone == "zone_bar")
		{
			name = "Bar";
		}
		else if (zone == "zone_town_barber")
		{
			name = "Bookstore";
		}
		else if (zone == "zone_ban")
		{
			name = "Bank";
		}
		else if (zone == "zone_ban_vault")
		{
			name = "Bank Vault";
		}
		else if (zone == "zone_tbu")
		{
			name = "Lab";
		}
		else if (zone == "zone_trans_11")
		{
			name = "Fog After Town";
		}
		else if (zone == "zone_amb_bridge")
		{
			name = "Bridge";
		}
		else if (zone == "zone_trans_1")
		{
			name = "Fog Before Bus Depot";
		}
	}
	else if (level.script == "zm_nuked")
	{
		if (zone == "culdesac_yellow_zone")
		{
			name = "Yellow House Cul-de-sac";
		}
		else if (zone == "culdesac_green_zone")
		{
			name = "Green House Cul-de-sac";
		}
		else if (zone == "truck_zone")
		{
			name = "Truck";
		}
		else if (zone == "openhouse1_f1_zone")
		{
			name = "Green House Downstairs";
		}
		else if (zone == "openhouse1_f2_zone")
		{
			name = "Green House Upstairs";
		}
		else if (zone == "openhouse1_backyard_zone")
		{
			name = "Green House Backyard";
		}
		else if (zone == "openhouse2_f1_zone")
		{
			name = "Yellow House Downstairs";
		}
		else if (zone == "openhouse2_f2_zone")
		{
			name = "Yellow House Upstairs";
		}
		else if (zone == "openhouse2_backyard_zone")
		{
			name = "Yellow House Backyard";
		}
		else if (zone == "ammo_door_zone")
		{
			name = "Yellow House Backyard Door";
		}
	}
	else if (level.script == "zm_highrise")
	{
		if (zone == "zone_green_start")
		{
			name = "Green Highrise Level 3b";
		}
		else if (zone == "zone_green_escape_pod")
		{
			name = "Escape Pod";
		}
		else if (zone == "zone_green_escape_pod_ground")
		{
			name = "Escape Pod Shaft";
		}
		else if (zone == "zone_green_level1")
		{
			name = "Green Highrise Level 3a";
		}
		else if (zone == "zone_green_level2a")
		{
			name = "Green Highrise Level 2a";
		}
		else if (zone == "zone_green_level2b")
		{
			name = "Green Highrise Level 2b";
		}
		else if (zone == "zone_green_level3a")
		{
			name = "Green Highrise Restaurant";
		}
		else if (zone == "zone_green_level3b")
		{
			name = "Green Highrise Level 1a";
		}
		else if (zone == "zone_green_level3c")
		{
			name = "Green Highrise Level 1b";
		}
		else if (zone == "zone_green_level3d")
		{
			name = "Green Highrise Behind Restaurant";
		}
		else if (zone == "zone_orange_level1")
		{
			name = "Upper Orange Highrise Level 2";
		}
		else if (zone == "zone_orange_level2")
		{
			name = "Upper Orange Highrise Level 1";
		}
		else if (zone == "zone_orange_elevator_shaft_top")
		{
			name = "Elevator Shaft Level 3";
		}
		else if (zone == "zone_orange_elevator_shaft_middle_1")
		{
			name = "Elevator Shaft Level 2";
		}
		else if (zone == "zone_orange_elevator_shaft_middle_2")
		{
			name = "Elevator Shaft Level 1";
		}
		else if (zone == "zone_orange_elevator_shaft_bottom")
		{
			name = "Elevator Shaft Bottom";
		}
		else if (zone == "zone_orange_level3a")
		{
			name = "Lower Orange Highrise Level 1a";
		}
		else if (zone == "zone_orange_level3b")
		{
			name = "Lower Orange Highrise Level 1b";
		}
		else if (zone == "zone_blue_level5")
		{
			name = "Lower Blue Highrise Level 1";
		}
		else if (zone == "zone_blue_level4a")
		{
			name = "Lower Blue Highrise Level 2a";
		}
		else if (zone == "zone_blue_level4b")
		{
			name = "Lower Blue Highrise Level 2b";
		}
		else if (zone == "zone_blue_level4c")
		{
			name = "Lower Blue Highrise Level 2c";
		}
		else if (zone == "zone_blue_level2a")
		{
			name = "Upper Blue Highrise Level 1a";
		}
		else if (zone == "zone_blue_level2b")
		{
			name = "Upper Blue Highrise Level 1b";
		}
		else if (zone == "zone_blue_level2c")
		{
			name = "Upper Blue Highrise Level 1c";
		}
		else if (zone == "zone_blue_level2d")
		{
			name = "Upper Blue Highrise Level 1d";
		}
		else if (zone == "zone_blue_level1a")
		{
			name = "Upper Blue Highrise Level 2a";
		}
		else if (zone == "zone_blue_level1b")
		{
			name = "Upper Blue Highrise Level 2b";
		}
		else if (zone == "zone_blue_level1c")
		{
			name = "Upper Blue Highrise Level 2c";
		}
	}
	else if (level.script == "zm_prison")
	{
		if (zone == "zone_start")
		{
			name = "D-Block";
		}
		else if (zone == "zone_library")
		{
			name = "Library";
		}
		else if (zone == "zone_cellblock_west")
		{
			name = "Cellblock 2nd Floor";
		}
		else if (zone == "zone_cellblock_west_gondola")
		{
			name = "Cellblock 3rd Floor";
		}
		else if (zone == "zone_cellblock_west_gondola_dock")
		{
			name = "Cellblock Gondola";
		}
		else if (zone == "zone_cellblock_west_barber")
		{
			name = "Michigan Avenue";
		}
		else if (zone == "zone_cellblock_east")
		{
			name = "Times Square";
		}
		else if (zone == "zone_cafeteria")
		{
			name = "Cafeteria";
		}
		else if (zone == "zone_cafeteria_end")
		{
			name = "Cafeteria End";
		}
		else if (zone == "zone_infirmary")
		{
			name = "Infirmary 1";
		}
		else if (zone == "zone_infirmary_roof")
		{
			name = "Infirmary 2";
		}
		else if (zone == "zone_roof_infirmary")
		{
			name = "Roof 1";
		}
		else if (zone == "zone_roof")
		{
			name = "Roof 2";
		}
		else if (zone == "zone_cellblock_west_warden")
		{
			name = "Sally Port";
		}
		else if (zone == "zone_warden_office")
		{
			name = "Warden's Office";
		}
		else if (zone == "cellblock_shower")
		{
			name = "Showers";
		}
		else if (zone == "zone_citadel_shower")
		{
			name = "Citadel To Showers";
		}
		else if (zone == "zone_citadel")
		{
			name = "Citadel";
		}
		else if (zone == "zone_citadel_warden")
		{
			name = "Citadel To Warden's Office";
		}
		else if (zone == "zone_citadel_stairs")
		{
			name = "Citadel Tunnels";
		}
		else if (zone == "zone_citadel_basement")
		{
			name = "Citadel Basement";
		}
		else if (zone == "zone_citadel_basement_building")
		{
			name = "China Alley";
		}
		else if (zone == "zone_studio")
		{
			name = "Building 64";
		}
		else if (zone == "zone_dock")
		{
			name = "Docks";
		}
		else if (zone == "zone_dock_puzzle")
		{
			name = "Docks Gates";
		}
		else if (zone == "zone_dock_gondola")
		{
			name = "Upper Docks";
		}
		else if (zone == "zone_golden_gate_bridge")
		{
			name = "Golden Gate Bridge";
		}
		else if (zone == "zone_gondola_ride")
		{
			name = "Gondola";
		}
	}
	else if (level.script == "zm_buried")
	{
		if (zone == "zone_start")
		{
			name = "Processing";
		}
		else if (zone == "zone_start_lower")
		{
			name = "Lower Processing";
		}
		else if (zone == "zone_tunnels_center")
		{
			name = "Center Tunnels";
		}
		else if (zone == "zone_tunnels_north")
		{
			name = "Courthouse Tunnels 2";
		}
		else if (zone == "zone_tunnels_north2")
		{
			name = "Courthouse Tunnels 1";
		}
		else if (zone == "zone_tunnels_south")
		{
			name = "Saloon Tunnels 3";
		}
		else if (zone == "zone_tunnels_south2")
		{
			name = "Saloon Tunnels 2";
		}
		else if (zone == "zone_tunnels_south3")
		{
			name = "Saloon Tunnels 1";
		}
		else if (zone == "zone_street_lightwest")
		{
			name = "Outside General Store & Bank";
		}
		else if (zone == "zone_street_lightwest_alley")
		{
			name = "Outside General Store & Bank Alley";
		}
		else if (zone == "zone_morgue_upstairs")
		{
			name = "Morgue";
		}
		else if (zone == "zone_underground_jail")
		{
			name = "Jail Downstairs";
		}
		else if (zone == "zone_underground_jail2")
		{
			name = "Jail Upstairs";
		}
		else if (zone == "zone_general_store")
		{
			name = "General Store";
		}
		else if (zone == "zone_stables")
		{
			name = "Stables";
		}
		else if (zone == "zone_street_darkwest")
		{
			name = "Outside Gunsmith";
		}
		else if (zone == "zone_street_darkwest_nook")
		{
			name = "Outside Gunsmith Nook";
		}
		else if (zone == "zone_gun_store")
		{
			name = "Gunsmith";
		}
		else if (zone == "zone_bank")
		{
			name = "Bank";
		}
		else if (zone == "zone_tunnel_gun2stables")
		{
			name = "Stables To Gunsmith Tunnel 2";
		}
		else if (zone == "zone_tunnel_gun2stables2")
		{
			name = "Stables To Gunsmith Tunnel";
		}
		else if (zone == "zone_street_darkeast")
		{
			name = "Outside Saloon & Toy Store";
		}
		else if (zone == "zone_street_darkeast_nook")
		{
			name = "Outside Saloon & Toy Store Nook";
		}
		else if (zone == "zone_underground_bar")
		{
			name = "Saloon";
		}
		else if (zone == "zone_tunnel_gun2saloon")
		{
			name = "Saloon To Gunsmith Tunnel";
		}
		else if (zone == "zone_toy_store")
		{
			name = "Toy Store Downstairs";
		}
		else if (zone == "zone_toy_store_floor2")
		{
			name = "Toy Store Upstairs";
		}
		else if (zone == "zone_toy_store_tunnel")
		{
			name = "Toy Store Tunnel";
		}
		else if (zone == "zone_candy_store")
		{
			name = "Candy Store Downstairs";
		}
		else if (zone == "zone_candy_store_floor2")
		{
			name = "Candy Store Upstairs";
		}
		else if (zone == "zone_street_lighteast")
		{
			name = "Outside Courthouse & Candy Store";
		}
		else if (zone == "zone_underground_courthouse")
		{
			name = "Courthouse Downstairs";
		}
		else if (zone == "zone_underground_courthouse2")
		{
			name = "Courthouse Upstairs";
		}
		else if (zone == "zone_street_fountain")
		{
			name = "Fountain";
		}
		else if (zone == "zone_church_graveyard")
		{
			name = "Graveyard";
		}
		else if (zone == "zone_church_main")
		{
			name = "Church Downstairs";
		}
		else if (zone == "zone_church_upstairs")
		{
			name = "Church Upstairs";
		}
		else if (zone == "zone_mansion_lawn")
		{
			name = "Mansion Lawn";
		}
		else if (zone == "zone_mansion")
		{
			name = "Mansion";
		}
		else if (zone == "zone_mansion_backyard")
		{
			name = "Mansion Backyard";
		}
		else if (zone == "zone_maze")
		{
			name = "Maze";
		}
		else if (zone == "zone_maze_staircase")
		{
			name = "Maze Staircase";
		}
	}
	else if (level.script == "zm_tomb")
	{
		if (isDefined(self.teleporting) && self.teleporting)
		{
			return "";
		}

		if (zone == "zone_start")
		{
			name = "Lower Laboratory";
		}
		else if (zone == "zone_start_a")
		{
			name = "Upper Laboratory";
		}
		else if (zone == "zone_start_b")
		{
			name = "Generator 1";
		}
		else if (zone == "zone_bunker_1a")
		{
			name = "Generator 3 Bunker 1";
		}
		else if (zone == "zone_fire_stairs")
		{
			name = "Fire Tunnel";
		}
		else if (zone == "zone_bunker_1")
		{
			name = "Generator 3 Bunker 2";
		}
		else if (zone == "zone_bunker_3a")
		{
			name = "Generator 3";
		}
		else if (zone == "zone_bunker_3b")
		{
			name = "Generator 3 Bunker 3";
		}
		else if (zone == "zone_bunker_2a")
		{
			name = "Generator 2 Bunker 1";
		}
		else if (zone == "zone_bunker_2")
		{
			name = "Generator 2 Bunker 2";
		}
		else if (zone == "zone_bunker_4a")
		{
			name = "Generator 2";
		}
		else if (zone == "zone_bunker_4b")
		{
			name = "Generator 2 Bunker 3";
		}
		else if (zone == "zone_bunker_4c")
		{
			name = "Tank Station";
		}
		else if (zone == "zone_bunker_4d")
		{
			name = "Above Tank Station";
		}
		else if (zone == "zone_bunker_tank_c")
		{
			name = "Generator 2 Tank Route 1";
		}
		else if (zone == "zone_bunker_tank_c1")
		{
			name = "Generator 2 Tank Route 2";
		}
		else if (zone == "zone_bunker_4e")
		{
			name = "Generator 2 Tank Route 3";
		}
		else if (zone == "zone_bunker_tank_d")
		{
			name = "Generator 2 Tank Route 4";
		}
		else if (zone == "zone_bunker_tank_d1")
		{
			name = "Generator 2 Tank Route 5";
		}
		else if (zone == "zone_bunker_4f")
		{
			name = "zone_bunker_4f";
		}
		else if (zone == "zone_bunker_5a")
		{
			name = "Workshop Downstairs";
		}
		else if (zone == "zone_bunker_5b")
		{
			name = "Workshop Upstairs";
		}
		else if (zone == "zone_nml_2a")
		{
			name = "No Man's Land Walkway";
		}
		else if (zone == "zone_nml_2")
		{
			name = "No Man's Land Entrance";
		}
		else if (zone == "zone_bunker_tank_e")
		{
			name = "Generator 5 Tank Route 1";
		}
		else if (zone == "zone_bunker_tank_e1")
		{
			name = "Generator 5 Tank Route 2";
		}
		else if (zone == "zone_bunker_tank_e2")
		{
			name = "zone_bunker_tank_e2";
		}
		else if (zone == "zone_bunker_tank_f")
		{
			name = "Generator 5 Tank Route 3";
		}
		else if (zone == "zone_nml_1")
		{
			name = "Generator 5 Tank Route 4";
		}
		else if (zone == "zone_nml_4")
		{
			name = "Generator 5 Tank Route 5";
		}
		else if (zone == "zone_nml_0")
		{
			name = "Generator 5 Left Footstep";
		}
		else if (zone == "zone_nml_5")
		{
			name = "Generator 5 Right Footstep Walkway";
		}
		else if (zone == "zone_nml_farm")
		{
			name = "Generator 5";
		}
		else if (zone == "zone_nml_celllar")
		{
			name = "Generator 5 Cellar";
		}
		else if (zone == "zone_bolt_stairs")
		{
			name = "Lightning Tunnel";
		}
		else if (zone == "zone_nml_3")
		{
			name = "No Man's Land 1st Right Footstep";
		}
		else if (zone == "zone_nml_2b")
		{
			name = "No Man's Land Stairs";
		}
		else if (zone == "zone_nml_6")
		{
			name = "No Man's Land Left Footstep";
		}
		else if (zone == "zone_nml_8")
		{
			name = "No Man's Land 2nd Right Footstep";
		}
		else if (zone == "zone_nml_10a")
		{
			name = "Generator 4 Tank Route 1";
		}
		else if (zone == "zone_nml_10")
		{
			name = "Generator 4 Tank Route 2";
		}
		else if (zone == "zone_nml_7")
		{
			name = "Generator 4 Tank Route 3";
		}
		else if (zone == "zone_bunker_tank_a")
		{
			name = "Generator 4 Tank Route 4";
		}
		else if (zone == "zone_bunker_tank_a1")
		{
			name = "Generator 4 Tank Route 5";
		}
		else if (zone == "zone_bunker_tank_a2")
		{
			name = "zone_bunker_tank_a2";
		}
		else if (zone == "zone_bunker_tank_b")
		{
			name = "Generator 4 Tank Route 6";
		}
		else if (zone == "zone_nml_9")
		{
			name = "Generator 4 Left Footstep";
		}
		else if (zone == "zone_air_stairs")
		{
			name = "Wind Tunnel";
		}
		else if (zone == "zone_nml_11")
		{
			name = "Generator 4";
		}
		else if (zone == "zone_nml_12")
		{
			name = "Generator 4 Right Footstep";
		}
		else if (zone == "zone_nml_16")
		{
			name = "Excavation Site Front Path";
		}
		else if (zone == "zone_nml_17")
		{
			name = "Excavation Site Back Path";
		}
		else if (zone == "zone_nml_18")
		{
			name = "Excavation Site Level 3";
		}
		else if (zone == "zone_nml_19")
		{
			name = "Excavation Site Level 2";
		}
		else if (zone == "ug_bottom_zone")
		{
			name = "Excavation Site Level 1";
		}
		else if (zone == "zone_nml_13")
		{
			name = "Generator 5 To Generator 6 Path";
		}
		else if (zone == "zone_nml_14")
		{
			name = "Generator 4 To Generator 6 Path";
		}
		else if (zone == "zone_nml_15")
		{
			name = "Generator 6 Entrance";
		}
		else if (zone == "zone_village_0")
		{
			name = "Generator 6 Left Footstep";
		}
		else if (zone == "zone_village_5")
		{
			name = "Generator 6 Tank Route 1";
		}
		else if (zone == "zone_village_5a")
		{
			name = "Generator 6 Tank Route 2";
		}
		else if (zone == "zone_village_5b")
		{
			name = "Generator 6 Tank Route 3";
		}
		else if (zone == "zone_village_1")
		{
			name = "Generator 6 Tank Route 4";
		}
		else if (zone == "zone_village_4b")
		{
			name = "Generator 6 Tank Route 5";
		}
		else if (zone == "zone_village_4a")
		{
			name = "Generator 6 Tank Route 6";
		}
		else if (zone == "zone_village_4")
		{
			name = "Generator 6 Tank Route 7";
		}
		else if (zone == "zone_village_2")
		{
			name = "Church";
		}
		else if (zone == "zone_village_3")
		{
			name = "Generator 6 Right Footstep";
		}
		else if (zone == "zone_village_3a")
		{
			name = "Generator 6";
		}
		else if (zone == "zone_ice_stairs")
		{
			name = "Ice Tunnel";
		}
		else if (zone == "zone_bunker_6")
		{
			name = "Above Generator 3 Bunker";
		}
		else if (zone == "zone_nml_20")
		{
			name = "Above No Man's Land";
		}
		else if (zone == "zone_village_6")
		{
			name = "Behind Church";
		}
		else if (zone == "zone_chamber_0")
		{
			name = "The Crazy Place Lightning Chamber";
		}
		else if (zone == "zone_chamber_1")
		{
			name = "The Crazy Place Lightning & Ice";
		}
		else if (zone == "zone_chamber_2")
		{
			name = "The Crazy Place Ice Chamber";
		}
		else if (zone == "zone_chamber_3")
		{
			name = "The Crazy Place Fire & Lightning";
		}
		else if (zone == "zone_chamber_4")
		{
			name = "The Crazy Place Center";
		}
		else if (zone == "zone_chamber_5")
		{
			name = "The Crazy Place Ice & Wind";
		}
		else if (zone == "zone_chamber_6")
		{
			name = "The Crazy Place Fire Chamber";
		}
		else if (zone == "zone_chamber_7")
		{
			name = "The Crazy Place Wind & Fire";
		}
		else if (zone == "zone_chamber_8")
		{
			name = "The Crazy Place Wind Chamber";
		}
		else if (zone == "zone_robot_head")
		{
			name = "Robot's Head";
		}
	}
	return name;
}
