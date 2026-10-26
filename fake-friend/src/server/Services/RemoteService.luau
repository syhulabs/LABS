--!strict
-- Creates remotes and wraps every client request with rate limiting and error isolation.
-- Handlers still validate their own arguments, phase and role.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local Remotes = require(Shared.Remotes)
local RateLimiter = require(Shared.Logic.RateLimiter)

local RemoteService = {}

local remotes: { [string]: RemoteEvent } = {}
local limiters: { [string]: RateLimiter.RateLimiter } = {}

function RemoteService.init()
	local folder = Instance.new("Folder")
	folder.Name = Remotes.FolderName
	for _, name in Remotes.Names do
		local remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = folder
		remotes[name] = remote
	end
	folder.Parent = ReplicatedStorage

	Players.PlayerRemoving:Connect(function(player)
		for _, limiter in limiters do
			limiter:forget(player)
		end
	end)
end

local function remote(name: string): RemoteEvent
	local r = remotes[name]
	assert(r, `Unknown remote {name}`)
	return r
end

-- Handler receives the player and raw arguments. Never trust their types.
function RemoteService.on(name: string, handler: (Player, ...any) -> ())
	local limits = Config.RateLimits[name] or Config.RateLimits.Default
	local limiter = RateLimiter.new(limits.capacity, limits.perSecond, os.clock)
	limiters[name] = limiter
	remote(name).OnServerEvent:Connect(function(player, ...)
		if not limiter:allow(player) then
			return
		end
		local ok, err = pcall(handler, player, ...)
		if not ok then
			warn(`[FakeFriend] {name} handler error for {player.Name}: {err}`)
		end
	end)
end

function RemoteService.fire(name: string, player: Player, ...: any)
	remote(name):FireClient(player, ...)
end

function RemoteService.fireAll(name: string, ...: any)
	remote(name):FireAllClients(...)
end

-- Argument validators -------------------------------------------------------

function RemoteService.isInteger(value: any, min: number?, max: number?): boolean
	if type(value) ~= "number" or value ~= value or value % 1 ~= 0 then
		return false
	end
	if min and value < min then
		return false
	end
	if max and value > max then
		return false
	end
	return true
end

function RemoteService.isShortString(value: any, maxLength: number?): boolean
	return type(value) == "string" and #value > 0 and #value <= (maxLength or 64)
end

return RemoteService
