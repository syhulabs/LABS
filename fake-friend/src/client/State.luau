--!strict
-- Client-side copy of what the server has told this player. UI modules subscribe to changes.

local Players = game:GetService("Players")

local State = {}

local function fresh(): { [string]: any }
	return {
		phase = "Lobby",
		endsAt = 0,
		round = 0,
		totalRounds = 0,
		lobbyStatus = "",
		players = {},
		role = false, -- false until assigned
		memories = {},
		shared = {},
		shapeshifter = { active = false, actionsLeft = 0, targets = {} },
		voted = {},
		myVote = false,
		voteResult = false,
		gameOver = false,
		profile = false,
	}
end

State.data = fresh()

local listeners: { ({ [string]: any }) -> () } = {}

function State.set(patch: { [string]: any })
	for key, value in patch do
		State.data[key] = value
	end
	for _, listener in listeners do
		task.spawn(listener, State.data)
	end
end

-- Clears everything tied to one game, keeping the phase and profile.
function State.resetGame()
	local keep = { phase = State.data.phase, endsAt = State.data.endsAt, profile = State.data.profile }
	State.data = fresh()
	State.set(keep)
end

function State.subscribe(listener: ({ [string]: any }) -> ())
	table.insert(listeners, listener)
	task.spawn(listener, State.data)
end

function State.myEntry(): { [string]: any }?
	local myId = Players.LocalPlayer.UserId
	for _, entry in State.data.players do
		if entry.userId == myId then
			return entry
		end
	end
	return nil
end

function State.isParticipant(): boolean
	return State.myEntry() ~= nil
end

function State.isAlive(): boolean
	local entry = State.myEntry()
	return entry ~= nil and entry.alive
end

function State.timeLeft(): number
	if State.data.endsAt <= 0 then
		return 0
	end
	return math.max(0, State.data.endsAt - workspace:GetServerTimeNow())
end

return State
