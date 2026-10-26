--!strict
-- Pure session-lock rules for player data, so two servers never write the same
-- profile at once. DataService runs these inside DataStore:UpdateAsync callbacks.

export type Lock = { jobId: string, time: number }
export type Record = { data: { [string]: any }, lock: Lock? }

local SessionLock = {}

local function deepCopy(value: any): any
	if type(value) ~= "table" then
		return value
	end
	local out = {}
	for k, v in value do
		out[k] = deepCopy(v)
	end
	return out
end

-- Fills keys missing from `data` with copies of `defaults`. Never removes keys.
function SessionLock.reconcile(data: { [string]: any }?, defaults: { [string]: any }): { [string]: any }
	local result = if data then deepCopy(data) else {}
	for key, value in defaults do
		if result[key] == nil then
			result[key] = deepCopy(value)
		elseif type(value) == "table" and type(result[key]) == "table" and next(value) ~= nil then
			-- Only recurse into record-like defaults; empty tables are open collections.
			result[key] = SessionLock.reconcile(result[key], value)
		end
	end
	return result
end

local function lockedByOther(stored: Record?, jobId: string, now: number, timeout: number): boolean
	local lock = stored and stored.lock
	return lock ~= nil and lock.jobId ~= jobId and now - lock.time < timeout
end

function SessionLock.acquire(
	stored: Record?,
	defaults: { [string]: any },
	jobId: string,
	now: number,
	timeout: number
): ("Acquired" | "Locked", Record?)
	if lockedByOther(stored, jobId, now, timeout) then
		return "Locked", nil
	end
	return "Acquired",
		{
			data = SessionLock.reconcile(stored and stored.data, defaults),
			lock = { jobId = jobId, time = now },
		}
end

-- Saves only while this server still owns the lock.
function SessionLock.save(
	stored: Record?,
	jobId: string,
	now: number,
	data: { [string]: any }
): ("Saved" | "Stolen", Record?)
	local lock = stored and stored.lock
	if lock and lock.jobId ~= jobId then
		return "Stolen", nil
	end
	return "Saved", { data = deepCopy(data), lock = { jobId = jobId, time = now } }
end

function SessionLock.release(
	stored: Record?,
	jobId: string,
	data: { [string]: any }
): ("Released" | "Stolen", Record?)
	local lock = stored and stored.lock
	if lock and lock.jobId ~= jobId then
		return "Stolen", nil
	end
	return "Released", { data = deepCopy(data), lock = nil }
end

return SessionLock
