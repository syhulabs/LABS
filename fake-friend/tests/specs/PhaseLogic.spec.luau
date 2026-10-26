local PhaseLogic = requireShared("Logic/PhaseLogic")

describe("PhaseLogic", function()
	it("walks the full round order", function()
		local order = {
			"Lobby",
			"Countdown",
			"Setup",
			"Explore",
			"Blackout",
			"Investigate",
			"Discussion",
			"Vote",
			"VoteResult",
		}
		for i = 1, #order - 1 do
			expect(PhaseLogic.next(order[i])).toBe(order[i + 1])
		end
		expect(PhaseLogic.next("VoteResult")).toBe("Explore")
		expect(PhaseLogic.next("Results")).toBe("Lobby")
	end)

	it("jumps to Results when someone has won mid-game", function()
		expect(PhaseLogic.next("VoteResult", "Friends")).toBe("Results")
		expect(PhaseLogic.next("Blackout", "Shapeshifter")).toBe("Results")
	end)

	it("ignores a winner outside a game", function()
		expect(PhaseLogic.next("Lobby", "Friends")).toBe("Countdown")
	end)

	it("allows inspecting only while roaming", function()
		expect(PhaseLogic.canInspect("Explore")).toBe(true)
		expect(PhaseLogic.canInspect("Blackout")).toBe(true)
		expect(PhaseLogic.canInspect("Investigate")).toBe(true)
		expect(PhaseLogic.canInspect("Vote")).toBe(false)
		expect(PhaseLogic.canInspect("Lobby")).toBe(false)
	end)
end)
