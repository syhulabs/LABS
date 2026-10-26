local ItemLogic = requireShared("Logic/ItemLogic")
local MemoryLogic = requireShared("Logic/MemoryLogic")

local PLAYERS = { { id = 1, name = "Ana" }, { id = 2, name = "Ben" }, { id = 3, name = "Cy" } }

describe("MemoryLogic", function()
	it("gives an own-item memory first, then a memory about someone else", function()
		local state = ItemLogic.new({
			{ id = "a", name = "blue pillow", room = "Attic" },
			{ id = "b", name = "phone", room = "Kitchen" },
			{ id = "c", name = "snacks", room = "Garage" },
		})
		state.items.a.ownerId = 1
		state.items.b.ownerId = 2
		state.items.c.ownerId = 3
		local memories = MemoryLogic.generate(state, PLAYERS, 2, seededRng(5))
		expect(memories[1][1]).toBe("You left your blue pillow in the Attic.")
		expect(#memories[1]).toBe(2)
		expect(string.find(memories[1][2], "^You saw ") ~= nil).toBe(true)
		expect(string.find(memories[1][2], "Ana", 1, true)).toBeNil()
	end)

	it("uses the fallback when there is nothing to remember", function()
		local state = ItemLogic.new({})
		local memories = MemoryLogic.generate(state, PLAYERS, 2, seededRng(1))
		expect(memories[2]).toEqual({ MemoryLogic.FALLBACK })
	end)

	it("never gives more memories than requested", function()
		local state = ItemLogic.new({
			{ id = "a", name = "a", room = "R1" },
			{ id = "b", name = "b", room = "R2" },
			{ id = "c", name = "c", room = "R3" },
		})
		state.items.a.ownerId = 1
		state.items.b.ownerId = 1
		state.items.c.ownerId = 2
		local memories = MemoryLogic.generate(state, PLAYERS, 1, seededRng(2))
		expect(#memories[1]).toBe(1)
		expect(#memories[3]).toBe(1)
	end)
end)
