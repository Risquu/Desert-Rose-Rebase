/obj/item/organ/genital/penis
	name = "penis"
	desc = "A male reproductive organ."
	icon_state = "penis"
	icon = 'modular_citadel/icons/obj/genitals/penis.dmi'
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_PENIS
	can_masturbate_with = TRUE
	masturbation_verb = "stroke"
	can_climax = TRUE
	fluid_transfer_factor = 0.5
	size = 2 //arbitrary value derived from length and girth for sprites.
	layer_index = PENIS_LAYER_INDEX
	var/length = 6	//inches
	var/cached_length //used to detect a change in length
	var/girth = 0
	var/girth_ratio = COCK_GIRTH_RATIO_DEF //0.73; check citadel_defines.dm
	var/knot_girth_ratio = KNOT_GIRTH_RATIO_DEF
	var/list/dickflags = list()
	var/list/knotted_types = list("knotted", "barbed, knotted")

/obj/item/organ/genital/penis/update_size()
	if(length == cached_length)
		return
	switch(length)
		if(-INFINITY to 5)
			size = 1
		if(5 to 9)
			size = 2
		if(15 to INFINITY)
			size = 3//no new sprites for anything larger yet
/*		if(9 to 15)
			size = 3
		if(15 to INFINITY)
			size = 3*/
	girth = (length * girth_ratio)
	cached_length = length

/obj/item/organ/genital/penis/update_appearance()
	var/string
	var/lowershape = lowertext(shape)
	desc = "You see [aroused_state ? "an erect" : "a flaccid"] [lowershape] [name]. You estimate it's about [round(length, 0.25)] inch[round(length, 0.25) != 1 ? "es" : ""] long and [round(girth, 0.25)] inch[round(girth, 0.25) != 1 ? "es" : ""] in girth."

	if(owner)
		if(owner.dna.species.use_skintones && owner.dna.features["genitals_use_skintone"])
			if(ishuman(owner)) // Check before recasting type, although someone fucked up if you're not human AND have use_skintones somehow...
				var/mob/living/carbon/human/H = owner // only human mobs have skin_tone, which we need.
				color = "#[skintone2hex(H.skin_tone)]"
				string = "penis_[GLOB.cock_shapes_icons[shape]]_[size]-s"
		else
			color = "#[owner.dna.features["cock_color"]]"
			string = "penis_[GLOB.cock_shapes_icons[shape]]_[size]"
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			icon_state = sanitize_text(string)
			H.update_genitals()

/obj/item/organ/genital/penis/get_features(mob/living/carbon/human/H)
	var/datum/dna/D = H.dna
	if(D.species.use_skintones && D.features["genitals_use_skintone"])
		color = "#[skintone2hex(H.skin_tone)]"
	else
		color = "#[D.features["cock_color"]]"
	length = D.features["cock_length"]
	girth_ratio = D.features["cock_girth_ratio"]
	shape = D.features["cock_shape"]
