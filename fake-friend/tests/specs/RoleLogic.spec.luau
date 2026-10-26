local RoleLogic = requireShared("Logic/RoleLogic")

local function count(roles, role)
	local n = 0
	for _, r in roles do
		if r == role then
			n += 1
		end
	end
	return n
end

describe("RoleLogic", function()
	it("assigns exactly one shapeshifter among six players", function()
		for seed = 1, 50 do
			local roles = RoleLogic.assign({ 1, 2, 3, 4, 5, 6 }, 1, seededRng(seed))
			expect(count(roles, "Shapeshifter")).toBe(1)
			expect(count(roles, "Friend")).toBe(5)
		end
	end)

	it("picks different shapeshifters across seeds", function()
		local seen = {}
		for seed = 1, 60 do
			local roles = RoleLogic.assign({ 1, 2, 3, 4, 5, 6 }, 1, seededRng(seed))
			for id, role in roles do
				if role == "Shapeshifter" then
					seen[id] = true
				end
			end
		end
		local distinct = 0
		for _ in seen do
			distinct += 1
		end
		expect(distinct >= 4).toBe(true)
	end)

	it("never makes everyone a shapeshifter", function()
		local roles = RoleLogic.assign({ 1, 2 }, 5, seededRng(3))
		expect(count(roles, "Shapeshifter")).toBe(1)
	end)

	it("respects a forced role and does not add a second shapeshifter", function()
		local roles = RoleLogic.assign({ 1, 2, 3 }, 1, seededRng(9), { [2] = "Shapeshifter" })
		expect(roles[2]).toBe("Shapeshifter")
		expect(count(roles, "Shapeshifter")).toBe(1)
	end)

	it("lets a solo debug player be forced into either role", function()
		expect(RoleLogic.assign({ 7 }, 1, seededRng(1), { [7] = "Shapeshifter" })[7]).toBe("Shapeshifter")
		expect(RoleLogic.assign({ 7 }, 1, seededRng(1))[7]).toBe("Friend")
	end)

	it("shuffle keeps every element", function()
		local out = RoleLogic.shuffle({ 1, 2, 3, 4, 5 }, seededRng(4))
		table.sort(out)
		expect(out).toEqual({ 1, 2, 3, 4, 5 })
	end)
end)
