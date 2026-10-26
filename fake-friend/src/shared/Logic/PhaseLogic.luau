--!strict
-- Order of phases in the round state machine.

local Types = require(script.Parent.Parent.Types)
type Phase = Types.Phase
type Winner = Types.Winner

local PhaseLogic = {}

local NEXT: { [Phase]: Phase } = {
	Lobby = "Countdown",
	Countdown = "Setup",
	Setup = "Explore",
	Explore = "Blackout",
	Blackout = "Investigate",
	Investigate = "Discussion",
	Discussion = "Vote",
	Vote = "VoteResult",
	VoteResult = "Explore",
	Results = "Lobby",
}

-- Phases where the game is running and roles exist.
local IN_GAME: { [Phase]: boolean } = {
	Setup = true,
	Explore = true,
	Blackout = true,
	Investigate = true,
	Discussion = true,
	Vote = true,
	VoteResult = true,
}

function PhaseLogic.next(phase: Phase, winner: Winner?): Phase
	if winner and IN_GAME[phase] then
		return "Results"
	end
	return NEXT[phase]
end

function PhaseLogic.isInGame(phase: Phase): boolean
	return IN_GAME[phase] == true
end

function PhaseLogic.isMeeting(phase: Phase): boolean
	return phase == "Discussion" or phase == "Vote" or phase == "VoteResult"
end

-- Item inspection is allowed whenever players are free to roam.
function PhaseLogic.canInspect(phase: Phase): boolean
	return phase == "Explore" or phase == "Blackout" or phase == "Investigate"
end

return PhaseLogic
