--!strict
-- Item ownership, locations and the shapeshifter's swaps.

local Types = require(script.Parent.Parent.Types)
local RoleLogic = require(script.Parent.RoleLogic)
type Rng = Types.Rng

export type Item = {
	id: string,
	name: string,
	ownerId: number?,
	homeRoom: string,
	currentRoom: string,
	ownerKnownRoom: string,
}

export type ItemState = {
	items: { [string]: Item },
	order: { string },
}

export type InspectResult = {
	kind: "OwnMoved" | "OwnInPlace" | "Other" | "Unowned",
	name: string,
	ownerId: number?,
	room: string,
	previousRoom: string?,
}

local ItemLogic = {}

function ItemLogic.new(list: { { id: string, name: string, room: string } }): ItemState
	local state: ItemState = { items = {}, order = {} }
	for _, info in list do
		state.items[info.id] = {
			id = info.id,
			name = info.name,
			ownerId = nil,
			homeRoom = info.room,
			currentRoom = info.room,
			ownerKnownRoom = info.room,
		}
		table.insert(state.order, info.id)
	end
	return state
end

-- Each player gets `perPlayer` items while stock lasts. Leftovers stay unowned.
-- Returns how many players got fewer items than requested.
function ItemLogic.assignOwners(state: ItemState, playerIds: { number }, perPlayer: number, rng: Rng): number
	local pool = RoleLogic.shuffle(state.order, rng)
	local cursor = 1
	local shortfall = 0
	for _, playerId in playerIds do
		local got = 0
		while got < perPlayer and cursor <= #pool do
			state.items[pool[cursor]].ownerId = playerId
			cursor += 1
			got += 1
		end
		if got < perPlayer then
			shortfall += 1
		end
	end
	return shortfall
end

function ItemLogic.ownedBy(state: ItemState, playerId: number): { Item }
	local owned = {}
	for _, id in state.order do
		local item = state.items[id]
		if item.ownerId == playerId then
			table.insert(owned, item)
		end
	end
	return owned
end

function ItemLogic.inspect(state: ItemState, itemId: string, inspectorId: number): InspectResult?
	local item = state.items[itemId]
	if not item then
		return nil
	end
	if item.ownerId == nil then
		return { kind = "Unowned", name = item.name, ownerId = nil, room = item.currentRoom }
	end
	if item.ownerId ~= inspectorId then
		return { kind = "Other", name = item.name, ownerId = item.ownerId, room = item.currentRoom }
	end
	if item.currentRoom ~= item.ownerKnownRoom then
		local previous = item.ownerKnownRoom
		item.ownerKnownRoom = item.currentRoom
		return {
			kind = "OwnMoved",
			name = item.name,
			ownerId = item.ownerId,
			room = item.currentRoom,
			previousRoom = previous,
		}
	end
	return { kind = "OwnInPlace", name = item.name, ownerId = item.ownerId, room = item.currentRoom }
end

-- A random item in a different room to swap places with.
function ItemLogic.pickSwapPartner(state: ItemState, itemId: string, rng: Rng): string?
	local item = state.items[itemId]
	if not item then
		return nil
	end
	local candidates = {}
	for _, id in state.order do
		if id ~= itemId and state.items[id].currentRoom ~= item.currentRoom then
			table.insert(candidates, id)
		end
	end
	if #candidates == 0 then
		return nil
	end
	return candidates[rng(1, #candidates)]
end

function ItemLogic.swap(state: ItemState, a: string, b: string): boolean
	local itemA, itemB = state.items[a], state.items[b]
	if not itemA or not itemB or a == b then
		return false
	end
	itemA.currentRoom, itemB.currentRoom = itemB.currentRoom, itemA.currentRoom
	return true
end

return ItemLogic
