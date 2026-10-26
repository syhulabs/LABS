--!strict
-- Saves stats and cosmetics with a session lock, retries and exponential backoff.
-- In Studio without API access it falls back to temporary data that is not saved.

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local SessionLock = require(Shared.Logic.SessionLock)

local DataService = {}

DataService.Defaults = {
	wins = 0,
	gamesPlayed = 0,
	gamesAsShapeshifter = 0,
	winsAsShapeshifter = 0,
	granted = {}, -- cosmeticId -> true, from developer products
	purchases = {}, -- receipt PurchaseId -> true, so a purchase is never granted twice
	equipped = {
		Pajamas = Config.DefaultEquipped.Pajamas,
		Flashlight = Config.DefaultEquipped.Flashlight,
	},
}

type Profile = {
	data: { [string]: any },
	offline: boolean,
}

local store: DataStore? = nil
local profiles: { [Player]: Profile } = {}
local loadedCallbacks: { (Player) -> () } = {}
local closing = false

local function key(player: Player): string
	return `player_{player.UserId}`
end

local function jobId(): string
	return if game.JobId ~= "" then game.JobId else "studio"
end

-- Runs `fn` with retries. Returns ok plus the error from the last attempt.
local function withRetry(fn: () -> (), attempts: number): (boolean, string?)
	local lastErr: string? = nil
	for attempt = 1, attempts do
		local ok, err = pcall(fn)
		if ok then
			return true, nil
		end
		lastErr = tostring(err)
		if attempt < attempts then
			task.wait(Config.DataRetryBaseDelay * 2 ^ (attempt - 1))
		end
	end
	return false, lastErr
end

local function fireLoaded(player: Player)
	for _, callback in loadedCallbacks do
		task.spawn(callback, player)
	end
end

local function useOffline(player: Player, reason: string)
	warn(`[FakeFriend] Using temporary data for {player.Name}: {reason}`)
	profiles[player] = { data = SessionLock.reconcile(nil, DataService.Defaults), offline = true }
	fireLoaded(player)
end

local function load(player: Player)
	if not store then
		useOffline(player, "DataStore unavailable")
		return
	end
	local isStudio = RunService:IsStudio()
	local attempts = if isStudio then 1 else Config.DataRetryAttempts

	for lockTry = 1, Config.SessionLockWaitAttempts do
		local status: string? = nil
		local record: SessionLock.Record? = nil
		local ok, err = withRetry(function()
			(store :: DataStore):UpdateAsync(key(player), function(stored: SessionLock.Record?)
				local s, r = SessionLock.acquire(
					stored,
					DataService.Defaults,
					jobId(),
					os.time(),
					Config.SessionLockTimeout
				)
				status, record = s, r
				return r
			end)
		end, attempts)

		if not player.Parent then
			-- Left while loading. Release whatever we may have locked.
			if ok and status == "Acquired" and record then
				profiles[player] = { data = record.data, offline = false }
				DataService.release(player)
			end
			return
		end

		if not ok then
			if isStudio then
				useOffline(
					player,
					`{err}. Enable Studio API access in Game Settings > Security to test saving.`
				)
			else
				player:Kick("We couldn't load your data. Please rejoin in a minute.")
			end
			return
		end

		if status == "Acquired" and record then
			profiles[player] = { data = record.data, offline = false }
			fireLoaded(player)
			return
		end

		-- Another server still holds the lock, usually because the player just switched servers.
		task.wait(Config.DataRetryBaseDelay * 2 ^ (lockTry - 1))
	end

	player:Kick("Your data is still saving on another server. Please rejoin in a moment.")
end

local function write(player: Player, release: boolean): boolean
	local profile = profiles[player]
	if not profile or profile.offline or not store then
		return true
	end
	local data = profile.data
	local status: string? = nil
	local ok, err = withRetry(function()
		(store :: DataStore):UpdateAsync(key(player), function(stored: SessionLock.Record?)
			local s, r
			if release then
				s, r = SessionLock.release(stored, jobId(), data)
			else
				s, r = SessionLock.save(stored, jobId(), os.time(), data)
			end
			status = s
			return r
		end)
	end, Config.DataRetryAttempts)
	if not ok then
		warn(`[FakeFriend] Save failed for {player.Name}: {err}`)
		return false
	end
	if status == "Stolen" then
		warn(`[FakeFriend] Another server took {player.Name}'s data. This server stops saving it.`)
		profile.offline = true
		return false
	end
	return true
end

function DataService.init()
	local ok, result = pcall(function()
		return DataStoreService:GetDataStore(Config.DataStoreName)
	end)
	if ok then
		store = result
	else
		warn(`[FakeFriend] DataStore unavailable: {result}`)
	end

	Players.PlayerAdded:Connect(load)
	for _, player in Players:GetPlayers() do
		task.spawn(load, player)
	end
	Players.PlayerRemoving:Connect(function(player)
		if profiles[player] then
			DataService.release(player)
		end
	end)

	game:BindToClose(function()
		closing = true
		local pending = 0
		for player in profiles do
			pending += 1
			task.spawn(function()
				DataService.release(player)
				pending -= 1
			end)
		end
		local deadline = os.clock() + 25
		while pending > 0 and os.clock() < deadline do
			task.wait(0.1)
		end
	end)

	task.spawn(function()
		while not closing do
			task.wait(Config.AutosaveInterval)
			for player in profiles do
				task.spawn(write, player, false)
			end
		end
	end)
end

function DataService.release(player: Player)
	write(player, true)
	profiles[player] = nil
end

function DataService.isLoaded(player: Player): boolean
	return profiles[player] ~= nil
end

function DataService.get(player: Player): { [string]: any }?
	local profile = profiles[player]
	return profile and profile.data
end

-- Mutates the data in memory. It is written on the next autosave or when the player leaves.
function DataService.update(player: Player, mutate: ({ [string]: any }) -> ()): boolean
	local profile = profiles[player]
	if not profile then
		return false
	end
	mutate(profile.data)
	return true
end

-- Writes immediately. Used for purchases. Returns true when the data is safely stored.
function DataService.saveNow(player: Player): boolean
	local profile = profiles[player]
	if not profile then
		return false
	end
	if profile.offline then
		-- Studio test data: nothing to save, but purchases still count for the session.
		return RunService:IsStudio()
	end
	return write(player, false)
end

function DataService.onLoaded(callback: (Player) -> ())
	table.insert(loadedCallbacks, callback)
	for player in profiles do
		task.spawn(callback, player)
	end
end

return DataService
