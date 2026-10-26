--!strict
-- Client entry point: wires remotes into State, and mounts every UI module.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage:WaitForChild("Shared").Remotes)
local State = require(script.State)
local Prompts = require(script.Prompts)
local UI = script.UI
local Kit = require(UI.Kit)
local Hud = require(UI.Hud)
local Toasts = require(UI.Toasts)
local RoleReveal = require(UI.RoleReveal)
local Memories = require(UI.Memories)
local ShapeshifterPanel = require(UI.ShapeshifterPanel)
local VotePanel = require(UI.VotePanel)
local Results = require(UI.Results)
local Lobby = require(UI.Lobby)
local DebugPanel = require(UI.DebugPanel)

local myId = Players.LocalPlayer.UserId

local function send(name: string, ...: any)
	Remotes.get(name):FireServer(...)
end

local function on(name: string, handler: (...any) -> ())
	Remotes.get(name).OnClientEvent:Connect(handler)
end

-- UI -------------------------------------------------------------------------
Hud.mount()
Toasts.mount()
RoleReveal.mount()
Memories.mount(function(index)
	send("ShareMemory", index)
end)
ShapeshifterPanel.mount(function(userId)
	send("ShapeshifterAction", "Disguise", userId)
end)
VotePanel.mount(function(targetId)
	-- Optimistic lock so double taps don't send twice. The server has the final say.
	State.set({ myVote = targetId })
	send("CastVote", targetId)
end)
Results.mount()
Lobby.mount(function(slot, id)
	send("EquipCosmetic", slot, id)
end, function()
	send("PrivateServerStart")
end)
DebugPanel.mount(function()
	send("DebugSkipPhase")
end)
Prompts.mount()

-- Server events ----------------------------------------------------------------
on("PhaseChanged", function(payload)
	local previous = State.data.phase
	if payload.phase == "Lobby" or (payload.phase == "Countdown" and previous ~= "Countdown") then
		State.resetGame()
	end
	local patch: { [string]: any } = {
		phase = payload.phase,
		endsAt = payload.endsAt,
		round = payload.round,
		totalRounds = payload.totalRounds,
		lobbyStatus = payload.lobbyStatus,
	}
	if payload.phase == "Vote" and previous ~= "Vote" then
		patch.myVote = false
		patch.voted = {}
	end
	if payload.phase == "Blackout" and previous ~= "Blackout" then
		Toasts.show("The lights went out!", Kit.Colors.Danger)
	end
	State.set(patch)
end)

on("PlayersUpdated", function(list)
	State.set({ players = list })
end)

on("RoleAssigned", function(payload)
	State.set({ role = payload.role, memories = payload.memories, shared = payload.shared })
end)

on("PrivateMessage", function(text)
	Toasts.show(text)
	-- The server rejects bad votes with a message, so unlock voting if ours didn't count.
	if State.data.phase == "Vote" and not table.find(State.data.voted, myId) then
		State.set({ myVote = false })
	end
end)

on("ShapeshifterState", function(payload)
	State.set({ shapeshifter = payload })
end)

on("VoteUpdate", function(payload)
	local patch: { [string]: any } = { voted = payload.voted }
	if #payload.voted == 0 then
		patch.myVote = false
	end
	State.set(patch)
end)

on("VoteResult", function(payload)
	State.set({ voteResult = payload })
end)

on("MemoryShared", function(payload)
	local text = `{payload.name} remembers: "{payload.text}"`
	Toasts.show(text, Kit.Colors.Teal)
	Toasts.chat(text)
	if payload.userId == myId then
		Memories.markShared(payload.index)
	end
end)

on("GameOver", function(payload)
	State.set({ gameOver = payload })
end)

on("ProfileUpdate", function(payload)
	State.set({ profile = payload })
end)

-- Ask for the current state, in case we joined mid-game.
send("RequestSync")
