local SessionLock = requireShared("Logic/SessionLock")

local DEFAULTS = { wins = 0, stats = { games = 0, asShapeshifter = 0 }, granted = {} }

describe("SessionLock", function()
	it("creates fresh data for a new player", function()
		local status, record = SessionLock.acquire(nil, DEFAULTS, "job1", 100, 600)
		expect(status).toBe("Acquired")
		expect(record.data).toEqual(DEFAULTS)
		expect(record.lock.jobId).toBe("job1")
	end)

	it("adds new default fields without losing old data", function()
		local stored = { data = { wins = 7, stats = { games = 3 }, granted = { Pajamas_Dino = true } } }
		local _, record = SessionLock.acquire(stored, DEFAULTS, "job1", 100, 600)
		expect(record.data.wins).toBe(7)
		expect(record.data.stats.games).toBe(3)
		expect(record.data.stats.asShapeshifter).toBe(0)
		expect(record.data.granted.Pajamas_Dino).toBe(true)
	end)

	it("refuses a fresh lock held by another server", function()
		local stored = { data = {}, lock = { jobId = "other", time = 100 } }
		local status, record = SessionLock.acquire(stored, DEFAULTS, "job1", 200, 600)
		expect(status).toBe("Locked")
		expect(record).toBeNil()
	end)

	it("takes over an abandoned lock", function()
		local stored = { data = { wins = 2 }, lock = { jobId = "other", time = 100 } }
		local status, record = SessionLock.acquire(stored, DEFAULTS, "job1", 800, 600)
		expect(status).toBe("Acquired")
		expect(record.data.wins).toBe(2)
	end)

	it("re-acquires its own lock", function()
		local stored = { data = {}, lock = { jobId = "job1", time = 100 } }
		expect(SessionLock.acquire(stored, DEFAULTS, "job1", 150, 600)).toBe("Acquired")
	end)

	it("does not save or release after the lock was stolen", function()
		local stored = { data = {}, lock = { jobId = "thief", time = 100 } }
		expect(SessionLock.save(stored, "job1", 150, { wins = 1 })).toBe("Stolen")
		expect(SessionLock.release(stored, "job1", { wins = 1 })).toBe("Stolen")
	end)

	it("saves and releases its own lock", function()
		local stored = { data = {}, lock = { jobId = "job1", time = 100 } }
		local status, record = SessionLock.save(stored, "job1", 150, { wins = 1 })
		expect(status).toBe("Saved")
		expect(record.lock.time).toBe(150)
		status, record = SessionLock.release(stored, "job1", { wins = 1 })
		expect(status).toBe("Released")
		expect(record.lock).toBeNil()
		expect(record.data.wins).toBe(1)
	end)
end)
