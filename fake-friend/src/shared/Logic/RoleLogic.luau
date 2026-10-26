--!strict
-- Secret role assignment.

local Types = require(script.Parent.Parent.Types)
type Role = Types.Role
type Rng = Types.Rng

local RoleLogic = {}

function RoleLogic.shuffle<T>(list: { T }, rng: Rng): { T }
	local copy = table.clone(list)
	for i = #copy, 2, -1 do
		local j = rng(1, i)
		copy[i], copy[j] = copy[j], copy[i]
	end
	return copy
end

-- Returns a role for every id. `forced` pins specific players to a role (debug mode).
function RoleLogic.assign(
	ids: { number },
	shapeshifterCount: number,
	rng: Rng,
	forced: { [number]: Role }?
): { [number]: Role }
	local roles: { [number]: Role } = {}
	local count = math.clamp(shapeshifterCount, 0, math.max(#ids - 1, 0))
	if #ids == 1 then
		count = 0
	end

	local pool = {}
	for _, id in ids do
		local pinned = forced and forced[id]
		if pinned then
			roles[id] = pinned
			if pinned == "Shapeshifter" then
				count -= 1
			end
		else
			table.insert(pool, id)
		end
	end

	local shuffled = RoleLogic.shuffle(pool, rng)
	for index, id in shuffled do
		roles[id] = if index <= count then "Shapeshifter" else "Friend"
	end
	return roles
end

return RoleLogic
