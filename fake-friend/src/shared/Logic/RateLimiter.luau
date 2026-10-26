--!strict
-- Token bucket per key (usually a player's UserId).

local RateLimiter = {}
RateLimiter.__index = RateLimiter

export type RateLimiter = typeof(setmetatable(
	{} :: {
		capacity: number,
		perSecond: number,
		clock: () -> number,
		buckets: { [any]: { tokens: number, updated: number } },
	},
	RateLimiter
))

function RateLimiter.new(capacity: number, perSecond: number, clock: () -> number): RateLimiter
	return setmetatable(
		{ capacity = capacity, perSecond = perSecond, clock = clock, buckets = {} },
		RateLimiter
	)
end

function RateLimiter.allow(self: RateLimiter, key: any): boolean
	local now = self.clock()
	local bucket = self.buckets[key]
	if not bucket then
		bucket = { tokens = self.capacity, updated = now }
		self.buckets[key] = bucket
	end
	bucket.tokens = math.min(self.capacity, bucket.tokens + (now - bucket.updated) * self.perSecond)
	bucket.updated = now
	if bucket.tokens < 1 then
		return false
	end
	bucket.tokens -= 1
	return true
end

function RateLimiter.forget(self: RateLimiter, key: any)
	self.buckets[key] = nil
end

return RateLimiter
