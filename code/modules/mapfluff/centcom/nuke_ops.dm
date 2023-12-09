//keycards
/obj/item/keycard/syndicate_bomb
	name = "Syndicate Ordnance Laboratory Access Card"
	desc = "A red keycard with an image of a bomb. Using this will allow you to gain access to the Ordnance Lab in Firebase Balthazord."
	color = "#9c0e26"
	puzzle_id = "syndicate_bomb"

/obj/item/keycard/syndicate_bio
	name = "Syndicate Bio-Weapon Laboratory Access Card"
	desc = "A red keycard with a biohazard symbol. Using this will allow you to gain access to the Bio-Weapon Lab in Firebase Balthazord."
	color = "#9c0e26"
	puzzle_id = "syndicate_bio"

/obj/item/keycard/syndicate_chem
	name = "Syndicate Chemical Plant Access Card"
	desc = "A red keycard with an image of a beaker. Using this will allow you to gain access to the Chemical Manufacturing Plant in Firebase Balthazord."
	color = "#9c0e26"
	puzzle_id = "syndicate_chem"

/obj/item/keycard/syndicate_fridge
	name = "Lopez's Access Card"
	desc = "A grey keycard with Lopez's Information on it. This is your ticket into the Fridge in Firebase Balthazord."
	color = "#636363"
	puzzle_id = "syndicate_fridge"

//keycard doors
/obj/machinery/door/puzzle/keycard/syndicate_bomb
	name = "Syndicate Ordinance Laboratory"
	desc = "Locked. Looks like you'll need a special access key to get in."
	puzzle_id = "syndicate_bomb"

/obj/machinery/door/puzzle/keycard/syndicate_bio
	name = "Syndicate Bio-Weapon Laboratory"
	desc = "Locked. Looks like you'll need a special access key to get in."
	puzzle_id = "syndicate_bio"

/obj/machinery/door/puzzle/keycard/syndicate_chem
	name = "Syndicate Chemical Manufacturing Plant"
	desc = "Locked. Looks like you'll need a special access key to get in"
	puzzle_id = "syndicate_chem"

/obj/machinery/door/puzzle/keycard/syndicate_fridge
	name = "The Walk-In Fridge"
	desc = "Locked. Lopez sure runs a tight galley."
	puzzle_id = "syndicate_fridge"

/// Used on the syndicate infiltrator. Warps the syndiecomms machinery to itself, then qdels. Please don't use this anywhere else, unless you plan on gutting the one that exists there!
/obj/effect/syndiecomms_spawn_helper
	name = "SyndieComms \"Spawn\" Helper"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "syndiecomms_spawn"

/obj/effect/syndiecomms_spawn_helper/Initialize(mapload)
	. = ..()
	var/obj/machinery/telecomms/allinone/nuclear/our_array = locate() in SSmachines.get_machines_by_type(/obj/machinery/telecomms/allinone/nuclear)
	our_array.forceMove(loc)
	qdel(src)
