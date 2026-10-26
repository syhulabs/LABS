--!strict
-- Runs one meeting vote on top of VoteLogic.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local VoteLogic = require(Shared.Logic.VoteLogic)
local RemoteService = require(script.Parent.RemoteService)

local VoteService = {}

local votes: VoteLogic.Votes? = nil

function VoteService.start()
	votes = VoteLogic.new()
	RemoteService.fireAll("VoteUpdate", { voted = {} })
end

local function votedList(): { number }
	local list = {}
	if votes then
		for voter in votes do
			table.insert(list, voter)
		end
	end
	return list
end

-- `alive` is the current alive set from RoundState.
function VoteService.cast(voterId: number, targetId: number, alive: { [number]: boolean }): (boolean, string?)
	if not votes then
		return false, "NoVote"
	end
	local ok, err = VoteLogic.cast(votes, voterId, targetId, alive, Config.AllowSelfVote)
	if ok then
		-- Everyone sees who has voted, never who they voted for, until the result.
		RemoteService.fireAll("VoteUpdate", { voted = votedList() })
	end
	return ok, err
end

function VoteService.allVoted(aliveIds: { number }): boolean
	return votes ~= nil and VoteLogic.allVoted(votes, aliveIds)
end

function VoteService.finish(alive: { [number]: boolean }): VoteLogic.TallyResult
	local result = VoteLogic.tally(votes or VoteLogic.new(), alive)
	votes = nil
	return result
end

function VoteService.isOpen(): boolean
	return votes ~= nil
end

return VoteService
