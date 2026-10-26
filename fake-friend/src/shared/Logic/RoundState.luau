--!strict
-- Pure model of one game: who is in it, who is alive, and who has won.

local Types = require(script.Parent.Parent.Types)
type Role = Types.Role
type Winner = Types.Winner
type WinReason = Types.WinReason

export type PlayerEntry = {
	id: number,
	name: string,
	role: Role,
	alive: boolean,
	connected: boolean,
}

export type Rules = {
	roundsUntilSunrise: number,
	shapeshifterWinsAtFriendsAlive: number,
	actionsPerBlackout: number,
}

local RoundState = {}
RoundState.__index = RoundState

export type RoundState = typeof(setmetatable(
	{} :: {
		rules: Rules,
		players: { [number]: PlayerEntry },
		order: { number },
		round: number,
		actionsLeft: number,
		startingFriends: number,
		shapeshifterLeft: boolean,
	},
	RoundState
))

function RoundState.new(rules: Rules): RoundState
	return setmetatable({
		rules = rules,
		players = {},
		order = {},
		round = 1,
		actionsLeft = 0,
		startingFriends = 0,
		shapeshifterLeft = false,
	}, RoundState)
end

function RoundState.addPlayer(self: RoundState, id: number, name: string, role: Role)
	assert(self.players[id] == nil, "player already in round")
	self.players[id] = { id = id, name = name, role = role, alive = true, connected = true }
	table.insert(self.order, id)
	if role == "Friend" then
		self.startingFriends += 1
	end
end

function RoundState.get(self: RoundState, id: number): PlayerEntry?
	return self.players[id]
end

function RoundState.isAlive(self: RoundState, id: number): boolean
	local entry = self.players[id]
	return entry ~= nil and entry.alive
end

function RoundState.isShapeshifter(self: RoundState, id: number): boolean
	local entry = self.players[id]
	return entry ~= nil and entry.role == "Shapeshifter"
end

function RoundState.aliveIds(self: RoundState): { number }
	local ids = {}
	for _, id in self.order do
		if self.players[id].alive then
			table.insert(ids, id)
		end
	end
	return ids
end

function RoundState.countAlive(self: RoundState, role: Role): number
	local n = 0
	for _, entry in self.players do
		if entry.alive and entry.role == role then
			n += 1
		end
	end
	return n
end

function RoundState.shapeshifterIds(self: RoundState): { number }
	local ids = {}
	for _, id in self.order do
		if self.players[id].role == "Shapeshifter" then
			table.insert(ids, id)
		end
	end
	return ids
end

-- Sent home by vote. Returns the entry so callers can announce the role.
function RoundState.eliminate(self: RoundState, id: number): PlayerEntry?
	local entry = self.players[id]
	if not entry or not entry.alive then
		return nil
	end
	entry.alive = false
	return entry
end

-- Player left the server mid-game.
function RoundState.removePlayer(self: RoundState, id: number)
	local entry = self.players[id]
	if not entry then
		return
	end
	if entry.alive and entry.role == "Shapeshifter" then
		self.shapeshifterLeft = true
	end
	entry.alive = false
	entry.connected = false
end

function RoundState.startBlackout(self: RoundState)
	self.actionsLeft = self.rules.actionsPerBlackout
end

function RoundState.endBlackout(self: RoundState)
	self.actionsLeft = 0
end

-- Consumes one shapeshifter action if the player is allowed to act.
function RoundState.useAction(self: RoundState, id: number): boolean
	if not self:isAlive(id) or not self:isShapeshifter(id) or self.actionsLeft <= 0 then
		return false
	end
	self.actionsLeft -= 1
	return true
end

function RoundState.completeMeeting(self: RoundState)
	self.round += 1
end

-- The friends-alive threshold never makes the shapeshifter win at the very start,
-- which matters for small private-server or debug games.
function RoundState.effectiveFriendThreshold(self: RoundState): number
	return math.min(self.rules.shapeshifterWinsAtFriendsAlive, math.max(self.startingFriends - 1, 0))
end

function RoundState.checkWinner(self: RoundState): (Winner?, WinReason?)
	if self:countAlive("Shapeshifter") == 0 then
		return "Friends", if self.shapeshifterLeft then "ShapeshifterLeft" else "Caught"
	end
	if self:countAlive("Friend") <= self:effectiveFriendThreshold() then
		return "Shapeshifter", "Outnumbered"
	end
	if self.round > self.rules.roundsUntilSunrise then
		return "Shapeshifter", "Sunrise"
	end
	return nil, nil
end

return RoundState
