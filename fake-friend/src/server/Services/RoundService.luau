--!strict
-- The round state machine. The server owns all game state; clients only send requests,
-- and every request is checked for phase, role, alive status and argument types here.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local Types = require(Shared.Types)
local PhaseLogic = require(Shared.Logic.PhaseLogic)
local RoundState = require(Shared.Logic.RoundState)
local ItemLogic = require(Shared.Logic.ItemLogic)
local VoteLogic = require(Shared.Logic.VoteLogic)

local Services = script.Parent
local ChatService = require(Services.ChatService)
local DataService = require(Services.DataService)
local DisguiseService = require(Services.DisguiseService)
local GhostService = require(Services.GhostService)
local ItemService = require(Services.ItemService)
local LightingService = require(Services.LightingService)
local MapService = require(Services.MapService)
local MemoryService = require(Services.MemoryService)
local MonetizationService = require(Services.MonetizationService)
local RemoteService = require(Services.RemoteService)
local RoleService = require(Services.RoleService)
local VoteService = require(Services.VoteService)

type Phase = Types.Phase

local RoundService = {}

local random = Random.new()
local function rng(min: number, max: number): number
	return random:NextInteger(min, max)
end

local phase: Phase = "Lobby"
local phaseEndsAt = 0
local lobbyStatus = ""
local state: RoundState.RoundState? = nil
local participants: { [number]: Player } = {}
local winner: Types.Winner? = nil
local winReason: Types.WinReason? = nil
local abandoned = false
local skipRequested = false
local forceStartRequested = false
local lastVote: VoteLogic.TallyResult? = nil

-- Helpers ------------------------------------------------------------------

local isDebug = RoleService.isDebug

local function duration(seconds: number): number
	if isDebug() then
		return math.max(1, seconds * Config.Debug.DurationScale)
	end
	return seconds
end

local function phasePayload(): { [string]: any }
	return {
		phase = phase,
		endsAt = phaseEndsAt,
		round = if state then state.round else 0,
		totalRounds = Config.RoundsUntilSunrise,
		lobbyStatus = lobbyStatus,
	}
end

local function setPhase(newPhase: Phase, seconds: number)
	phase = newPhase
	phaseEndsAt = if seconds > 0 then workspace:GetServerTimeNow() + seconds else 0
	RemoteService.fireAll("PhaseChanged", phasePayload())
end

-- Public player list. Never contains roles.
local function playersPayload(): { { [string]: any } }
	local list = {}
	local s = state
	if s then
		for _, id in s.order do
			local entry = s.players[id]
			table.insert(
				list,
				{ userId = id, name = entry.name, alive = entry.alive, connected = entry.connected }
			)
		end
	end
	return list
end

local function broadcastPlayers()
	RemoteService.fireAll("PlayersUpdated", playersPayload())
end

local function aliveSet(): { [number]: boolean }
	local set = {}
	if state then
		for _, id in state:aliveIds() do
			set[id] = true
		end
	end
	return set
end

local function alivePlayers(): { Player }
	local list = {}
	if state then
		for _, id in state:aliveIds() do
			local player = participants[id]
			if player and player.Parent then
				table.insert(list, player)
			end
		end
	end
	return list
end

local function message(player: Player, text: string)
	RemoteService.fire("PrivateMessage", player, text)
end

local function sendShapeshifterState()
	local s = state
	if not s then
		return
	end
	for _, id in s:shapeshifterIds() do
		local player = participants[id]
		if player and player.Parent then
			local targets = {}
			for _, other in s:aliveIds() do
				if other ~= id then
					table.insert(targets, { userId = other, name = s.players[other].name })
				end
			end
			RemoteService.fire("ShapeshifterState", player, {
				active = phase == "Blackout" and s:isAlive(id),
				actionsLeft = s.actionsLeft,
				targets = targets,
			})
		end
	end
end

-- True once a side has won or every participant has left.
local function gameOver(): boolean
	local s = state
	if not s then
		-- No game running, so the lobby, countdown and results screens always run their full time.
		return false
	end
	if winner or abandoned then
		return true
	end
	local anyone = false
	for _, player in participants do
		if player.Parent then
			anyone = true
			break
		end
	end
	if not anyone then
		abandoned = true
		return true
	end
	if isDebug() and Config.Debug.DisableWinCheck then
		return false
	end
	local w, reason = s:checkWinner()
	if w then
		winner, winReason = w, reason
		return true
	end
	return false
end

-- Waits out a phase. Ends early on debug skip, game over, or `stopWhen`.
local function waitPhase(seconds: number, stopWhen: (() -> boolean)?, ignoreGameOver: boolean?)
	skipRequested = false
	local deadline = os.clock() + seconds
	while os.clock() < deadline do
		if skipRequested then
			return
		end
		if not ignoreGameOver and gameOver() then
			return
		end
		if stopWhen and stopWhen() then
			return
		end
		task.wait(0.2)
	end
end

local function eligiblePlayers(): { Player }
	local list = {}
	for _, player in Players:GetPlayers() do
		if DataService.isLoaded(player) then
			table.insert(list, player)
		end
	end
	return list
end

local function neededPlayers(): number
	return if isDebug() then Config.Debug.MinPlayers else Config.MinPlayers
end

local function isPrivateServerOwner(player: Player): boolean
	return game.PrivateServerId ~= "" and game.PrivateServerOwnerId == player.UserId
end

-- Lobby --------------------------------------------------------------------

local function enoughPlayers(count: number): boolean
	return count >= neededPlayers() or (forceStartRequested and count >= Config.PrivateServerMinPlayers)
end

local function runLobby()
	forceStartRequested = false
	lobbyStatus = ""
	setPhase("Lobby", 0)
	while true do
		local have = #eligiblePlayers()
		if enoughPlayers(have) then
			lobbyStatus = ""
			local seconds = duration(Config.LobbyCountdown)
			setPhase("Countdown", seconds)
			local cancelled = false
			waitPhase(seconds, function()
				if not enoughPlayers(#eligiblePlayers()) then
					cancelled = true
					return true
				end
				return false
			end)
			if not cancelled then
				return
			end
			setPhase("Lobby", 0)
		else
			local text = `Waiting for players ({have}/{neededPlayers()})`
			if text ~= lobbyStatus then
				lobbyStatus = text
				RemoteService.fireAll("PhaseChanged", phasePayload())
			end
		end
		task.wait(1)
	end
end

-- Game phases --------------------------------------------------------------

local function runSetup()
	winner, winReason, abandoned, lastVote = nil, nil, false, nil

	local players = eligiblePlayers()
	while #players > Config.MaxPlayers do
		table.remove(players)
	end
	participants = {}
	for _, player in players do
		participants[player.UserId] = player
	end

	local roles = RoleService.assign(players, rng)
	local s = RoundState.new({
		roundsUntilSunrise = Config.RoundsUntilSunrise,
		shapeshifterWinsAtFriendsAlive = Config.ShapeshifterWinsAtFriendsAlive,
		actionsPerBlackout = Config.ShapeshifterActionsPerBlackout,
	})
	for _, player in players do
		s:addPlayer(player.UserId, player.DisplayName, roles[player.UserId])
	end
	state = s

	local itemState = ItemService.setup(players, rng)
	MemoryService.generate(itemState, players, rng)
	MapService.teleportToSpawns(players)

	for _, player in players do
		RoleService.reveal(
			player,
			roles[player.UserId],
			MemoryService.get(player.UserId),
			MemoryService.getShared(player.UserId)
		)
	end
	broadcastPlayers()

	local seconds = duration(Config.SetupDuration)
	setPhase("Setup", seconds)
	waitPhase(seconds)
end

local function runExplore()
	local total = duration(Config.ExploreDuration)
	local flicker = math.min(duration(Config.FlickerDuration), total)
	setPhase("Explore", total)
	waitPhase(total - flicker)
	if not gameOver() then
		LightingService.flicker(flicker)
	end
end

local function runBlackout()
	local s = state :: RoundState.RoundState
	DisguiseService.revertAll()
	s:startBlackout()
	LightingService.blackout()
	for _, player in alivePlayers() do
		LightingService.giveFlashlight(player, MonetizationService.getFlashlightColor(player))
	end

	local seconds = duration(Config.BlackoutDuration)
	setPhase("Blackout", seconds)
	sendShapeshifterState()
	waitPhase(seconds)

	s:endBlackout()
	for _, player in Players:GetPlayers() do
		LightingService.removeFlashlight(player)
	end
	LightingService.restore()
	sendShapeshifterState()
end

local function runInvestigate()
	local seconds = duration(Config.InvestigateDuration)
	setPhase("Investigate", seconds)
	waitPhase(seconds)
end

local function runDiscussion()
	MapService.teleportToMeeting(alivePlayers())
	local seconds = duration(Config.DiscussionDuration)
	setPhase("Discussion", seconds)
	waitPhase(seconds)
end

local function runVote()
	local s = state :: RoundState.RoundState
	VoteService.start()
	local seconds = duration(Config.VoteDuration)
	setPhase("Vote", seconds)
	waitPhase(seconds, function()
		return VoteService.allVoted(s:aliveIds())
	end)
	lastVote = VoteService.finish(aliveSet())
end

local function runVoteResult()
	local s = state :: RoundState.RoundState
	local result = lastVote or VoteLogic.tally({}, {})
	local payload: { [string]: any } = { outcome = result.outcome, counts = {} }
	for target, count in result.counts do
		local entry = s.players[target]
		local name = if target == VoteLogic.SKIP then "Skip" elseif entry then entry.name else "?"
		table.insert(payload.counts, { userId = target, name = name, count = count })
	end

	local eliminatedId = result.eliminatedId
	if eliminatedId then
		local entry = s:eliminate(eliminatedId)
		if entry then
			payload.userId = eliminatedId
			payload.name = entry.name
			if Config.RevealRoleOnVote then
				payload.wasShapeshifter = entry.role == "Shapeshifter"
			end
			local player = participants[eliminatedId]
			if player then
				DisguiseService.revert(player)
				LightingService.removeFlashlight(player)
				GhostService.makeGhost(player)
			end
		end
	end

	RemoteService.fireAll("VoteResult", payload)
	broadcastPlayers()
	local seconds = duration(Config.VoteResultDuration)
	setPhase("VoteResult", seconds)
	-- Let everyone read the result even if this vote decided the game.
	waitPhase(seconds, nil, true)
	s:completeMeeting()
end

local HANDLERS: { [Phase]: () -> () } = {
	Setup = runSetup,
	Explore = runExplore,
	Blackout = runBlackout,
	Investigate = runInvestigate,
	Discussion = runDiscussion,
	Vote = runVote,
	VoteResult = runVoteResult,
}

local function runGame()
	local current: Phase = "Setup"
	while current ~= "Results" do
		HANDLERS[current]()
		current = PhaseLogic.next(current, gameOver())
	end
end

local function recordStats(s: RoundState.RoundState)
	for id, entry in s.players do
		local player = participants[id]
		if player and player.Parent then
			local won = (winner == "Friends" and entry.role == "Friend")
				or (winner == "Shapeshifter" and entry.role == "Shapeshifter")
			DataService.update(player, function(d)
				d.gamesPlayed += 1
				if entry.role == "Shapeshifter" then
					d.gamesAsShapeshifter += 1
				end
				if won then
					d.wins += 1
					if entry.role == "Shapeshifter" then
						d.winsAsShapeshifter += 1
					end
				end
			end)
			MonetizationService.sendProfile(player)
		end
	end
end

local function runResults()
	local s = state
	local names = {}
	if s then
		for _, id in s:shapeshifterIds() do
			table.insert(names, s.players[id].name)
		end
	end
	RemoteService.fireAll("GameOver", {
		winner = winner,
		reason = if abandoned then "Abandoned" else winReason,
		shapeshifters = names,
	})
	if s and winner and not abandoned and not isDebug() then
		recordStats(s)
	end

	-- Reset the house.
	DisguiseService.revertAll()
	for _, player in Players:GetPlayers() do
		LightingService.removeFlashlight(player)
	end
	LightingService.restore()
	ItemService.cleanup()
	MemoryService.clear()
	GhostService.clearAll()
	state = nil
	participants = {}
	broadcastPlayers()

	local seconds = duration(Config.ResultsDuration)
	setPhase("Results", seconds)
	-- Fresh characters clear ghost looks and disguises completely.
	for _, player in Players:GetPlayers() do
		task.spawn(function()
			player:LoadCharacter()
		end)
	end
	waitPhase(seconds)
end

-- Requests from clients ----------------------------------------------------

local function onItemTriggered(player: Player, itemId: string)
	local s = state
	local items = ItemService.getState()
	if not s or not items or not PhaseLogic.canInspect(phase) or not s:isAlive(player.UserId) then
		return
	end

	if phase == "Blackout" and s:canAct(player.UserId) then
		local partner = ItemLogic.pickSwapPartner(items, itemId, rng)
		if not partner then
			message(player, "There's nothing in another room to swap this with.")
			return
		end
		local a, b = items.items[itemId], items.items[partner]
		local fromRoom, toRoom = a.currentRoom, b.currentRoom
		if s:useAction(player.UserId) and ItemService.swap(itemId, partner) then
			message(player, `You swapped the {a.name} in the {fromRoom} with the {b.name} in the {toRoom}.`)
			sendShapeshifterState()
		end
		return
	end

	local result = ItemLogic.inspect(items, itemId, player.UserId)
	if not result then
		return
	end
	if result.kind == "OwnMoved" then
		message(
			player,
			`Your {result.name} isn't where you left it! You left it in the {result.previousRoom}.`
		)
	elseif result.kind == "OwnInPlace" then
		message(player, `Your {result.name}. Right where you left it.`)
	elseif result.kind == "Other" then
		local owner = result.ownerId and s.players[result.ownerId]
		message(player, `{if owner then owner.name else "Someone"}'s {result.name}.`)
	else
		message(player, `A {result.name}. Nobody claims it.`)
	end
end

local function syncPlayer(player: Player)
	RemoteService.fire("PhaseChanged", player, phasePayload())
	RemoteService.fire("PlayersUpdated", player, playersPayload())
	local s = state
	if s and participants[player.UserId] then
		local entry = s.players[player.UserId]
		RoleService.reveal(
			player,
			entry.role,
			MemoryService.get(player.UserId),
			MemoryService.getShared(player.UserId)
		)
		if entry.role == "Shapeshifter" then
			sendShapeshifterState()
		end
	end
	MonetizationService.sendProfile(player)
end

local function registerRemotes()
	RemoteService.on("RequestSync", syncPlayer)

	RemoteService.on("CastVote", function(player, targetId)
		local s = state
		if not s or phase ~= "Vote" or not RemoteService.isInteger(targetId, 0) then
			return
		end
		local ok, err = VoteService.cast(player.UserId, targetId, aliveSet())
		if not ok then
			local reasons = {
				NotAlive = "Ghosts can't vote.",
				AlreadyVoted = "You already voted.",
				InvalidTarget = "That player can't be voted for.",
				SelfVote = "You can't vote for yourself.",
			}
			message(player, reasons[err or ""] or "Your vote didn't count.")
		end
	end)

	RemoteService.on("ShareMemory", function(player, index)
		local s = state
		if not s or not RemoteService.isInteger(index, 1, 20) then
			return
		end
		if phase ~= "Discussion" and phase ~= "Vote" then
			message(player, "You can share memories during the meeting.")
			return
		end
		if not s:isAlive(player.UserId) then
			return
		end
		if not MemoryService.share(player, index) then
			message(player, "You already shared that memory.")
		end
	end)

	RemoteService.on("ShapeshifterAction", function(player, action, targetId)
		local s = state
		if
			not s
			or phase ~= "Blackout"
			or action ~= "Disguise"
			or not RemoteService.isInteger(targetId, 1)
		then
			return
		end
		if targetId == player.UserId or not s:isAlive(targetId) then
			return
		end
		local target = participants[targetId]
		if not target or not target.Parent then
			return
		end
		-- Spend first so rapid requests can't disguise twice while ApplyDescription yields.
		if not s:useAction(player.UserId) then
			return
		end
		if DisguiseService.disguise(player, target) then
			message(player, `You now look like {target.DisplayName}. It wears off at the next blackout.`)
		else
			s.actionsLeft += 1
			message(player, "The disguise didn't take. Try again.")
		end
		sendShapeshifterState()
	end)

	RemoteService.on("DebugSkipPhase", function()
		if isDebug() then
			skipRequested = true
		end
	end)

	RemoteService.on("PrivateServerStart", function(player)
		if not isPrivateServerOwner(player) or (phase ~= "Lobby" and phase ~= "Countdown") then
			return
		end
		if #eligiblePlayers() < Config.PrivateServerMinPlayers then
			message(player, `You need at least {Config.PrivateServerMinPlayers} players to start.`)
			return
		end
		forceStartRequested = true
	end)
end

-- Player lifecycle ----------------------------------------------------------

local function onCharacter(player: Player, character: Model)
	DisguiseService.forget(player)
	if not character:WaitForChild("HumanoidRootPart", 10) then
		return
	end
	local s = state
	if s and participants[player.UserId] then
		if s:isAlive(player.UserId) and PhaseLogic.isMeeting(phase) then
			MapService.teleportToMeeting({ player })
		else
			MapService.teleportToSpawns({ player })
		end
		if phase == "Blackout" and s:isAlive(player.UserId) then
			LightingService.giveFlashlight(player, MonetizationService.getFlashlightColor(player))
		end
	else
		MapService.teleportToLobby({ player })
	end
end

local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function(character)
		onCharacter(player, character)
	end)
	if player.Character then
		task.spawn(onCharacter, player, player.Character)
	end
end

function RoundService.init()
	ItemService.setTriggerHandler(onItemTriggered)
	MonetizationService.setCanChangeCosmetics(function()
		return not PhaseLogic.isInGame(phase)
	end)
	MonetizationService.setExtraProfileInfo(function(player)
		return { isDebug = isDebug(), isPrivateServerOwner = isPrivateServerOwner(player) }
	end)
	-- Ghost messages only reach other ghosts and people outside the game.
	ChatService.setFilter(function(senderId, recipientId)
		local s = state
		if not s then
			return true
		end
		local sender = s.players[senderId]
		if sender and not sender.alive then
			return not s:isAlive(recipientId)
		end
		return true
	end)

	registerRemotes()

	Players.PlayerAdded:Connect(onPlayerAdded)
	for _, player in Players:GetPlayers() do
		onPlayerAdded(player)
	end
	Players.PlayerRemoving:Connect(function(player)
		local s = state
		if s and participants[player.UserId] then
			s:removePlayer(player.UserId)
			DisguiseService.forget(player)
			broadcastPlayers()
			sendShapeshifterState()
		end
	end)
end

function RoundService.start()
	task.spawn(function()
		while true do
			runLobby()
			local ok, err = pcall(runGame)
			if not ok then
				warn(`[FakeFriend] Game stopped by an error: {err}`)
				abandoned = true
			end
			runResults()
		end
	end)
end

return RoundService
