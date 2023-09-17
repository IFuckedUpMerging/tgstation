/obj/effect/baseturf_helper //Set the baseturfs of every turf in the /area/ it is placed.
	name = "baseturf editor"
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = ""

	var/list/baseturf_to_replace
	var/baseturf

	plane = POINT_PLANE

/obj/effect/baseturf_helper/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/baseturf_helper/LateInitialize()
	if(!baseturf_to_replace)
		baseturf_to_replace = typecacheof(list(/turf/open/space,/turf/baseturf_bottom))
	else if(!length(baseturf_to_replace))
		baseturf_to_replace = list(baseturf_to_replace = TRUE)
	else if(baseturf_to_replace[baseturf_to_replace[1]] != TRUE) // It's not associative
		var/list/formatted = list()
		for(var/i in baseturf_to_replace)
			formatted[i] = TRUE
		baseturf_to_replace = formatted

	var/area/our_area = get_area(src)
	for(var/i in get_area_turfs(our_area, z))
		replace_baseturf(i)

	qdel(src)

/obj/effect/baseturf_helper/proc/replace_baseturf(turf/thing)
	thing.remove_baseturfs_from_typecache(baseturf_to_replace)
	thing.PlaceOnBottom(fake_turf_type = baseturf)

/obj/effect/baseturf_helper/space
	name = "space baseturf editor"
	baseturf = /turf/open/space

/obj/effect/baseturf_helper/asteroid
	name = "asteroid baseturf editor"
	baseturf = /turf/open/misc/asteroid

/obj/effect/baseturf_helper/asteroid/airless
	name = "asteroid airless baseturf editor"
	baseturf = /turf/open/misc/asteroid/airless

/obj/effect/baseturf_helper/asteroid/basalt
	name = "asteroid basalt baseturf editor"
	baseturf = /turf/open/misc/asteroid/basalt

/obj/effect/baseturf_helper/asteroid/snow
	name = "asteroid snow baseturf editor"
	baseturf = /turf/open/misc/asteroid/snow

/obj/effect/baseturf_helper/asteroid/moon
	name = "lunar sand baseturf editor"
	baseturf = /turf/open/misc/asteroid/moon

/obj/effect/baseturf_helper/beach/sand
	name = "beach sand baseturf editor"
	baseturf = /turf/open/misc/beach/sand

/obj/effect/baseturf_helper/beach/water
	name = "water baseturf editor"
	baseturf = /turf/open/water/beach

/obj/effect/baseturf_helper/lava
	name = "lava baseturf editor"
	baseturf = /turf/open/lava/smooth

/obj/effect/baseturf_helper/lava_land/surface
	name = "lavaland baseturf editor"
	baseturf = /turf/open/lava/smooth/lava_land_surface

/obj/effect/baseturf_helper/reinforced_plating
	name = "reinforced plating baseturf editor"
	baseturf = /turf/open/floor/plating/reinforced
	baseturf_to_replace = list(/turf/open/floor/plating)

/obj/effect/baseturf_helper/reinforced_plating/replace_baseturf(turf/thing)
	if(istype(thing, /turf/open/floor/plating))
		return //Plates should not be placed under other plates
	thing.stack_ontop_of_baseturf(/turf/open/floor/plating, baseturf)

//This applies the reinforced plating to the above Z level for every tile in the area where this is placed
/obj/effect/baseturf_helper/reinforced_plating/ceiling
	name = "reinforced ceiling plating baseturf editor"

/obj/effect/baseturf_helper/reinforced_plating/ceiling/replace_baseturf(turf/thing)
	var/turf/ceiling = get_step_multiz(thing, UP)
	if(isnull(ceiling))
		CRASH("baseturf helper is attempting to modify the Z level above but there is no Z level above above it.")
	if(isspaceturf(ceiling) || istype(ceiling, /turf/open/openspace))
		return
	return ..(ceiling)
