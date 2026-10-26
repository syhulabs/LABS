-- Plays whole games using only the pure rules, the same way RoundService strings them together.
local PhaseLogic = requireShared("Logic/PhaseLogic")
local RoleLogic = requireShared("Logic/RoleLogic")
local RoundState = requireShared("Logic/RoundState")
local VoteLogic = requireShared("Logic/VoteLogic")
local ItemLogic = requireShared("Logic/ItemLogic")
local MemoryLogic = requireShared("Logic/MemoryLogic")

local RULES = { roundsUntilSunrise = 5, shapeshifterWinsAtFriendsAlive = 2, actionsPerBlackout = 1 }
local IDS = { 1, 2, 3, 4, 5, 6 }

local function setup(seed)
	local rng = seededRng(seed)
	local roles = RoleLogic.assign(IDS, 1, rng)
	local state = RoundState.new(RULES)
	local players = {}
	for _, id in IDS do
		state:addPlayer(id, "P" .. id, roles[id])
		table.insert(players, { id = id, name = "P" .. id })
	end
	local items = ItemLogic.new({
		{ id = "i1", name = "pillow", room = "Attic" },
		{ id = "i2", name = "phone", room = "Kitchen" },
		{ id = "i3", name = "teddy", room = "Bedroom" },
		{ id = "i4", name = "snacks", room = "Garage" },
		{ id = "i5", name = "torch", room = "Basement" },
		{ id = "i6", name = "comic", room = "Living Room" },
	})
	ItemLogic.assignOwners(items, IDS, 1, rng)
	local memories = MemoryLogic.generate(items, players, 2, rng)
	return state, items, memories, rng
end

local function vote(state, target)
	local alive = {}
	for _, id in state:aliveIds() do
		alive[id] = true
	end
	local votes = VoteLogic.new()
	for _, id in state:aliveIds() do
		local pick = if id == target then VoteLogic.SKIP else target
		VoteLogic.cast(votes, id, pick, alive, false)
	end
	local result = VoteLogic.tally(votes, alive)
	if result.eliminatedId then
		state:eliminate(result.eliminatedId)
	end
	state:completeMeeting()
	return result
end

describe("Full game", function()
	it("friends who track a swapped item can catch the shapeshifter", function()
		local state, items, memories, rng = setup(11)
		local fake = state:shapeshifterIds()[1]
		for _, id in IDS do
			expect(#memories[id]).toBe(2)
		end

		state:startBlackout()
		local mine = ItemLogic.ownedBy(items, fake)[1]
		local partner = ItemLogic.pickSwapPartner(items, mine.id, rng)
		expect(state:useAction(fake)).toBe(true)
		expect(ItemLogic.swap(items, mine.id, partner)).toBe(true)
		state:endBlackout()

		local victim = items.items[partner].ownerId
		expect(ItemLogic.inspect(items, partner, victim).kind).toBe("OwnMoved")

		local result = vote(state, fake)
		expect(result.eliminatedId).toBe(fake)
		local phase = PhaseLogic.next("VoteResult", state:checkWinner() ~= nil)
		expect(phase).toBe("Results")
		expect(state:checkWinner()).toBe("Friends")
	end)

	it("the shapeshifter wins by getting friends voted out", function()
		local state = setup(23)
		local fake = state:shapeshifterIds()[1]
		local friends = {}
		for _, id in IDS do
			if id ~= fake then
				table.insert(friends, id)
			end
		end
		vote(state, friends[1])
		expect(state:checkWinner()).toBeNil()
		vote(state, friends[2])
		expect(state:checkWinner()).toBeNil()
		vote(state, friends[3])
		local winner, reason = state:checkWinner()
		expect(winner).toBe("Shapeshifter")
		expect(reason).toBe("Outnumbered")
	end)

	it("the shapeshifter wins at sunrise if every vote is skipped", function()
		local state = setup(5)
		local phase = "Explore"
		local meetings = 0
		while phase ~= "Results" do
			if phase == "VoteResult" then
				state:completeMeeting()
				meetings += 1
			end
			phase = PhaseLogic.next(phase, state:checkWinner() ~= nil)
		end
		expect(meetings).toBe(5)
		local winner, reason = state:checkWinner()
		expect(winner).toBe("Shapeshifter")
		expect(reason).toBe("Sunrise")
	end)
end)
