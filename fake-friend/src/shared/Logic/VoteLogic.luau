--!strict
-- Meeting votes. Target 0 means "skip".

local VoteLogic = {}

VoteLogic.SKIP = 0

export type Votes = { [number]: number } -- voterId -> targetId (0 = skip)

export type TallyResult = {
	counts: { [number]: number },
	eliminatedId: number?,
	outcome: "Eliminated" | "Tie" | "Skipped" | "NoVotes",
}

function VoteLogic.new(): Votes
	return {}
end

-- Returns ok plus an error code when rejected.
function VoteLogic.cast(
	votes: Votes,
	voterId: number,
	targetId: number,
	alive: { [number]: boolean },
	allowSelfVote: boolean
): (boolean, string?)
	if not alive[voterId] then
		return false, "NotAlive"
	end
	if votes[voterId] ~= nil then
		return false, "AlreadyVoted"
	end
	if targetId ~= VoteLogic.SKIP then
		if not alive[targetId] then
			return false, "InvalidTarget"
		end
		if targetId == voterId and not allowSelfVote then
			return false, "SelfVote"
		end
	end
	votes[voterId] = targetId
	return true, nil
end

function VoteLogic.allVoted(votes: Votes, aliveIds: { number }): boolean
	for _, id in aliveIds do
		if votes[id] == nil then
			return false
		end
	end
	return true
end

-- Votes from players who are no longer alive (left mid-vote) are ignored.
function VoteLogic.tally(votes: Votes, alive: { [number]: boolean }): TallyResult
	local counts: { [number]: number } = {}
	local total = 0
	for voter, target in votes do
		if alive[voter] and (target == VoteLogic.SKIP or alive[target]) then
			counts[target] = (counts[target] or 0) + 1
			total += 1
		end
	end

	if total == 0 then
		return { counts = counts, eliminatedId = nil, outcome = "NoVotes" }
	end

	local best, bestCount, tied = nil :: number?, 0, false
	for target, count in counts do
		if count > bestCount then
			best, bestCount, tied = target, count, false
		elseif count == bestCount then
			tied = true
		end
	end

	if tied then
		return { counts = counts, eliminatedId = nil, outcome = "Tie" }
	end
	if best == VoteLogic.SKIP then
		return { counts = counts, eliminatedId = nil, outcome = "Skipped" }
	end
	return { counts = counts, eliminatedId = best, outcome = "Eliminated" }
end

return VoteLogic
