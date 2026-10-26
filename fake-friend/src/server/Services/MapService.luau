--!strict
-- Finds map pieces through CollectionService tags, so the map can be rebuilt freely.

local CollectionService = game:GetService("CollectionService")

local MapService = {}

MapService.Tags = {
	Room = "Room",
	Light = "Light",
	Item = "Item",
	SpawnPoint = "SpawnPoint",
	MeetingSpot = "MeetingSpot",
	LobbySpawn = "LobbySpawn", -- Optional: where people wait between games.
}

local function tagged(tag: string): { Instance }
	return CollectionService:GetTagged(tag)
end

local function taggedParts(tag: string): { BasePart }
	local parts = {}
	for _, inst in tagged(tag) do
		if inst:IsA("BasePart") then
			table.insert(parts, inst)
		else
			warn(`[FakeFriend] "{inst:GetFullName()}" has tag "{tag}" but is not a Part. It is ignored.`)
		end
	end
	return parts
end

-- Prints a clear warning for every missing piece. Returns true if the map can run a game.
function MapService.validate(): boolean
	local ok = true
	local function need(tag: string, why: string)
		if #tagged(tag) == 0 then
			warn(`[FakeFriend] Map is missing tag "{tag}". {why}`)
			ok = false
		end
	end
	need(MapService.Tags.Room, "Add a Part covering each room, tagged Room, with a RoomName attribute.")
	need(
		MapService.Tags.Item,
		"Tag pickup items (Parts or Models) with Item and give them an ItemName attribute."
	)
	need(MapService.Tags.SpawnPoint, "Tag at least one Part as SpawnPoint inside the house.")
	need(MapService.Tags.MeetingSpot, "Tag one Part as MeetingSpot for votes.")
	if #tagged(MapService.Tags.Light) == 0 then
		warn('[FakeFriend] No "Light" tags found. Blackouts will only darken the sky and ambient light.')
	end

	for _, room in taggedParts(MapService.Tags.Room) do
		if room:GetAttribute("RoomName") == nil then
			warn(`[FakeFriend] Room part "{room:GetFullName()}" has no RoomName attribute. Using its Name.`)
		end
		-- Room parts are invisible bounds only.
		room.Anchored = true
		room.CanCollide = false
		room.CanTouch = false
		room.CanQuery = false
		room.Transparency = 1
	end
	for _, item in tagged(MapService.Tags.Item) do
		if not MapService.promptParent(item) then
			warn(`[FakeFriend] Item "{item:GetFullName()}" has no Part to attach a prompt to.`)
		end
	end
	return ok
end

function MapService.roomName(room: BasePart): string
	local attr = room:GetAttribute("RoomName")
	return if type(attr) == "string" and attr ~= "" then attr else room.Name
end

function MapService.roomAt(position: Vector3): string?
	for _, room in taggedParts(MapService.Tags.Room) do
		local localPos = room.CFrame:PointToObjectSpace(position)
		local half = room.Size / 2
		if
			math.abs(localPos.X) <= half.X
			and math.abs(localPos.Y) <= half.Y
			and math.abs(localPos.Z) <= half.Z
		then
			return MapService.roomName(room)
		end
	end
	return nil
end

function MapService.getItems(): { PVInstance }
	local items = {}
	for _, inst in tagged(MapService.Tags.Item) do
		if inst:IsA("PVInstance") then
			table.insert(items, inst)
		end
	end
	return items
end

function MapService.itemName(item: Instance): string
	local attr = item:GetAttribute("ItemName")
	return if type(attr) == "string" and attr ~= "" then attr else item.Name
end

function MapService.promptParent(item: Instance): BasePart?
	if item:IsA("BasePart") then
		return item
	end
	if item:IsA("Model") then
		return item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart", true)
	end
	return nil
end

function MapService.getLightTargets(): { Instance }
	return tagged(MapService.Tags.Light)
end

local function teleport(player: Player, cframe: CFrame)
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		character:PivotTo(cframe + Vector3.new(0, 4, 0))
	end
end

local function spreadAround(players: { Player }, parts: { BasePart })
	if #parts == 0 then
		return
	end
	for index, player in players do
		local part = parts[(index - 1) % #parts + 1]
		-- Offset players sharing one spawn so they don't stack.
		local angle = (index / math.max(#players, 1)) * math.pi * 2
		local offset = if #parts < #players
			then Vector3.new(math.cos(angle) * 4, 0, math.sin(angle) * 4)
			else Vector3.zero
		teleport(player, part.CFrame + offset)
	end
end

function MapService.teleportToSpawns(players: { Player })
	spreadAround(players, taggedParts(MapService.Tags.SpawnPoint))
end

function MapService.teleportToMeeting(players: { Player })
	local spot = taggedParts(MapService.Tags.MeetingSpot)[1]
	if not spot then
		return
	end
	for index, player in players do
		local angle = (index / math.max(#players, 1)) * math.pi * 2
		local radius = math.max(6, #players)
		local position = spot.Position + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
		teleport(player, CFrame.lookAt(position, Vector3.new(spot.Position.X, position.Y, spot.Position.Z)))
	end
end

function MapService.teleportToLobby(players: { Player })
	local lobby = taggedParts(MapService.Tags.LobbySpawn)
	spreadAround(players, if #lobby > 0 then lobby else taggedParts(MapService.Tags.SpawnPoint))
end

return MapService
