//Detective Goggles

#define MODE_NONE ""
#define MODE_MESON "meson"
#define MODE_TRAY "t-ray"
#define MODE_RAD "radiation"
#define MODE_SHUTTLE "shuttle"

/obj/item/clothing/glasses/detective
	name = "engineering scanner goggles"
	desc = "Goggles used by detctives. The Meson Scanner mode lets you see basic structural and terrain layouts through walls, the T-ray Scanner mode lets you see underfloor objects such as cables and pipes, and the Radiation Scanner mode lets you see objects contaminated by radiation."
	icon_state = "trayson-meson"
	item_state = "trayson-meson"
	actions_types = list(/datum/action/item_action/toggle_mode)

	vision_flags = NONE
	darkness_view = 2
	invis_view = SEE_INVISIBLE_LIVING

	var/list/modes = list(MODE_NONE = MODE_MESON, MODE_MESON = MODE_TRAY, MODE_TRAY = MODE_RAD, MODE_RAD = MODE_NONE)
	var/mode = MODE_NONE
	var/range = 1

	hud_type = DATA_HUD_SECURITY_ADVANCED
	hud_trait = TRAIT_SECURITY_HUD

	clothing_flags = SCAN_REAGENTS //You can see reagents while wearing detective goggles
	resistance_flags = ACID_PROOF
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 100)

/obj/item/clothing/glasses/detective/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/clothing/glasses/detective/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/glasses/detective/proc/toggle_mode(mob/user, voluntary)
	mode = modes[mode]
	to_chat(user, "<span class='[voluntary ? "notice":"warning"]'>[voluntary ? "You turn the goggles":"The goggles turn"] [mode ? "to [mode] mode":"off"][voluntary ? ".":"!"]</span>")

	switch(mode)
		if(MODE_MESON)
			vision_flags = SEE_TURFS
			darkness_view = 1
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE

		if(MODE_TRAY) //undoes the last mode, meson
			vision_flags = NONE
			darkness_view = 2
			lighting_alpha = null

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.glasses == src)
			H.update_sight()

	update_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/glasses/detective/attack_self(mob/user)
	toggle_mode(user, TRUE)

/obj/item/clothing/glasses/detective/process()
	if(!ishuman(loc))
		return
	var/mob/living/carbon/human/user = loc
	if(user.glasses != src || !user.client)
		return
	switch(mode)
		if(MODE_TRAY)
			t_ray_scan(user, 8, range)
		if(MODE_RAD)
			show_rads()
		if(MODE_SHUTTLE)
			show_shuttle()

/obj/item/clothing/glasses/detective/proc/show_rads()
	var/mob/living/carbon/human/user = loc
	var/list/rad_places = list()
	for(var/datum/component/radioactive/thing in SSradiation.processing)
		var/atom/owner = thing.parent
		var/turf/place = get_turf(owner)
		if(rad_places[place])
			rad_places[place] += thing.strength
		else
			rad_places[place] = thing.strength

	for(var/i in rad_places)
		var/turf/place = i
		if(get_dist(user, place) >= range*2)	//Rads are easier to see than wires under the floor
			continue
		var/strength = round(rad_places[i] / 1000, 0.1)
		var/image/pic = new(loc = place)
		var/mutable_appearance/MA = new()
		MA.alpha = 180
		MA.maptext = "[strength]k"
		MA.color = "#64C864"
		MA.layer = FLY_LAYER
		pic.appearance = MA
		flick_overlay(pic, list(user.client), 8)

/obj/item/clothing/glasses/detective/proc/show_shuttle()
	var/mob/living/carbon/human/user = loc
	var/obj/docking_port/mobile/port = SSshuttle.get_containing_shuttle(user)
	if(!port)
		return
	var/list/shuttle_areas = port.shuttle_areas
	for(var/r in shuttle_areas)
		var/area/region = r
		for(var/turf/place in region.contents)
			if(get_dist(user, place) > 7)
				continue
			var/image/pic
			if(isshuttleturf(place))
				pic = new('icons/turf/overlays.dmi', place, "greenOverlay", AREA_LAYER)
			else
				pic = new('icons/turf/overlays.dmi', place, "redOverlay", AREA_LAYER)
			flick_overlay(pic, list(user.client), 8)

/obj/item/clothing/glasses/detective/update_icon()
	icon_state = "trayson-[mode]"
	update_mob()

/obj/item/clothing/glasses/detective/proc/update_mob()
	item_state = icon_state
	if(isliving(loc))
		var/mob/living/user = loc
		if(user.get_item_by_slot(SLOT_GLASSES) == src)
			user.update_inv_glasses()
		else
			user.update_inv_hands()

#undef MODE_NONE
#undef MODE_MESON
#undef MODE_TRAY
#undef MODE_RAD
#undef MODE_SHUTTLE
