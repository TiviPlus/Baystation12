#define SCENT_DESC_ODOR        "odour"
#define SCENT_DESC_SMELL       "smell"
#define SCENT_DESC_FRAGRANCE   "fragrance"

/datum/element/scent
	var/scent = "something"
	var/intensity = 1
	var/descriptor = SCENT_DESC_SMELL //unambiguous descriptor of smell; food is generally good, sewage is generally bad. how 'nice' the scent is
	var/range = 1 //range in tiles
	var/cooldown = 5 SECONDS
	var/target

/datum/element/scent/Attach(datum/target, scent, intensity, descriptor, range)
	. = ..()
	src.scent = scent
	src.intensity = intensity
	src.descriptor = descriptor
	src.range = range
	src.target = target

/datum/element/scent/New()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/datum/element/scent/proc/stop_smell()
	STOP_PROCESSING(SSprocessing, src)

/datum/element/scent/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/datum/element/scent/Process()
	if(!target)
		stack_trace("Scent extension with scent '[scent]', intensity '[intensity]', descriptor '[descriptor]' and range of '[range]' attempted to emit_scent() without a target.")
		qdel(src)
		return
	emit_scent()

/datum/element/scent/proc/emit_scent()
	for(var/mob/living/carbon/human/H in all_hearers(target, range))
		var/turf/T = get_turf(H.loc)
		if(!T)
			continue
		if(H.stat != CONSCIOUS || H.failed_last_breath || H.wear_mask || H.head && H.head.permeability_coefficient < 1 || !T.return_air())
			continue
		if(H.last_smelt < world.time)
			sendsmell(H)
			H.last_smelt = world.time + cooldown

/datum/element/scent/proc/sendsmell(user)
	switch(intensity)
		if(1)
			to_chat(user, SPAN_SUBTLE("The subtle [descriptor] of [scent] tickles your nose..."))
		if(2)
			to_chat(user, SPAN_NOTICE("The [descriptor] of [scent] fills the air."))
		if(3)
			to_chat(user, SPAN_WARNING("The unmistakable [descriptor] of [scent] bombards your nostrils."))

/*****
Reagents have the following vars, which coorelate to the vars on the standard scent extension:
	scent,
	scent_intensity,
	scent_descriptor,
	scent_range
To add a scent extension to an atom using a reagent's info, where R. is the reagent, use set_scent_by_reagents().
*****/

/proc/set_scent_by_reagents(var/atom/smelly_atom)
	var/datum/reagent/smelliest
	var/datum/reagent/scent_intensity
	if(!smelly_atom.reagents || !smelly_atom.reagents.total_volume)
		return
	for(var/datum/reagent/reagent_to_compare in smelly_atom.reagents.reagent_list)
		var/datum/reagent/R = reagent_to_compare
		if(!R.scent)
			continue
		var/r_scent_intensity = R.volume * R.scent_intensity
		if(r_scent_intensity > scent_intensity)
			smelliest = R
			scent_intensity = r_scent_intensity
	if(smelliest)
		to_chat(world, "adding element to [smelliest] of [smelly_atom]")
		smelly_atom.AddElement(/datum/element/scent, smelliest.scent, smelliest.scent_intensity, smelliest.scent_descriptor, smelliest.scent_range)
