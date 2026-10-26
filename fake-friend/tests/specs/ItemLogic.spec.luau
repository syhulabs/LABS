local ItemLogic = requireShared("Logic/ItemLogic")

local function newItems()
	return ItemLogic.new({
		{ id = "a", name = "blue pillow", room = "Attic" },
		{ id = "b", name = "phone", room = "Kitchen" },
		{ id = "c", name = "teddy bear", room = "Attic" },
		{ id = "d", name = "snacks", room = "Garage" },
	})
end

describe("ItemLogic", function()
	it("gives each player items and reports shortages", function()
		local state = newItems()
		local short = ItemLogic.assignOwners(state, { 1, 2, 3 }, 1, seededRng(1))
		expect(short).toBe(0)
		expect(#ItemLogic.ownedBy(state, 1)).toBe(1)
		expect(#ItemLogic.ownedBy(state, 3)).toBe(1)

		local state2 = newItems()
		expect(ItemLogic.assignOwners(state2, { 1, 2, 3 }, 2, seededRng(1))).toBe(1)
	end)

	it("the owner notices a moved item exactly once", function()
		local state = newItems()
		state.items.a.ownerId = 1
		state.items.b.ownerId = 2
		expect(ItemLogic.inspect(state, "a", 1).kind).toBe("OwnInPlace")
		ItemLogic.swap(state, "a", "b")
		local result = ItemLogic.inspect(state, "a", 1)
		expect(result.kind).toBe("OwnMoved")
		expect(result.previousRoom).toBe("Attic")
		expect(result.room).toBe("Kitchen")
		expect(ItemLogic.inspect(state, "a", 1).kind).toBe("OwnInPlace")
	end)

	it("other players only learn whose item it is", function()
		local state = newItems()
		state.items.a.ownerId = 1
		local result = ItemLogic.inspect(state, "a", 2)
		expect(result.kind).toBe("Other")
		expect(result.ownerId).toBe(1)
		expect(ItemLogic.inspect(state, "d", 2).kind).toBe("Unowned")
		expect(ItemLogic.inspect(state, "zzz", 2)).toBeNil()
	end)

	it("swap partners are always in another room", function()
		local state = newItems()
		for seed = 1, 30 do
			local partner = ItemLogic.pickSwapPartner(state, "a", seededRng(seed))
			expect(partner ~= nil).toBe(true)
			expect(state.items[partner].currentRoom ~= "Attic").toBe(true)
		end
	end)

	it("returns no partner when every item is in the same room", function()
		local state = ItemLogic.new({
			{ id = "x", name = "x", room = "Hall" },
			{ id = "y", name = "y", room = "Hall" },
		})
		expect(ItemLogic.pickSwapPartner(state, "x", seededRng(1))).toBeNil()
	end)

	it("refuses to swap an item with itself or a missing item", function()
		local state = newItems()
		expect(ItemLogic.swap(state, "a", "a")).toBe(false)
		expect(ItemLogic.swap(state, "a", "nope")).toBe(false)
	end)
end)
