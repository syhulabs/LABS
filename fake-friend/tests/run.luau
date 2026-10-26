--!nocheck
-- Offline test runner for the pure logic modules in src/shared/Logic.
-- Run from the fake-friend folder:  lune run tests/run.luau
--
-- Modules use Roblox-style `require(script.Parent.X)`. This runner fakes `script`
-- with path objects so the same files run in Studio and here, unchanged.

local fs = require("@lune/fs")
local luau = require("@lune/luau")
local process = require("@lune/process")

local SPECS = {
	"tests/specs/PhaseLogic.spec.luau",
	"tests/specs/RoleLogic.spec.luau",
	"tests/specs/RoundState.spec.luau",
	"tests/specs/VoteLogic.spec.luau",
	"tests/specs/ItemLogic.spec.luau",
	"tests/specs/MemoryLogic.spec.luau",
	"tests/specs/RateLimiter.spec.luau",
	"tests/specs/SessionLock.spec.luau",
	"tests/specs/CosmeticLogic.spec.luau",
	"tests/specs/GameFlow.spec.luau",
}

-- Fake instance paths ----------------------------------------------------
local cache = {}
local makeRef

local function parentOf(path: string): string
	return string.match(path, "^(.*)/[^/]+$") or ""
end

makeRef = function(path: string)
	return setmetatable({ __path = path }, {
		__index = function(_, key)
			if key == "Parent" then
				return makeRef(parentOf(path))
			end
			return makeRef(path .. "/" .. key)
		end,
	})
end

local requireRef

local function loadFile(file: string, scriptPath: string)
	-- selene: allow(global_usage)
	local env = setmetatable({ script = makeRef(scriptPath), require = requireRef }, { __index = _G })
	local chunk = luau.load(fs.readFile(file), { debugName = file, environment = env })
	return chunk()
end

requireRef = function(target)
	if type(target) == "string" then
		return require(target)
	end
	local path = rawget(target, "__path")
	if cache[path] == nil then
		local file = path .. ".luau"
		if not fs.isFile(file) then
			file = path .. "/init.luau"
		end
		local result = loadFile(file, path)
		cache[path] = if result == nil then false else result
	end
	return cache[path] or nil
end

-- Tiny test framework ------------------------------------------------------
local passed, failed = 0, 0
local failures = {}
local currentSuite = ""

local function deepEqual(a, b): boolean
	if a == b then
		return true
	end
	if type(a) ~= "table" or type(b) ~= "table" then
		return false
	end
	for k, v in a do
		if not deepEqual(v, b[k]) then
			return false
		end
	end
	for k in b do
		if a[k] == nil then
			return false
		end
	end
	return true
end

local function fmt(v): string
	if type(v) == "string" then
		return string.format("%q", v)
	end
	return tostring(v)
end

local function expect(actual)
	return {
		toBe = function(expected)
			if actual ~= expected then
				error(`expected {fmt(expected)}, got {fmt(actual)}`, 2)
			end
		end,
		toEqual = function(expected)
			if not deepEqual(actual, expected) then
				error("tables are not equal", 2)
			end
		end,
		toBeNil = function()
			if actual ~= nil then
				error(`expected nil, got {fmt(actual)}`, 2)
			end
		end,
		toBeTruthy = function()
			if not actual then
				error(`expected truthy, got {fmt(actual)}`, 2)
			end
		end,
	}
end

local function describe(name: string, fn: () -> ())
	currentSuite = name
	fn()
end

local function it(name: string, fn: () -> ())
	local ok, err = pcall(fn)
	if ok then
		passed += 1
	else
		failed += 1
		table.insert(failures, `{currentSuite} > {name}\n    {err}`)
	end
end

-- Deterministic RNG so tests are repeatable. Same contract as Random:NextInteger.
local function seededRng(seed: number)
	local state = seed
	return function(min: number, max: number): number
		state = (state * 1103515245 + 12345) % 2147483648
		return min + state % (max - min + 1)
	end
end

local helpers = {
	describe = describe,
	it = it,
	expect = expect,
	seededRng = seededRng,
	requireShared = function(name: string)
		return requireRef(makeRef("src/shared/" .. name))
	end,
}

for _, spec in SPECS do
	-- selene: allow(global_usage)
	local env = setmetatable(table.clone(helpers), { __index = _G })
	env.require = require
	local chunk = luau.load(fs.readFile(spec), { debugName = spec, environment = env })
	local ok, err = pcall(chunk)
	if not ok then
		failed += 1
		table.insert(failures, `{spec} failed to load\n    {err}`)
	end
end

for _, f in failures do
	print("FAIL " .. f)
end
print(`\n{passed} passed, {failed} failed`)
process.exit(if failed == 0 then 0 else 1)
