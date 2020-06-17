/obj/item/weapon/flame/candle/scented
	name = "scented candle"
	desc = "A candle which releases pleasant-smelling oils into the air when burned."

	var/scent //for desc
	///How strong the smell is
	var/intensity = 2
	///How far away you can smell it from
	var/range = 4
	var/descriptor = SCENT_DESC_FRAGRANCE
	var/possible_scents = list("a rose garden",
						"assorted citrus",
						"frankincense",
						"white sage",
						"crisp mint",
						"nag champa",
						"gentle lavender",
						"cinnamon",
						"vanilla",
						"a sea breeze",
						"sandalwood"
						)

/obj/item/weapon/flame/candle/scented/Initialize()
	. = ..()
	var/scent = safepick(possible_scents)
	desc += " This one smells of [scent]."

/obj/item/weapon/flame/candle/scented/attack_self(mob/user as mob)
	..()
	RemoveElement(/datum/element/scent)

/obj/item/weapon/flame/candle/scented/extinguish(var/mob/user, var/no_message)
	..()
	RemoveElement(/datum/element/scent)

/obj/item/weapon/flame/candle/scented/light(mob/user)
	..()
	if(lit)
		AddElement(/datum/element/scent, scent, intensity, descriptor, range)
		update_icon()

/obj/item/weapon/storage/candle_box/scented
	name = "scented candle box"
	desc = "An unbranded pack of scented candles, in a variety of scents."
	max_storage_space = 5

	startswith = list(/obj/item/weapon/flame/candle/scented = 5)