--!strict
-- Players sent home stay as see-through ghosts who can watch but not touch anything.
-- Ghosts pass through living players, so they can't body-block anyone.

local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

local GhostService = {}

local PLAYER_GROUP = "FakeFriendPlayers"
local GHOST_GROUP = "FakeFriendGhosts"
local GHOST_TRANSPARENCY = 0.7

local ghosts: { [Player]: boolean } = {}

local function setGroup(character: Model, group: string)
	for _, d in character:GetDescendants() do
		if d:IsA("BasePart") then
			d.CollisionGroup = group
		end
	end
end

local function applyGhostLook(character: Model)
	for _, d in character:GetDescendants() do
		if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
			d.LocalTransparencyModifier = 0
			d.Transparency = math.max(d.Transparency, GHOST_TRANSPARENCY)
		elseif d:IsA("Decal") then
			d.Transparency = math.max(d.Transparency, GHOST_TRANSPARENCY)
		end
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end
end

function GhostService.init()
	PhysicsService:RegisterCollisionGroup(PLAYER_GROUP)
	PhysicsService:RegisterCollisionGroup(GHOST_GROUP)
	PhysicsService:CollisionGroupSetCollidable(PLAYER_GROUP, GHOST_GROUP, false)
	PhysicsService:CollisionGroupSetCollidable(GHOST_GROUP, GHOST_GROUP, false)
	PhysicsService:CollisionGroupSetCollidable(PLAYER_GROUP, PLAYER_GROUP, true)

	local function onCharacter(player: Player, character: Model)
		local group = if ghosts[player] then GHOST_GROUP else PLAYER_GROUP
		setGroup(character, group)
		character.DescendantAdded:Connect(function(d)
			if d:IsA("BasePart") then
				d.CollisionGroup = if ghosts[player] then GHOST_GROUP else PLAYER_GROUP
			end
		end)
		if ghosts[player] then
			applyGhostLook(character)
		end
	end

	local function onPlayer(player: Player)
		player.CharacterAdded:Connect(function(character)
			onCharacter(player, character)
		end)
		if player.Character then
			onCharacter(player, player.Character)
		end
	end
	Players.PlayerAdded:Connect(onPlayer)
	for _, player in Players:GetPlayers() do
		onPlayer(player)
	end
	Players.PlayerRemoving:Connect(function(player)
		ghosts[player] = nil
	end)
end

function GhostService.makeGhost(player: Player)
	ghosts[player] = true
	player:SetAttribute("Ghost", true)
	local character = player.Character
	if character then
		setGroup(character, GHOST_GROUP)
		applyGhostLook(character)
	end
end

function GhostService.isGhost(player: Player): boolean
	return ghosts[player] == true
end

-- Clears ghost state. The caller respawns characters to restore their look.
function GhostService.clearAll()
	for player in ghosts do
		player:SetAttribute("Ghost", nil)
	end
	table.clear(ghosts)
end

return GhostService
