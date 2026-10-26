--!strict
-- Lets the shapeshifter wear another player's look and overhead name.

local DisguiseService = {}

type Original = { description: HumanoidDescription, displayName: string }

local originals: { [Player]: Original } = {}

local function humanoidOf(player: Player): Humanoid?
	local character = player.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

function DisguiseService.disguise(shapeshifter: Player, target: Player): boolean
	local own = humanoidOf(shapeshifter)
	local other = humanoidOf(target)
	if not own or not other or own.Health <= 0 then
		return false
	end
	if not originals[shapeshifter] then
		originals[shapeshifter] = { description = own:GetAppliedDescription(), displayName = own.DisplayName }
	end
	local ok, err = pcall(function()
		own:ApplyDescription(other:GetAppliedDescription())
	end)
	if not ok then
		warn(`[FakeFriend] Disguise failed: {err}`)
		return false
	end
	own.DisplayName = other.DisplayName
	return true
end

function DisguiseService.isDisguised(player: Player): boolean
	return originals[player] ~= nil
end

function DisguiseService.revert(player: Player)
	local original = originals[player]
	if not original then
		return
	end
	originals[player] = nil
	local own = humanoidOf(player)
	if not own then
		return
	end
	local ok, err = pcall(function()
		own:ApplyDescription(original.description)
	end)
	if not ok then
		warn(`[FakeFriend] Disguise revert failed: {err}`)
	end
	own.DisplayName = original.displayName
end

function DisguiseService.revertAll()
	for player in table.clone(originals) do
		DisguiseService.revert(player)
	end
end

-- A respawn already restores the real look; just drop the stored copy.
function DisguiseService.forget(player: Player)
	originals[player] = nil
end

return DisguiseService
