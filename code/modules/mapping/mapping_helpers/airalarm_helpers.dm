//air alarm helpers
/obj/effect/mapping_helpers/airalarm
	desc = "You shouldn't see this. Report it please."
	late = TRUE

/obj/effect/mapping_helpers/airalarm/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return INITIALIZE_HINT_QDEL

	var/obj/machinery/airalarm/target = locate(/obj/machinery/airalarm) in loc
	if(isnull(target))
		var/area/target_area = get_area(src)
		log_mapping("[src] failed to find an air alarm at [AREACOORD(src)] ([target_area.type]).")
	else
		payload(target)

	return INITIALIZE_HINT_LATELOAD

/obj/effect/mapping_helpers/airalarm/LateInitialize()
	. = ..()
	var/obj/machinery/airalarm/target = locate(/obj/machinery/airalarm) in loc

	if(isnull(target))
		qdel(src)
		return
	if(target.unlocked)
		target.unlock()

	if(target.tlv_cold_room)
		target.set_tlv_cold_room()
	if(target.tlv_no_checks)
		target.set_tlv_no_checks()
	if(target.tlv_no_checks && target.tlv_cold_room)
		CRASH("Tried to apply incompatible air alarm threshold helpers!")

	if(target.syndicate_access)
		target.give_syndicate_access()
	if(target.away_general_access)
		target.give_away_general_access()
	if(target.engine_access)
		target.give_engine_access()
	if(target.mixingchamber_access)
		target.give_mixingchamber_access()
	if(target.all_access)
		target.give_all_access()
	if(target.syndicate_access + target.away_general_access + target.engine_access + target.mixingchamber_access + target.all_access > 1)
		CRASH("Tried to combine incompatible air alarm access helpers!")

	if(target.air_sensor_chamber_id)
		target.setup_chamber_link()

	target.update_appearance()
	qdel(src)

/obj/effect/mapping_helpers/airalarm/proc/payload(obj/machinery/airalarm/target)
	return

/obj/effect/mapping_helpers/airalarm/unlocked
	name = "airalarm unlocked interface helper"
	icon_state = "airalarm_unlocked_interface_helper"

/obj/effect/mapping_helpers/airalarm/unlocked/payload(obj/machinery/airalarm/target)
	if(target.unlocked)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to unlock the [target] but it's already unlocked!")
	target.unlocked = TRUE

/obj/effect/mapping_helpers/airalarm/syndicate_access
	name = "airalarm syndicate access helper"
	icon_state = "airalarm_syndicate_access_helper"

/obj/effect/mapping_helpers/airalarm/syndicate_access/payload(obj/machinery/airalarm/target)
	if(target.syndicate_access)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s access to syndicate but it's already changed!")
	target.syndicate_access = TRUE

/obj/effect/mapping_helpers/airalarm/away_general_access
	name = "airalarm away access helper"
	icon_state = "airalarm_away_general_access_helper"

/obj/effect/mapping_helpers/airalarm/away_general_access/payload(obj/machinery/airalarm/target)
	if(target.away_general_access)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s access to away_general but it's already changed!")
	target.away_general_access = TRUE

/obj/effect/mapping_helpers/airalarm/engine_access
	name = "airalarm engine access helper"
	icon_state = "airalarm_engine_access_helper"

/obj/effect/mapping_helpers/airalarm/engine_access/payload(obj/machinery/airalarm/target)
	if(target.engine_access)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s access to engine_access but it's already changed!")
	target.engine_access = TRUE

/obj/effect/mapping_helpers/airalarm/mixingchamber_access
	name = "airalarm mixingchamber access helper"
	icon_state = "airalarm_mixingchamber_access_helper"

/obj/effect/mapping_helpers/airalarm/mixingchamber_access/payload(obj/machinery/airalarm/target)
	if(target.mixingchamber_access)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s access to mixingchamber_access but it's already changed!")
	target.mixingchamber_access = TRUE

/obj/effect/mapping_helpers/airalarm/all_access
	name = "airalarm all access helper"
	icon_state = "airalarm_all_access_helper"

/obj/effect/mapping_helpers/airalarm/all_access/payload(obj/machinery/airalarm/target)
	if(target.all_access)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s access to all_access but it's already changed!")
	target.all_access = TRUE

/obj/effect/mapping_helpers/airalarm/tlv_cold_room
	name = "airalarm cold room tlv helper"
	icon_state = "airalarm_tlv_cold_room_helper"

/obj/effect/mapping_helpers/airalarm/tlv_cold_room/payload(obj/machinery/airalarm/target)
	if(target.tlv_cold_room)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s tlv to cold_room but it's already changed!")
	target.tlv_cold_room = TRUE

/obj/effect/mapping_helpers/airalarm/tlv_no_checks
	name = "airalarm no checks tlv helper"
	icon_state = "airalarm_tlv_no_checks_helper"

/obj/effect/mapping_helpers/airalarm/tlv_no_checks/payload(obj/machinery/airalarm/target)
	if(target.tlv_no_checks)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s tlv to no_checks but it's already changed!")
	target.tlv_no_checks = TRUE

/obj/effect/mapping_helpers/airalarm/link
	name = "airalarm link helper"
	icon_state = "airalarm_link_helper"
	var/chamber_id = ""
	var/allow_link_change = FALSE

/obj/effect/mapping_helpers/airalarm/link/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return INITIALIZE_HINT_QDEL

	var/obj/machinery/airalarm/alarm = locate(/obj/machinery/airalarm) in loc
	if(!isnull(alarm))
		alarm.air_sensor_chamber_id = chamber_id
		alarm.allow_link_change = allow_link_change
	else
		log_mapping("[src] failed to find air alarm at [AREACOORD(src)].")
		return INITIALIZE_HINT_QDEL
