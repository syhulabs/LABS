local Config = requireShared("Config")
local CosmeticLogic = requireShared("Logic/CosmeticLogic")

describe("CosmeticLogic", function()
	it("unlocks free cosmetics for everyone", function()
		local unlocked = CosmeticLogic.unlocked(Config.Cosmetics, {}, {})
		expect(unlocked.Pajamas_Default).toBe(true)
		expect(unlocked.Flashlight_Warm).toBe(true)
		expect(unlocked.Pajamas_Stripes).toBeNil()
	end)

	it("unlocks pass and developer product cosmetics", function()
		local unlocked = CosmeticLogic.unlocked(
			Config.Cosmetics,
			{ PajamaPack = true },
			{ Pajamas_Dino = true }
		)
		expect(unlocked.Pajamas_Stripes).toBe(true)
		expect(unlocked.Pajamas_Dino).toBe(true)
		expect(unlocked.Flashlight_Purple).toBeNil()
	end)

	it("only equips unlocked cosmetics in the right slot", function()
		local unlocked = CosmeticLogic.unlocked(Config.Cosmetics, { FlashlightPack = true }, {})
		expect(CosmeticLogic.canEquip(Config.Cosmetics, unlocked, "Flashlight", "Flashlight_Teal")).toBe(true)
		expect(CosmeticLogic.canEquip(Config.Cosmetics, unlocked, "Pajamas", "Flashlight_Teal")).toBe(false)
		expect(CosmeticLogic.canEquip(Config.Cosmetics, unlocked, "Pajamas", "Pajamas_Stars")).toBe(false)
		expect(CosmeticLogic.canEquip(Config.Cosmetics, unlocked, "Pajamas", "Made_Up")).toBe(false)
	end)

	it("falls back to defaults when a cosmetic is no longer owned", function()
		local unlocked = CosmeticLogic.unlocked(Config.Cosmetics, {}, {})
		local equipped = CosmeticLogic.sanitizeEquipped(
			Config.Cosmetics,
			unlocked,
			{ Pajamas = "Pajamas_Stars", Flashlight = "Flashlight_Warm" },
			Config.DefaultEquipped
		)
		expect(equipped).toEqual({ Pajamas = "Pajamas_Default", Flashlight = "Flashlight_Warm" })
	end)
end)
