--!strict
-- Private memories and sharing them during meetings.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local Types = require(Shared.Types)
local ItemLogic = require(Shared.Logic.ItemLogic)
local MemoryLogic = require(Shared.Logic.MemoryLogic)
local RemoteService = require(script.Parent.RemoteService)

local MemoryService = {}

local memories: { [number]: { string } } = {}
local shared: { [number]: { [number]: boolean } } = {}

function MemoryService.generate(itemState: ItemLogic.ItemState, players: { Player }, rng: Types.Rng)
	local list = {}
	for _, player in players do
		table.insert(list, { id = player.UserId, name = player.DisplayName })
	end
	memories = MemoryLogic.generate(itemState, list, Config.MemoriesPerPlayer, rng)
	shared = {}
	for _, player in players do
		shared[player.UserId] = {}
	end
end

function MemoryService.get(userId: number): { string }
	return memories[userId] or {}
end

function MemoryService.getShared(userId: number): { [number]: boolean }
	return shared[userId] or {}
end

-- Caller has already checked phase and that the player is alive.
function MemoryService.share(player: Player, index: number): boolean
	local list = memories[player.UserId]
	local flags = shared[player.UserId]
	if not list or not flags or not list[index] or flags[index] then
		return false
	end
	flags[index] = true
	RemoteService.fireAll(
		"MemoryShared",
		{ userId = player.UserId, name = player.DisplayName, text = list[index], index = index }
	)
	return true
end

function MemoryService.clear()
	memories = {}
	shared = {}
end

return MemoryService
