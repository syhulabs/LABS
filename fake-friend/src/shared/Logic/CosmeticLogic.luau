--!strict
-- Which cosmetics a player has unlocked, and whether an equip request is valid.

local Config = require(script.Parent.Parent.Config)
type Cosmetic = Config.Cosmetic

local CosmeticLogic = {}

function CosmeticLogic.find(cosmetics: { Cosmetic }, id: string): Cosmetic?
	for _, cosmetic in cosmetics do
		if cosmetic.id == id then
			return cosmetic
		end
	end
	return nil
end

-- ownedSources: game passes the player owns, e.g. { PajamaPack = true }.
-- granted: cosmetic ids bought as developer products and saved in player data.
function CosmeticLogic.unlocked(
	cosmetics: { Cosmetic },
	ownedSources: { [string]: boolean },
	granted: { [string]: boolean }
): { [string]: boolean }
	local result = {}
	for _, cosmetic in cosmetics do
		if cosmetic.source == "Free" or ownedSources[cosmetic.source] or granted[cosmetic.id] then
			result[cosmetic.id] = true
		end
	end
	return result
end

function CosmeticLogic.canEquip(
	cosmetics: { Cosmetic },
	unlocked: { [string]: boolean },
	slot: string,
	id: string
): boolean
	local cosmetic = CosmeticLogic.find(cosmetics, id)
	return cosmetic ~= nil and cosmetic.slot == slot and unlocked[id] == true
end

-- Falls back to defaults for anything no longer unlocked, such as a refunded pass.
function CosmeticLogic.sanitizeEquipped(
	cosmetics: { Cosmetic },
	unlocked: { [string]: boolean },
	equipped: { [string]: string },
	defaults: { [string]: string }
): { [string]: string }
	local result = {}
	for slot, defaultId in defaults do
		local wanted = equipped[slot]
		result[slot] = if wanted and CosmeticLogic.canEquip(cosmetics, unlocked, slot, wanted)
			then wanted
			else defaultId
	end
	return result
end

return CosmeticLogic
