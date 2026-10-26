--!strict
-- Private memories handed to each player at the start of a game.
-- Every memory is true at the moment it is given out, including the shapeshifter's,
-- so revealing one never exposes a role on its own.

local Types = require(script.Parent.Parent.Types)
local ItemLogic = require(script.Parent.ItemLogic)
local RoleLogic = require(script.Parent.RoleLogic)
type Rng = Types.Rng
type ItemState = ItemLogic.ItemState

local MemoryLogic = {}

MemoryLogic.FALLBACK = "You don't remember much. Ask the others what they saw."

local function ownText(itemName: string, room: string): string
	return `You left your {itemName} in the {room}.`
end

local function otherText(ownerName: string, itemName: string, room: string): string
	return `You saw {ownerName}'s {itemName} in the {room}.`
end

function MemoryLogic.generate(
	state: ItemState,
	players: { { id: number, name: string } },
	perPlayer: number,
	rng: Rng
): { [number]: { string } }
	local names: { [number]: string } = {}
	for _, p in players do
		names[p.id] = p.name
	end

	local result: { [number]: { string } } = {}
	for _, p in players do
		local memories = {}
		for _, item in ItemLogic.ownedBy(state, p.id) do
			if #memories >= perPlayer then
				break
			end
			table.insert(memories, ownText(item.name, item.homeRoom))
		end

		local others = {}
		for _, id in state.order do
			local item = state.items[id]
			if item.ownerId ~= nil and item.ownerId ~= p.id and names[item.ownerId] then
				table.insert(others, item)
			end
		end
		for _, item in RoleLogic.shuffle(others, rng) do
			if #memories >= perPlayer then
				break
			end
			table.insert(memories, otherText(names[item.ownerId :: number], item.name, item.homeRoom))
		end

		if #memories == 0 then
			table.insert(memories, MemoryLogic.FALLBACK)
		end
		result[p.id] = memories
	end
	return result
end

return MemoryLogic
