//airlock helpers
/obj/effect/mapping_helpers/airlock
	layer = DOOR_HELPER_LAYER
	late = TRUE

/obj/effect/mapping_helpers/airlock/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return

	var/obj/machinery/door/airlock/airlock = locate(/obj/machinery/door/airlock) in loc
	if(!airlock)
		log_mapping("[src] failed to find an airlock at [AREACOORD(src)]")
	else
		payload(airlock)

/obj/effect/mapping_helpers/airlock/LateInitialize()
	. = ..()
	var/obj/machinery/door/airlock/airlock = locate(/obj/machinery/door/airlock) in loc
	if(!airlock)
		qdel(src)
		return
	if(airlock.cyclelinkeddir)
		airlock.cyclelinkairlock()
	if(airlock.closeOtherId)
		airlock.update_other_id()
	if(airlock.abandoned)
		var/outcome = rand(1,100)
		switch(outcome)
			if(1 to 9)
				var/turf/here = get_turf(src)
				for(var/turf/closed/T in range(2, src))
					here.PlaceOnTop(T.type)
					qdel(airlock)
					qdel(src)
					return
				here.PlaceOnTop(/turf/closed/wall)
				qdel(airlock)
				qdel(src)
				return
			if(9 to 11)
				airlock.lights = FALSE
				// These do not use airlock.bolt() because we want to pretend it was always locked. That means no sound effects.
				airlock.locked = TRUE
			if(12 to 15)
				airlock.locked = TRUE
			if(16 to 23)
				airlock.welded = TRUE
			if(24 to 30)
				airlock.set_panel_open(TRUE)
	if(airlock.cutAiWire)
		airlock.wires.cut(WIRE_AI)
	if(airlock.autoname)
		airlock.name = get_area_name(src, TRUE)
	airlock.update_appearance()
	qdel(src)

/obj/effect/mapping_helpers/airlock/proc/payload(obj/machinery/door/airlock/payload)
	return

/obj/effect/mapping_helpers/airlock/cyclelink_helper
	name = "airlock cyclelink helper"
	icon_state = "airlock_cyclelink_helper"

/obj/effect/mapping_helpers/airlock/cyclelink_helper/payload(obj/machinery/door/airlock/airlock)
	if(airlock.cyclelinkeddir)
		log_mapping("[src] at [AREACOORD(src)] tried to set [airlock] cyclelinkeddir, but it's already set!")
	else
		airlock.cyclelinkeddir = dir

/obj/effect/mapping_helpers/airlock/cyclelink_helper_multi
	name = "airlock multi-cyclelink helper"
	icon_state = "airlock_multicyclelink_helper"
	var/cycle_id

/obj/effect/mapping_helpers/airlock/cyclelink_helper_multi/payload(obj/machinery/door/airlock/airlock)
	if(airlock.closeOtherId)
		log_mapping("[src] at [AREACOORD(src)] tried to set [airlock] closeOtherId, but it's already set!")
	else if(!cycle_id)
		log_mapping("[src] at [AREACOORD(src)] doesn't have a cycle_id to assign to [airlock]!")
	else
		airlock.closeOtherId = cycle_id

/obj/effect/mapping_helpers/airlock/locked
	name = "airlock lock helper"
	icon_state = "airlock_locked_helper"

/obj/effect/mapping_helpers/airlock/locked/payload(obj/machinery/door/airlock/airlock)
	if(airlock.locked)
		log_mapping("[src] at [AREACOORD(src)] tried to bolt [airlock] but it's already locked!")
	else
		// Used instead of bolt so that we can pretend it was always locked, i.e. no sound effects on init.
		airlock.locked = TRUE

/obj/effect/mapping_helpers/airlock/unres
	name = "airlock unrestricted side helper"
	icon_state = "airlock_unres_helper"

/obj/effect/mapping_helpers/airlock/unres/payload(obj/machinery/door/airlock/airlock)
	airlock.unres_sides ^= dir
	airlock.unres_sensor = TRUE

/obj/effect/mapping_helpers/airlock/abandoned
	name = "airlock abandoned helper"
	icon_state = "airlock_abandoned"

/obj/effect/mapping_helpers/airlock/abandoned/payload(obj/machinery/door/airlock/airlock)
	if(airlock.abandoned)
		log_mapping("[src] at [AREACOORD(src)] tried to make [airlock] abandoned but it's already abandoned!")
	else
		airlock.abandoned = TRUE

/obj/effect/mapping_helpers/airlock/welded
	name = "airlock welded helper"
	icon_state = "airlock_welded"

/obj/effect/mapping_helpers/airlock/welded/payload(obj/machinery/door/airlock/airlock)
	if(airlock.welded)
		log_mapping("[src] at [AREACOORD(src)] tried to make [airlock] welded but it's already welded closed!")
	airlock.welded = TRUE

/obj/effect/mapping_helpers/airlock/cutaiwire
	name = "airlock cut ai wire helper"
	icon_state = "airlock_cutaiwire"

/obj/effect/mapping_helpers/airlock/cutaiwire/payload(obj/machinery/door/airlock/airlock)
	if(airlock.cutAiWire)
		log_mapping("[src] at [AREACOORD(src)] tried to cut the ai wire on [airlock] but it's already cut!")
	else
		airlock.cutAiWire = TRUE

/obj/effect/mapping_helpers/airlock/autoname
	name = "airlock autoname helper"
	icon_state = "airlock_autoname"

/obj/effect/mapping_helpers/airlock/autoname/payload(obj/machinery/door/airlock/airlock)
	if(airlock.autoname)
		log_mapping("[src] at [AREACOORD(src)] tried to autoname the [airlock] but it's already autonamed!")
	else
		airlock.autoname = TRUE
