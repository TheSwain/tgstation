#define CULT_BLOOD_SWORD "Blood" //Always causes bleeding. Drains 50u Blood on each hit.
#define CULT_LIFEEATER_SWORD "Life Eating" //Reduces attacker's brute damage by 40% of brute damage dealt.
#define CULT_CORRUPTION_SWORD "Corruption" //Deals 20 brute and inflicts 3U Unholy Water. Traps the victim in a soulstone if it delivers the killing blow.
#define CULT_PESTILENCE_SWORD "Pestilence" //Deals 20 brute and 10 toxin damage. Inflicts Unholy Wasting on a 3 minute cooldown.
#define CULT_FAMINE_SWORD "Famine" //Deals 20 brute and 10 toxin damage. Massively drains nutrition on hit and injects 20U Lipolicide.
#define CULT_HELLFIRE_SWORD "Hellfire" //Deals burn damage instead of brute; inflicts burn stacks and lights on fire.
#define CULT_HELLFROST_SWORD "Hellfrost" // Deals burn damage instead of brute; massively reduces target temperature and injects 10U Frost Oil
#define CULT_CHAOS_SWORD "Chaos" // Deals 2-80 damage of a random type (brute, burn, toxin); bell curve distribution.
#define CULT_MADNESS_SWORD "Madness" // Deals 20 Brute Damage, 20 Brain damage and inflicts Confusion and Hallucination stacks.
#define CULT_AGONY_SWORD "Agony" //Deals 20 Brute, 35 Stamina damage on hit.
#define CULT_VORPAL_SWORD "Piercing" //+3 damage. Ignores armor.
#define CULT_WARDING_SWORD "Warding" //Has a 50% melee and ranged deflection chance
#define CULT_DEVOURING_SWORD "Devouring" //Deals 45 Brute, 5 Brute to the user.
#define CULT_HEARTSEEKER_SWORD "Returning" //Faster throw speed. More damage on throw. Boomerangs back to the owner after being thrown.
#define CULT_BRUTAL_SWORD "Brutality" //Deals extra damage and knocks back on a 30 second cooldown.
#define CULT_DESTRUCTION_SWORD "Destruction" //Deals triple damage to objects, double to silicons, can break walls on a cooldown.

#define CULT_OFFERING_SWORD_EMPOWER_TIME 1 SECONDS
#define CULT_AGONY_SWORD_STAMINA_DAMAGE 35
#define CULT_LIFEEATER_SWORD_EFFECT_TIME 0.5 SECONDS
#define CULT_CORRUPTION_SWORD_UNHOLY_WATER 3
#define CULT_PESTILENCE_SWORD_TOXIN_DAMAGE 15
#define CULT_PESTILENCE_SWORD_COOLDOWN 30 SECONDS
#define CULT_FAMINE_SWORD_NUTRITION_LOSS -200
#define CULT_FAMINE_SWORD_LIPOCIDE 20
#define CULT_FAMINE_SWORD_TOXIN_DAMAGE 10
#define CULT_HELLFIRE_SWORD_PHLOGISTON 3
#define CULT_HELLFROST_SWORD_FROST_OIL 10
#define CULT_MADNESS_SWORD_HALLUCINATION 100
#define CULT_DEVOURING_SWORD_SELF_DAMAGE 5
#define CULT_BLOOD_SWORD_BLOOD_LOSS 50
#define CULT_BRUTAL_SWORD_COOLDOWN 30 SECONDS
#define CULT_SWORD_SUMMON_DELAY 5 SECONDS
#define CULT_SWORD_EXORCISE_DELAY 10 SECONDS
#define CULT_DESTRUCTION_HIGH_COOLDOWN 30 SECONDS
#define CULT_DESTRUCTION_LOW_COOLDOWN 5 SECONDS

#define CULT_SWORD_MOB_ATTACK 1
#define CULT_SWORD_AFTERATTACK 2
#define CULT_SWORD_OBJ_ATTACK 3

GLOBAL_LIST_INIT(cult_chaos_sword_projectiles, list(
		/obj/projectile/magic/change, /obj/projectile/magic/animate, /obj/projectile/magic/resurrection,
		/obj/projectile/magic/death, /obj/projectile/magic/teleport, /obj/projectile/magic/door, /obj/projectile/magic/aoe/fireball,
		/obj/projectile/magic/spellblade, /obj/projectile/magic/arcane_barrage, /obj/projectile/magic/locker, /obj/projectile/magic/flying,
		/obj/projectile/magic/bounty, /obj/projectile/magic/antimagic, /obj/projectile/magic/fetch, /obj/projectile/magic/sapping,
		/obj/projectile/magic/necropotence, /obj/projectile/magic, /obj/projectile/temp/chill, /obj/projectile/magic/wipe
		))

/obj/effect/temp_visual/bless
	icon = 'icons/effects/effects.dmi'
	icon_state = "blessed"
	randomdir = 0
	duration = INFINITY

/obj/item/storage/book/bible/proc/purge_daemon_blade(atom/A, mob/user, proximity)

	if(!istype(A, /obj/item/melee/cultblade))
		return

	var/obj/item/melee/cultblade/CB = A

	if(!CB.empowered && !CB.possessor) //if it's a basic eldritch blade we don't care.
		return

	var/turf/T = get_turf(A)

	if(!locate(/obj/effect/blessing, T))
		to_chat(user, "<span class='warning'>The taint of this cursed weapon is too grave to exorcise it off of consecrated grounds.</span>")
		return

	if(CB.empowered && !CB.possessor)

		if(!cultsword_purge_doafter(CB, user))
			return

		CB.empowered = FALSE
		user.visible_message("<span class='notice'>[user] has dissipated [CB]'s unholy energies!</span>")
		return

	if(CB.possessor)

		if(!cultsword_purge_doafter(CB, user))
			return

		for(var/mob/M in CB.contents)
			if(M.mind)
				M.forceMove(T)
				new /obj/effect/temp_visual/cult/sparks(M)
			else(qdel(M))

		qdel(CB)
		new /obj/effect/decal/cleanable/ash/large(T)
		playsound(get_turf(loc), 'sound/magic/demon_dies.ogg', 100, TRUE)
		user.visible_message("<span class='notice'>A dark spirit is exorcised from [CB] as it crumbles to dust!</span>")


/obj/item/storage/book/bible/proc/cultsword_purge_doafter(obj/item/melee/cultblade/CB, mob/user)

	var/obj/effect/temp_visual/bless/B
	to_chat(user, "<span class='notice'>You begin to exorcise [CB].</span>")
	B = new /obj/effect/temp_visual/bless(CB.loc)
	playsound(src,pick('sound/hallucinations/veryfar_noise.ogg','sound/hallucinations/growl1.ogg','sound/hallucinations/growl2.ogg','sound/hallucinations/growl3.ogg'),40,TRUE)

	if(!do_after(user, CULT_SWORD_EXORCISE_DELAY, target = CB))
		qdel(B)
		return FALSE

	qdel(B)
	return TRUE

/obj/effect/rune/convert/proc/empower_sword(mob/sacrificial)
	var/turf/T = get_turf(src)
	var/obj/item/melee/cultblade/C
	for(C in T)
		if(!C.empowered) //We need to be empowered by any sacrifice.
			C.empowered = TRUE
			new /obj/effect/temp_visual/cult/sparks(C)
			new /obj/effect/temp_visual/cult/sparks(loc)
			Beam(C,icon_state="blood",time=CULT_OFFERING_SWORD_EMPOWER_TIME) //cool sfx
			playsound(get_turf(loc), 'sound/magic/exit_blood.ogg', 50, TRUE)
			sacrificial.visible_message("<span class='cult'><b>[C] flares alight with malevolent power!</b></span>")
			break //Empower only one.


/obj/item/melee/cultblade/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(!iscultist(user))
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	switch(possessed) //Making this a switch in the event of future on-equip properties
		if(CULT_HELLFIRE_SWORD)
			ADD_TRAIT(H, TRAIT_NOFIRE, "hell_blade") //We gain immunity to combustion while we have the sword.
			H.fire_stacks = 0 //Zero out any existing fire stacks.


/obj/item/melee/cultblade/dropped(mob/user)
	. = ..()
	if(!iscultist(user))
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/H = user
	switch(possessed) //Making this a switch in the event of future on-equip properties
		if(CULT_HELLFIRE_SWORD)
			REMOVE_TRAIT(H, TRAIT_NOFIRE, "hell_blade") //We lose immunity to combustion while we don't have the sword.
			H.fire_stacks = 0 //Zero out any existing fire stacks.


/obj/item/melee/cultblade/examine(mob/user)
	. = ..()
	if(!iscultist(user) && !isobserver(user)) //Non-cultists won't be able to perceive this information
		return
	if(empowered && !possessed)
		. += "<span class='cult'><b>It is sacrificially empowered and ready to bind a daemon.</b></span>"
	if(possessor)
		. += "<span class='cult'>It is possessed by the daemon <b>[possessor]</b>.</span>"
	if(possessed)
		. += "<span class='cult'>It is imbued with the power of <b>[possessed]</b>.</span>"


/obj/item/melee/cultblade/attack(mob/M, mob/living/carbon/user)
	possessed_cult_blade_attack_setup(M, user)
	..()


/obj/item/melee/cultblade/afterattack(atom/target, mob/user, proximity, click_parameters)
	possessed_cult_blade_attack_setup(target, user, proximity, CULT_SWORD_AFTERATTACK)
	..()

/obj/item/melee/cultblade/attack_obj(obj/O, mob/living/user)
	possessed_cult_blade_objattack(O, user)
	..()

/obj/item/melee/cultblade/proc/possessed_cult_blade_attack_setup(atom/target, mob/user, proximity = TRUE, attack_mode = CULT_SWORD_MOB_ATTACK)
	if(!possessed) //Sanity check
		return FALSE

	if(!iscultist(user)) //Only the chosen may wield this power
		return FALSE

	if(!proximity)
		return FALSE

	if(ismob(target))
		return FALSE

	var/mob/M = target
	var/mob/living/L //Let's complete our defines first
	var/mob/living/carbon/C
	var/mob/living/carbon/human/H
	var/mob/living/L_user

	if(isliving(user))
		L_user = user

	if(isliving(M))
		L = M
		if(iscarbon(M))
			C = M
			if(ishuman(M))
				H = M

	var/antimagic
	if(M.anti_magic_check())
		antimagic = TRUE


	switch(attack_mode)
		if(CULT_SWORD_MOB_ATTACK)
			possessed_cult_blade_attack(M, L, C, H, user, L_user, antimagic)

		if(CULT_SWORD_AFTERATTACK)
			possessed_cult_blade_afterattack(M, L, C, H, user, L_user, antimagic)


/obj/item/melee/cultblade/proc/possessed_cult_blade_objattack(obj/O, mob/user)

	if(!possessed) //Sanity check
		return FALSE

	if(!iscultist(user)) //Only the chosen may wield this power
		return FALSE

	switch(possessed)
		if(CULT_DESTRUCTION_SWORD)
			if(force * 2 < damage_deflection)
				return FALSE
			O.take_damage(force * 2, BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir = null, armour_penetration = 100)
			return TRUE

	return FALSE

/turf/closed/wall/proc/possessed_cult_blade_wallattack(obj/item/W, mob/user)
	if(!istype(W, /obj/item/melee/cultblade))
		return

	if(!iscultist(user)) //Only the chosen may wield this power
		return FALSE

	var/obj/item/melee/cultblade/C = W

	if(C.possessed != CULT_DESTRUCTION_SWORD) //Sanity check
		return FALSE

	if(C.cooldown)
		to_chat(user, "<span class='cult'><b>[W]'s power is currently depleted, and cannot yet smash through [src].</b></span>")
		return FALSE

	if(locate(/obj/effect/blessing, src)) //We can't smash consecrated walls
		to_chat(user, "<span class='cult'><b>[src] is warded against the power of the Geometer; [W] cannot break it!</b></span>")
		return FALSE

	new /obj/effect/temp_visual/cult/sparks(loc)
	playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
	dismantle_wall(1)
	user.visible_message("<span class='cult'><b>[src] is smashed apart by the raw might of [W]!</b></span>")

	var/cooldown_seconds = (hardness >= 40 ? CULT_DESTRUCTION_LOW_COOLDOWN : CULT_DESTRUCTION_HIGH_COOLDOWN) //30 seconds of cooldown per reinforced wall, 5 for a regular wall
	addtimer(CALLBACK(C, /obj/item/melee/cultblade.proc/cult_sword_cooldown_end), cooldown_seconds)


/obj/item/melee/cultblade/proc/possessed_cult_blade_afterattack(mob/M, mob/living/L, mob/living/carbon/C, mob/living/carbon/human/H, mob/user, mob/living/L_user, antimagic = FALSE)

	if(!possessed) //Sanity check
		return FALSE

	if(!iscultist(user)) //Only the chosen may wield this power
		return FALSE

	switch(possessed)
		if(CULT_BLOOD_SWORD)
			return FALSE

		if(CULT_LIFEEATER_SWORD)
			return FALSE

		if(CULT_CORRUPTION_SWORD) //Spawn an SS and capture the target's soul if we killed it
			if(!M)
				return

			if(M.stat != DEAD)
				return

			if(!M.mind)
				return

			var/obj/item/soulstone/SS = new /obj/item/soulstone(get_turf(H))
			SS.attack(H, user)
			if(!LAZYLEN(SS.contents))
				qdel(SS)

		if(CULT_PESTILENCE_SWORD)
			return FALSE

		if(CULT_FAMINE_SWORD)
			return FALSE

		if(CULT_HELLFIRE_SWORD)
			return FALSE

		if(CULT_HELLFROST_SWORD)
			return FALSE

		if(CULT_CHAOS_SWORD)
			return FALSE

		if(CULT_MADNESS_SWORD)
			return FALSE

		if(CULT_AGONY_SWORD)
			return FALSE

		if(CULT_VORPAL_SWORD) //No special effects on hit.
			return FALSE

		if(CULT_WARDING_SWORD) //No special effects on hit.
			return FALSE

		if(CULT_DEVOURING_SWORD)
			return FALSE

		if(CULT_HEARTSEEKER_SWORD) //No special effects on hit.
			return FALSE

		if(CULT_BRUTAL_SWORD) //No special effects on hit.
			return FALSE

		if(CULT_DESTRUCTION_SWORD) //No special effects on hit.
			return FALSE


/obj/item/melee/cultblade/proc/possessed_cult_blade_attack(mob/M, mob/living/L, mob/living/carbon/C, mob/living/carbon/human/H, mob/user, mob/living/L_user, antimagic = FALSE)

	if(!possessed) //Sanity check
		return FALSE

	if(!iscultist(user)) //Only the chosen may wield this power
		return FALSE

	switch(possessed)
		if(CULT_BLOOD_SWORD) //Drains 50U blood and causes rapid bleeding on hit.
			if(antimagic)
				return FALSE
			if(!C)
				return FALSE
			if(!C.blood_volume)
				return FALSE
			new /obj/effect/temp_visual/cult/sparks(M.loc)
			if(H)
				H.bleed_rate = CLAMP(H.bleed_rate + 5, 5, 20)
			C.bleed(CULT_BLOOD_SWORD_BLOOD_LOSS)
			to_chat(C, pick("<b><span class='danger'>Blood hemorrhages from your wound!</span>","<span class='danger'>Blood gushes uncontrollably from your body!</span>","<span class='danger'>Your injuries erupt in blood!</span></b>"))
			playsound(get_turf(C), 'sound/magic/exit_blood.ogg', 50, TRUE)
			add_mob_blood(C)
			var/turf/location = get_turf(C)
			C.add_splatter_floor(location)
			if(get_dist(user, C) <= 1)	//people with TK won't get smeared with blood
				user.add_mob_blood(src)
			var/obj/item/bodypart/affecting = C.get_bodypart(ran_zone(user.zone_selected))
			if(affecting.body_zone == BODY_ZONE_HEAD)
				if(C.wear_mask)
					C.wear_mask.add_mob_blood(C)
					C.update_inv_wear_mask()
				if(C.wear_neck)
					C.wear_neck.add_mob_blood(C)
					C.update_inv_neck()
				if(C.head)
					C.head.add_mob_blood(C)
					C.update_inv_head()

			playsound(get_turf(C), 'sound/effects/splat.ogg', 50, TRUE)

		if(CULT_LIFEEATER_SWORD) //Restores 40% of force.
			if(M.stat == DEAD) //Can't vampirize the dead.
				return
			if(!L_user)
				return
			if(L_user.getBruteLoss())
				L_user.Beam(M, icon_state="blood",time=CULT_LIFEEATER_SWORD_EFFECT_TIME)
				new /obj/effect/temp_visual/cult/sparks(L_user.loc)
				new /obj/effect/temp_visual/cult/sparks(M.loc)
				L_user.visible_message("<span class='warning'>[L_user]'s [pick("wounds inexplicably knit and close", "torn flesh seems to repair itself", "body eerily mends together")].</span>")
				L_user.adjustBruteLoss(-force * 0.4)

		if(CULT_CORRUPTION_SWORD)
			if(antimagic)
				return FALSE
			new /obj/effect/temp_visual/cult/sparks(M.loc)
			if(M.reagents)
				M.reagents.add_reagent(/datum/reagent/fuel/unholywater, CULT_CORRUPTION_SWORD_UNHOLY_WATER)

		if(CULT_PESTILENCE_SWORD) //Inflict Unholy Blight on a 30 second cooldown.
			if(L)
				L.apply_damage(CULT_PESTILENCE_SWORD_TOXIN_DAMAGE, TOX)
			if(antimagic)
				return FALSE

			if(cooldown)
				return FALSE

			new /obj/effect/temp_visual/revenant(M.loc)
			if(H)
				if(H.dna && H.dna.species)
					H.dna.species.handle_hair(H,"#1d2953") //will be reset when blight is cured
				var/blightfound = FALSE
				for(var/datum/disease/revblight/blight in H.diseases)
					blightfound = TRUE
					if(blight.stage < 5)
						blight.stage++
				if(!blightfound)
					H.ForceContractDisease(new /datum/disease/revblight(), FALSE, TRUE)
					H.playsound_local(get_turf(H.loc), 'sound/effects/ghost.ogg', 50, FALSE, pressure_affected = FALSE)
					to_chat(H, "<span class='cult'><b>You feel [pick("suddenly sick", "a surge of nausea", "like your skin is <i>wrong</i>")].</span></b>")
			else
				if(M.reagents)
					M.reagents.add_reagent(/datum/reagent/toxin/plasma, 5)

			cult_sword_cooldown_start(user, CULT_PESTILENCE_SWORD_COOLDOWN)

		if(CULT_FAMINE_SWORD) //Drains 200 nutrition and injects 20U lipocide on hit.
			if(antimagic)
				return FALSE
			if(L)
				L.apply_damage(CULT_FAMINE_SWORD_TOXIN_DAMAGE, TOX)
			new /obj/effect/temp_visual/cult/sparks(M.loc)
			M.adjust_nutrition(CULT_FAMINE_SWORD_NUTRITION_LOSS)
			if(M.reagents)
				M.reagents.add_reagent(/datum/reagent/toxin/lipolicide, CULT_FAMINE_SWORD_LIPOCIDE)

		if(CULT_HELLFIRE_SWORD) //Adds 3 fire stacks on hit and ignites; applies 5U phlogiston
			if(antimagic)
				return FALSE
			new /obj/effect/temp_visual/cult/sparks(M.loc)
			if(M.reagents)
				M.reagents.add_reagent(/datum/reagent/phlogiston, CULT_HELLFIRE_SWORD_PHLOGISTON)
			if(L)
				L.fire_stacks = max(3, L.fire_stacks + 3)
				L.IgniteMob()

		if(CULT_HELLFROST_SWORD)  //Dramatically reduces temperature and injects 10U frost oil on hit.
			if(antimagic)
				return FALSE
			new /obj/effect/temp_visual/cult/sparks(M.loc)
			var/cooling = -100 * TEMPERATURE_DAMAGE_COEFFICIENT
			M.adjust_bodytemperature(cooling, 50)
			if(M.reagents)
				M.reagents.add_reagent(/datum/reagent/consumable/frostoil, CULT_HELLFROST_SWORD_FROST_OIL)

		if(CULT_CHAOS_SWORD) //Inflicts 2 to 80 damage of a random type from fire, tox and brute.

			damtype = pick("fire","tox", "brute") //random damage type
			var/rand1 = rand(0,40)
			var/rand2 = rand(0,40)
			force = rand1 + rand2 //0-80 damage

			if(rand1 != rand2) //If both rolls match, fire a chaos bolt at the victim
				return

			if(!M)
				return

			if(M == user)
				return


			visible_message("<span class='danger'><b>Strange magics suddenly surge from [src]!</b></span>")
			playsound(get_turf(M), 'sound/magic/staff_chaos.ogg', 65, TRUE)
			new /obj/effect/temp_visual/cult/sparks(loc)
			var/obj/projectile/magic/chaos_bolt = pick(GLOB.cult_chaos_sword_projectiles)
			var/obj/projectile/magic/P = new chaos_bolt(user.loc)
			P.firer = user
			P.preparePixelProjectile(M, user)
			P.fire()


		if(CULT_MADNESS_SWORD) //Causes brain damage, confusion and hallucinations on hit.
			if(antimagic) //Anti-magic is effective
				return FALSE
			new /obj/effect/temp_visual/cult/sparks(M.loc)
			if(L)
				L.confused = max(force * 0.5, L.confused)
			if(C)
				C.apply_damage(force, BRAIN)
				C.hallucination += CULT_MADNESS_SWORD_HALLUCINATION
				to_chat(C, pick("<span class='danger'>Your mind reels.</span>","<span class='danger'>Your vision seethes and contorts.</span>","<span class='danger'>Reality seems to come apart!</span>"))

		if(CULT_AGONY_SWORD) //Causes signficant stamina damage and some disorientation on hit.
			if(antimagic) //Anti-magic is effective
				return FALSE
			new /obj/effect/temp_visual/cult/sparks(M.loc)
			if(L)
				L.Jitter(20)
				L.confused = max(10, L.confused)
				L.stuttering = max(8, L.stuttering)
				L.apply_damage(CULT_AGONY_SWORD_STAMINA_DAMAGE, STAMINA)

		if(CULT_VORPAL_SWORD) //No special effects on hit.
			return

		if(CULT_WARDING_SWORD) //No special effects on hit.
			return

		if(CULT_DEVOURING_SWORD) //Deals 50% more damage in exchange for 10% self damage.
			if(M.stat == DEAD) //We aren't penalized for attacking the dead.
				return
			if(L_user)
				new /obj/effect/temp_visual/cult/sparks(L_user)
				L.adjustBruteLoss(force * 0.5) //With great power comes great self-damage
				L_user.adjustBruteLoss(force * 0.1) //With great power comes great self-damage
				if(prob(50))
					to_chat(C, pick("<span class='cult'><b>You feel your lifeforce drawn into [src]!</b></span>","<span class='cult'><b>You feel [src] feed on your vitality.</b></span>","<span class='cult'><b>You feel drained as [src] channels your life blood!</b></span>"))

		if(CULT_HEARTSEEKER_SWORD) //No special effects on hit.
			return

		if(CULT_BRUTAL_SWORD) //Blows a target away after a moderate cooldown, imposing the effects of an explosion
			if(antimagic) //Anti-magic is effective
				return FALSE

			if(cooldown)
				return FALSE

			if(L)
				L.apply_damage(force, BRUTE)

			var/atom/throw_target = get_edge_target_turf(M, user.dir)
			M.throw_at(throw_target, rand(8,10), 14, user)
			visible_message("<span class='danger'>[M] is smitten by a blast of eldritch power!</span>")
			new /obj/effect/temp_visual/cult/sparks(M.loc)
			playsound(get_turf(M), 'sound/magic/repulse.ogg', 65, TRUE)
			cult_sword_cooldown_start(user, CULT_BRUTAL_SWORD_COOLDOWN)

		if(CULT_DESTRUCTION_SWORD) //No special effects on hit.
			if(antimagic) //Anti-magic is effective
				return FALSE

			if(!issilicon(L)) //Double damage to silicons only
				return

			L.apply_damage(force, BRUTE)




/obj/item/melee/cultblade/proc/cult_sword_cooldown_start(mob/user, cooldown_seconds)
	if(cooldown)
		return FALSE
	addtimer(CALLBACK(src, /obj/item/melee/cultblade.proc/cult_sword_cooldown_end), cooldown_seconds)
	to_chat(user, "<span class='cult'><b>[src]'s power is depleted and will take [cooldown_seconds * 0.1] seconds to recharge!</b></span>")
	cooldown = TRUE

/obj/item/melee/cultblade/proc/cult_sword_cooldown_end()
	if(!cooldown)
		return FALSE
	cooldown = FALSE
	var/mob/M
	if(ismob(loc))
		M = loc
	if(M && iscultist(M))
		playsound(get_turf(M), 'sound/magic/clockwork/narsie_attack.ogg',  get_clamped_volume(), TRUE, -1)
		to_chat(M, "<span class='cultlarge'>[src] has recharged!</span>")
	new /obj/effect/temp_visual/cult/sparks(loc)

/obj/item/melee/cultblade/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(possessed == CULT_HEARTSEEKER_SWORD)
		if(isliving(thrownby))
			var/mob/living/L = thrownby
			if(!iscultist(L))
				return
			forceMove(get_turf(L))
			new /obj/effect/temp_visual/cult/sparks(loc)
			if(L.put_in_active_hand(src))
				L.visible_message("<span class='warning'>[src] suddenly materializes in [L]'s hand!</span>")
			else
				L.visible_message("<span class='warning'>[src] suddenly rematerializes at [L]'s feet!</span>")


/obj/item/melee/cultblade/attack_self(mob/living/user) //The proc we use to summon and bind the daemon into the sword.
	. = ..()

	if(!empowered) //We need to be empowered by any sacrifice.
		to_chat(user, "<span class='cult'><b>This weapon must first be empowered by a proper sacrifice in order to bind a daemon!<b></span>")
		return

	if(possessed)
		return

	var/obj/effect/rune/empower/rune = FALSE //We need an empowering rune
	for(var/obj/effect/rune/empower/R in range(1, user))
		rune = R
		break

	if(!rune)
		to_chat(user, "<span class='cult'><b>Without an empowering rune, you lack the strength to bind a daemon to [src]...<b></span>")
		return

	var/datum/beam/B = user.Beam(rune,icon_state="blood",time=INFINITY) //cool sfx
	to_chat(user, "<span class='cult'><b>You begin carve your flesh in blood tithe, and attempt to bind a daemon to [src]...<b></span>")
	playsound(get_turf(user), 'sound/weapons/slice.ogg', 30, TRUE)

	if(!do_after(user, CULT_SWORD_SUMMON_DELAY, target = user))
		qdel(B) //Get rid of the beam SFX
		return

	if(iscarbon(user))
		var/mob/living/carbon/H = user
		H.bleed(10)

	qdel(B) //Get rid of the beam SFX
	to_chat(user, "<span class='cult'><b>The blood tithe is paid; all that remains is to wait for a daemon to heed your call...<b></span>")
	playsound(get_turf(loc), 'sound/spookoween/ghost_whisper.ogg', 100, TRUE)

	possessed = TRUE //Set to true for now so we don't spam multiple attempts simultaneously.


	var/list/mob/dead/observer/candidates = pollGhostCandidates("Do you want to play as the bound daemon of [user.real_name]'s [src]?", ROLE_PAI, null, FALSE, 100, POLL_IGNORE_POSSESSED_BLADE)

	if(!LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		var/mob/living/simple_animal/shade/S = new(src)
		S.ckey = C.ckey
		S.fully_replace_character_name(null, "The bound daemon of [name]")
		S.status_flags |= GODMODE
		S.language_holder = user.language_holder.copy(S)
		SSticker.mode.add_cultist(S.mind, FALSE)
		S.mind.special_role = ROLE_CULTIST
		S.playsound_local(get_turf(S.loc), 'sound/ambience/antag/bloodcult.ogg', 100, FALSE, pressure_affected = FALSE)
		to_chat(user, "<span class='cultlarge'>Go forth my daemon, and aid this pitiful supplicant...")
		to_chat(S, "<span class='cult italic'><b>You are a daemonic spirit summoned from the hellish realm of your master Nar'sie, the Geometer of Blood. A supplicant of the great Geometer has bound you into an eldritch blade you now empower and inhabit. You will aid the cult in heralding the return of your master.\
		</b></span>")
		var/sword_name = sanitize_name(stripped_input(S,"What are you named?", ,"", MAX_NAME_LEN))

		if(src)
			if(!sword_name) //If we didn't pick a name, we get a generic one instead
				name = "possessed [name]"
			else
				name = sword_name

			S.fully_replace_character_name(null, "The bound daemon of [sword_name]")
			possessor = user

			var/list/powerlist = list("Blood (Purges its victim's blood.)" = CULT_BLOOD_SWORD, \
			"Life Eater (Drains health, healing brute damage.)" = CULT_LIFEEATER_SWORD, \
			"Corruption (Blights the enemy.)" = CULT_CORRUPTION_SWORD, \
			"Pestilence (Inflicts disease on a cooldown.)" = CULT_PESTILENCE_SWORD, \
			"Famine (Drains massive amounts of nutrition.)" = CULT_FAMINE_SWORD, \
			"Hellfire (Imposes burn stacks and ignites on hit.)" = CULT_HELLFIRE_SWORD, \
			"Hellfrost (Lower's target's temperature greatly.)" = CULT_HELLFROST_SWORD, \
			"Chaos (Deals 0-80 damage of a random type.)" = CULT_CHAOS_SWORD, \
			"Madness (Inflicts brain damage and hallucinations.)" = CULT_MADNESS_SWORD, \
			"Agony (Inflicts stamina damage and staggering.)" = CULT_AGONY_SWORD, \
			"Piercing (Deals extra damage. Ignores armor.)" = CULT_VORPAL_SWORD, \
			"Warding (Grants 50% deflection.)" = CULT_WARDING_SWORD, \
			"Devouring (Deals extra damage to user and its target.)" = CULT_DEVOURING_SWORD, \
			"Returning (Deals extra damage and returns on throw.)" = CULT_HEARTSEEKER_SWORD, \
			"Destruction (Destroys walls. Does massive damage to silicons/objects.)" = CULT_DESTRUCTION_SWORD, \
			"Brutality (Smites and knocks back on a cooldown.)" = CULT_BRUTAL_SWORD)
			var/infusion = input(S, "Choose your enchantment.", "Enchantments", null) as null|anything in powerlist
			if(!infusion)
				return

			possessed = powerlist[infusion]
			desc = "A sword humming with unholy energy."
			icon = 'icons/Fulpicons/cult_swords/cult_swords.dmi' //Shiny new icons
			armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100) //Daemonic swords are practically indestructible
			resistance_flags = FIRE_PROOF | ACID_PROOF | LAVA_PROOF //Daemonic swords are practically indestructible
			switch(possessed)
				if(CULT_BLOOD_SWORD)
					desc += " This one has an incarnadine, bloody glow."
					icon_state = "cult_blood_sword"
				if(CULT_CORRUPTION_SWORD)
					desc += " Writhing tendrils of crimson and black twist about its imposing form."
					icon_state = "cult_corruption_sword"
				if(CULT_LIFEEATER_SWORD)
					desc += " This one flickers with a bleak, thirsting blackness."
					icon_state = "cult_lifeeater_sword"
				if(CULT_PESTILENCE_SWORD)
					desc += " This one seems to buzz with flies, dripping with sickly green virulence."
					icon_state = "cult_pestilence_sword"
					force = 21 //Just enough to destroy standard airlocks.
				if(CULT_FAMINE_SWORD)
					desc += " This one clatters with the phantom gnashing and chittering of hungry teeth."
					icon_state = "cult_famine_sword"
					force = 21 //Just enough to destroy standard airlocks.
				if(CULT_HELLFIRE_SWORD)
					desc += " This one seethes hotly with scalding orange flames."
					icon_state = "cult_hellfire_sword"
					damtype = "fire"
					if(loc == user)
						equipped(user) //Add combust immunity if we are holding the blade.
				if(CULT_HELLFROST_SWORD)
					desc += " This one shudders like a living thing, its length rimed with cobalt ice."
					icon_state = "cult_hellfrost_sword"
					damtype = "fire"
				if(CULT_CHAOS_SWORD)
					desc += " This one flickers and pulses with prismatic, shifting light, its length appearing to waver uncontrollably."
					icon_state = "cult_chaos_sword"
				if(CULT_MADNESS_SWORD)
					desc += " This one appears to be in several places at once, traced by after-images and auras of roiling violet."
					icon_state = "cult_madness_sword"
					hitsound = 'sound/effects/curseattack.ogg'
					force = 21 //Just enough to destroy standard airlocks.
				if(CULT_AGONY_SWORD)
					desc += " This one reverberates wildly, screaming faces forming and dissipating along its length."
					icon_state = "cult_agony_sword"
					force = 21 //Just enough to destroy standard airlocks.
				if(CULT_VORPAL_SWORD)
					desc += " This one is eerily translucent and preternaturally sharp, appearing almost to vanish when turned to its side."
					icon_state = "cult_vorpal_sword"
					force = 33
					armour_penetration = 100
					alpha = 128
					sharpness = IS_SHARP_ACCURATE
				if(CULT_WARDING_SWORD)
					desc += " Reality seems to strangely twist and contort about its blade."
					icon_state = "cult_warding_sword"
					block_chance = 50
				if(CULT_DEVOURING_SWORD)
					desc += " The faint sound of crunching fangs and vicious snarls emanate from this weapon."
					icon_state = "cult_devouring_sword"
				if(CULT_HEARTSEEKER_SWORD)
					desc += " This one is streamlined and thin, scintillating with baleful light."
					icon_state = "cult_heartseeker_sword"
					throwforce = 20 //So we can't break most airlocks at range. Still hurts though, and gives you a strong ranged option.
					throw_range = 7
					throw_speed = 3
				if(CULT_DESTRUCTION_SWORD)
					desc += " This one's graven red length whispers of ruin and destruction."
					force = 33
					icon_state = "cult_destruction_sword"
				if(CULT_BRUTAL_SWORD)
					desc += " This one is clad in eldritch runes that pulse with scarcely contained power."
					icon_state = "cult_brutal_sword"

			new /obj/effect/temp_visual/cult/sparks(loc)
			playsound(get_turf(loc), 'sound/magic/demon_dies.ogg', 100, TRUE)
			update_atom_colour()
			to_chat(user, "<span class='cultlarge'>Rejoice supplicant, for you have been found worthy of my daemon's aid. Feed it well...")

	else
		to_chat(user, "<span class='cultlarge'>No daemon finds your blade a worthy vessel for slaughter. You may petition them later...")
		possessed = FALSE
