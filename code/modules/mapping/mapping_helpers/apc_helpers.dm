//apc helpers
/obj/effect/mapping_helpers/apc
	desc = "You shouldn't see this. Report it please."
	late = TRUE

/obj/effect/mapping_helpers/apc/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return INITIALIZE_HINT_QDEL

	var/obj/machinery/power/apc/target = locate(/obj/machinery/power/apc) in loc
	if(isnull(target))
		var/area/target_area = get_area(src)
		log_mapping("[src] failed to find an apc at [AREACOORD(src)] ([target_area.type]).")
	else
		payload(target)

	return INITIALIZE_HINT_LATELOAD

/obj/effect/mapping_helpers/apc/LateInitialize()
	. = ..()
	var/obj/machinery/power/apc/target = locate(/obj/machinery/power/apc) in loc

	if(isnull(target))
		qdel(src)
		return
	if(target.cut_AI_wire)
		target.wires.cut(WIRE_AI)
	if(target.cell_5k)
		target.install_cell_5k()
	if(target.cell_10k)
		target.install_cell_10k()
	if(target.unlocked)
		target.unlock()
	if(target.syndicate_access)
		target.give_syndicate_access()
	if(target.away_general_access)
		target.give_away_general_access()
	if(target.no_charge)
		target.set_no_charge()
	if(target.full_charge)
		target.set_full_charge()
	if(target.cell_5k && target.cell_10k)
		CRASH("Tried to combine non-combinable cell_5k and cell_10k APC helpers!")
	if(target.syndicate_access && target.away_general_access)
		CRASH("Tried to combine non-combinable syndicate_access and away_general_access APC helpers!")
	if(target.no_charge && target.full_charge)
		CRASH("Tried to combine non-combinable no_charge and full_charge APC helpers!")
	target.update_appearance()
	qdel(src)

/obj/effect/mapping_helpers/apc/proc/payload(obj/machinery/power/apc/target)
	return

/obj/effect/mapping_helpers/apc/cut_AI_wire
	name = "apc AI wire mended helper"
	icon_state = "apc_cut_AIwire_helper"

/obj/effect/mapping_helpers/apc/cut_AI_wire/payload(obj/machinery/power/apc/target)
	if(target.cut_AI_wire)
		var/area/apc_area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(apc_area.type)] tried to mend the AI wire on the [target] but it's already cut!")
	target.cut_AI_wire = TRUE

/obj/effect/mapping_helpers/apc/cell_5k
	name = "apc 5k cell helper"
	icon_state = "apc_5k_cell_helper"

/obj/effect/mapping_helpers/apc/cell_5k/payload(obj/machinery/power/apc/target)
	if(target.cell_5k)
		var/area/apc_area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(apc_area.type)] tried to change [target]'s cell to cell_5k but it's already changed!")
	target.cell_5k = TRUE

/obj/effect/mapping_helpers/apc/cell_10k
	name = "apc 10k cell helper"
	icon_state = "apc_10k_cell_helper"

/obj/effect/mapping_helpers/apc/cell_10k/payload(obj/machinery/power/apc/target)
	if(target.cell_10k)
		var/area/apc_area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(apc_area.type)] tried to change [target]'s cell to cell_10k but it's already changed!")
	target.cell_10k = TRUE

/obj/effect/mapping_helpers/apc/syndicate_access
	name = "apc syndicate access helper"
	icon_state = "apc_syndicate_access_helper"

/obj/effect/mapping_helpers/apc/syndicate_access/payload(obj/machinery/power/apc/target)
	if(target.syndicate_access)
		var/area/apc_area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(apc_area.type)] tried to adjust [target]'s access to syndicate but it's already changed!")
	target.syndicate_access = TRUE

/obj/effect/mapping_helpers/apc/away_general_access
	name = "apc away access helper"
	icon_state = "apc_away_general_access_helper"

/obj/effect/mapping_helpers/apc/away_general_access/payload(obj/machinery/power/apc/target)
	if(target.away_general_access)
		var/area/apc_area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(apc_area.type)] tried to adjust [target]'s access to away_general but it's already changed!")
	target.away_general_access = TRUE

/obj/effect/mapping_helpers/apc/unlocked
	name = "apc unlocked interface helper"
	icon_state = "apc_unlocked_interface_helper"

/obj/effect/mapping_helpers/apc/unlocked/payload(obj/machinery/power/apc/target)
	if(target.unlocked)
		var/area/apc_area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(apc_area.type)] tried to unlock the [target] but it's already unlocked!")
	target.unlocked = TRUE

/obj/effect/mapping_helpers/apc/no_charge
	name = "apc no charge helper"
	icon_state = "apc_no_charge_helper"

/obj/effect/mapping_helpers/apc/no_charge/payload(obj/machinery/power/apc/target)
	if(target.no_charge)
		var/area/apc_area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(apc_area.type)] tried to set [target]'s charge to 0 but it's already at 0!")
	target.no_charge = TRUE

/obj/effect/mapping_helpers/apc/full_charge
	name = "apc full charge helper"
	icon_state = "apc_full_charge_helper"

/obj/effect/mapping_helpers/apc/full_charge/payload(obj/machinery/power/apc/target)
	if(target.full_charge)
		var/area/apc_area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(apc_area.type)] tried to set [target]'s charge to 100 but it's already at 100!")
	target.full_charge = TRUE
