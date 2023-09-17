/// Camera Helpers
/obj/effect/mapping_helpers/camera
	desc = "You shouldn't see this. Report it please."
	late = TRUE

/obj/effect/mapping_helpers/camera/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return INITIALIZE_HINT_QDEL

	return INITIALIZE_HINT_LATELOAD

/obj/effect/mapping_helpers/camera/LateInitialize(mapload)
	var/obj/machinery/camera/target = locate(/obj/machinery/camera) in loc
	if(isnull(target))
		var/area/target_area = get_area(target)
		log_mapping("[src] failed to find a requests console at [AREACOORD(src)] ([target_area.type]).")
	else
		payload(target)

	qdel(src)

/// Fills out the camera's variables
/obj/effect/mapping_helpers/camera/proc/payload(obj/machinery/camera/target)
	return

/// Camera Autonames ///
/// The original way autonaming worked for cameras.
/obj/effect/mapping_helpers/camera/autoname
	name = "Camera Autoname Helper - Numeric"

/obj/effect/mapping_helpers/camera/autoname/payload(obj/machinery/camera/target)
	var/static/list/autonames_in_areas = list()
	var/area/camera_area = get_area(target)
	var/our_number = autonames_in_areas[camera_area] + 1
	autonames_in_areas[camera_area] = our_number

	target.c_tag = "[format_text(camera_area.name)] #[our_number]"

/// Autonames with GPS Coordinates instead of an increasing value. Useful for rooms where relative positioning would be important to know for monitoring at a quick glance - Hallways, Atmospherics, etc
/obj/effect/mapping_helpers/camera/autoname/coordinates
	name = "Camera Autoname Helper - Coordinates"

/obj/effect/mapping_helpers/camera/autoname/coordinates/payload(obj/machinery/camera/target)
	target.c_tag = "[format_text(get_area(target).name)] ([target.x], [target.y], [target.z])"

/// Camera Upgrades ///

/// EMP Proofing Upgrade
/obj/effect/mapping_helpers/camera/emp_proof
	name = "Camera EMP-Proof Helper"

/obj/effect/mapping_helpers/camera/emp_proof/payload(obj/machinery/camera/target)
	target.upgradeEmpProof()

/// Motion Detector Upgrade
/obj/effect/mapping_helpers/camera/motion_detector
	name = "Camera Motion Detector Helper"

/obj/effect/mapping_helpers/camera/motion_detector/payload(obj/machinery/camera/target)
	target.name = "motion-sensitive security camera"
	target.upgradeMotion()

/// X-Ray Upgrade
/obj/effect/mapping_helpers/camera/x_ray
	name = "Camera X-Ray Helper"

/obj/effect/mapping_helpers/camera/x_ray/payload(obj/machinery/camera/target)
	target.upgradeXRay()
