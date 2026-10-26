local RateLimiter = requireShared("Logic/RateLimiter")

describe("RateLimiter", function()
	it("allows a burst up to capacity, then refills over time", function()
		local now = 0
		local limiter = RateLimiter.new(3, 1, function()
			return now
		end)
		expect(limiter:allow("p")).toBe(true)
		expect(limiter:allow("p")).toBe(true)
		expect(limiter:allow("p")).toBe(true)
		expect(limiter:allow("p")).toBe(false)
		now = 1
		expect(limiter:allow("p")).toBe(true)
		expect(limiter:allow("p")).toBe(false)
		now = 100
		for _ = 1, 3 do
			expect(limiter:allow("p")).toBe(true)
		end
		expect(limiter:allow("p")).toBe(false)
	end)

	it("tracks keys separately", function()
		local limiter = RateLimiter.new(1, 0, function()
			return 0
		end)
		expect(limiter:allow("a")).toBe(true)
		expect(limiter:allow("b")).toBe(true)
		expect(limiter:allow("a")).toBe(false)
		limiter:forget("a")
		expect(limiter:allow("a")).toBe(true)
	end)
end)
