--!strict
-- Picks the shapeshifter and tells each player only their own role.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local Types = require(Shared.Types)
local RoleLogic = require(Shared.Logic.RoleLogic)
local RemoteService = require(script.Parent.RemoteService)

type Role = Types.Role

local RoleService = {}

function RoleService.isDebug(): boolean
	return Config.DebugMode and RunService:IsStudio()
end

function RoleService.assign(players: { Player }, rng: Types.Rng): { [number]: Role }
	local ids = {}
	for _, player in players do
		table.insert(ids, player.UserId)
	end
	local forced: { [number]: Role }? = nil
	if RoleService.isDebug() and Config.Debug.ForceRole and #ids > 0 then
		-- Pins the first player (the Studio tester) to the chosen role.
		forced = { [ids[1]] = Config.Debug.ForceRole :: Role }
	end
	return RoleLogic.assign(ids, Config.ShapeshifterCount, rng, forced)
end

-- Only this player's client ever learns this player's role.
function RoleService.reveal(player: Player, role: Role, memories: { string }, shared: { [number]: boolean })
	-- Remotes drop tables with gaps in numeric keys, so send shared indices as a list.
	local sharedList = {}
	for index, isShared in shared do
		if isShared then
			table.insert(sharedList, index)
		end
	end
	RemoteService.fire("RoleAssigned", player, {
		role = role,
		memories = memories,
		shared = sharedList,
	})
end

return RoleService
