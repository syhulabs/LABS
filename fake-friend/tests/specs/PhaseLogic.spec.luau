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

	it("jumps to Results when the game has ended mid-phase", function()
		expect(PhaseLogic.next("VoteResult", true)).toBe("Results")
		expect(PhaseLogic.next("Blackout", true)).toBe("Results")
		expect(PhaseLogic.next("Setup", true)).toBe("Results")
	end)

	it("ignores the ended flag outside a game", function()
		expect(PhaseLogic.next("Lobby", true)).toBe("Countdown")
		expect(PhaseLogic.next("Results", true)).toBe("Lobby")
	end)

	it("allows inspecting only while roaming", function()
		expect(PhaseLogic.canInspect("Explore")).toBe(true)
		expect(PhaseLogic.canInspect("Blackout")).toBe(true)
		expect(PhaseLogic.canInspect("Investigate")).toBe(true)
		expect(PhaseLogic.canInspect("Vote")).toBe(false)
		expect(PhaseLogic.canInspect("Lobby")).toBe(false)
	end)
end)
