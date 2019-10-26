/obj/item/storage/belt/pouch // This is the base pouch which is not used in-game.
	name = "a pouch"
	desc = "A pouch, it holds stuff/ You shouldn't be able to get this one though."
	icon = 'icons/fulpicons/phoenix_nest/pouches.dmi'
	icon_state = "flare_pouch"
	item_state = "flare_pouch"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKET
	custom_price = 5

/obj/item/storage/belt/pouch/ComponentInitialize()
  	. = ..()
  	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
  	STR.max_items = 2
  	STR.max_w_class = WEIGHT_CLASS_SMALL

/obj/item/storage/belt/pouch/lights
	name = "emergency light pouch"
	desc = "A pouch designed to contain flares and glowsticks."
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKET
	custom_price = 20

/obj/item/storage/belt/pouch/lights/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 4 // Not gonna' let y'all hoard them for yourself. Four lights is enough.
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.set_holdable(list(
    /obj/item/flashlight/flare,
    /obj/item/flashlight/glowstick,
    /obj/item/flashlight/glowstick/military, // Military designates that Sec uses it. Lasts longer than a civilian glowstick.
    /obj/item/flashlight/glowstick/red,
    /obj/item/flashlight/glowstick/military/red,
    /obj/item/flashlight/glowstick/blue,
    /obj/item/flashlight/glowstick/cyan,
    /obj/item/flashlight/glowstick/military/cyan,
    /obj/item/flashlight/glowstick/orange,
    /obj/item/flashlight/glowstick/high/orange, // High designates that it's high power. Brighter than a civilian glowstick but lasts a bit shorter.
    /obj/item/flashlight/glowstick/ultra/orange, // Ultra designates that it's ULTRA BRIGHT and lasts a very short time. Used to light and mark dangerous areas under repair.
    /obj/item/flashlight/glowstick/yellow,
    /obj/item/flashlight/glowstick/military/yellow,
    /obj/item/flashlight/glowstick/high/white,
    /obj/item/flashlight/glowstick/pink
		))

/obj/item/storage/belt/pouch/lights/security
		name = "military light pouch"
		desc = "A military pouch issued to Security Officers that is designed to contain flares and glowsticks."
		icon_state = "flare_pouch_mili"
		item_state = "flare_pouch_mili"
		custom_price = 30
/obj/item/storage/belt/pouch/lights/security/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 4
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.set_holdable(list(
    /obj/item/flashlight/flare,
    /obj/item/flashlight/glowstick,
    /obj/item/flashlight/glowstick/military,
    /obj/item/flashlight/glowstick/red,
    /obj/item/flashlight/glowstick/military/red,
    /obj/item/flashlight/glowstick/blue,
    /obj/item/flashlight/glowstick/cyan,
    /obj/item/flashlight/glowstick/military/cyan,
    /obj/item/flashlight/glowstick/orange,
    /obj/item/flashlight/glowstick/high/orange,
    /obj/item/flashlight/glowstick/ultra/orange,
    /obj/item/flashlight/glowstick/yellow,
    /obj/item/flashlight/glowstick/military/yellow,
    /obj/item/flashlight/glowstick/high/white,
    /obj/item/flashlight/glowstick/pink
		))

/obj/item/storage/belt/pouch/firstaid
	name = "first-aid pouch"
	desc = "A small pouch for carrying compact first-aid supplies."
	icon_state = "first_aid_pouch"
	item_state = "first_aid_pouch"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKET
	custom_price = 30

/obj/item/storage/belt/pouch/firstaid/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 2
	STR.max_w_class = WEIGHT_CLASS_TINY
	STR.max_combined_w_class = 2
	STR.set_holdable(list(
		/obj/item/stack/medical/bruise_pack/compact,
		/obj/item/stack/medical/gauze/compact,
		/obj/item/stack/medical/ointment/compact
		)) // Basic first-aid supplies only. Like the desc says.

/obj/item/storage/belt/pouch/firstaid/PopulateContents()
	new /obj/item/stack/medical/bruise_pack/compact(src)
	new /obj/item/stack/medical/ointment/compact(src)


/obj/item/storage/belt/pouch/firstaid/ifak
	name = "infantry first-aid kit"
	desc = "This is an IFAK, an Infantry First-Aid Kit designed to carry compact medical supplies."
	icon_state = "ifak"
	item_state = "ifak"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKET
	custom_price = 30

/obj/item/storage/belt/pouch/firstaid/ifak/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_TINY
  STR.max_combined_w_class = 3
	STR.set_holdable(list(
		/obj/item/stack/medical/bruise_pack/compact,
		/obj/item/stack/medical/gauze/compact,
		/obj/item/stack/medical/ointment/compact,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/medigel/thin
		)) // Couple more items

/obj/item/storage/belt/pouch/firstaid/ifak/PopulateContents()
		new /obj/item/stack/medical/bruise_pack/compact(src)
		new /obj/item/stack/medical/gauze/compact(src)
		new /obj/item/stack/medical/ointment/compact(src)


/obj/item/storage/belt/pouch/medical
	name = "medical pouch"
	desc = "A small pouch designed for carrying medical supplies."
	icon_state = "medical_pouch"
	item_state = "medical_pouch"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKET
	custom_price = 30

/obj/item/storage/belt/pouch/medical/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_combined_w_class = 3
	STR.set_holdable(list(
  	/obj/item/healthanalyzer,
  	/obj/item/reagent_containers/pill,
  	/obj/item/reagent_containers/syringe,
  	/obj/item/reagent_containers/medigel,
  	/obj/item/stack/medical,
  	/obj/item/flashlight/pen,
  	/obj/item/reagent_containers/hypospray,
  	/obj/item/clothing/gloves/,
  	/obj/item/clothing/mask/surgical,
  	/obj/item/clothing/mask/breath/medical,
  	/obj/item/geiger_counter, // Sure, why not.
  	/obj/item/clothing/glasses,
  	/obj/item/clothing/mask/muzzle,
  	/obj/item/reagent_containers/hypospray
  	))

/obj/item/storage/belt/pouch/medical/cmo
	name = "\improper Chief Medical Officer's medical pouch"
	desc = "A large pouch designed to carry medical supplies."
	icon_state = "cmo_pouch"
	item_state = "cmo_pouch"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKET
	custom_price = 30

/obj/item/storage/belt/pouch/medical/cmo/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_combined_w_class = 10
	STR.set_holdable(list(
		/obj/item/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/medigel,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/flashlight/pen,
		/obj/item/reagent_containers/hypospray,
		/obj/item/sensor_device,
		/obj/item/clothing/gloves/,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/surgical_drapes,
		/obj/item/scalpel,
		/obj/item/retractor,
		/obj/item/cautery,
		/obj/item/hemostat,
		/obj/item/geiger_counter,
		/obj/item/clothing/glasses,
		/obj/item/wrench/medical,
		/obj/item/clothing/mask/muzzle,
		/obj/item/implant,
		/obj/item/implanter,
		/obj/item/pinpointer/crew,
		/obj/item/holosign_creator/medical
		))
