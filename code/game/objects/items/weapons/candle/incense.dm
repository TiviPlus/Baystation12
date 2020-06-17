/obj/item/weapon/flame/candle/scented/incense
	name = "incense cone"
	desc = "An incense cone. It produces fragrant smoke when burned."
	icon_state = "incense1"

	available_colours = null
	icon_set = "incense"
	candle_max_bright = 0.1
	candle_inner_range = 0.1
	candle_outer_range = 1
	candle_falloff = 2

	intensity = 3
	range = 5
	possible_scents = list("a rose garden",
						"assorted citrus",
						"frankincense",
						"white sage",
						"crisp mint",
						"nag champa",
						"gentle lavender",
						"sandalwood"
						)

/obj/item/weapon/storage/candle_box/incense
	name = "incense box"
	desc = "A pack of 'Tres' brand incense cones, in a variety of scents."
	icon_state = "incensebox"
	max_storage_space = 9

	startswith = list(/obj/item/weapon/flame/candle/scented/incense = 9)