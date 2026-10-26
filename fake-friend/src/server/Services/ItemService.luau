--!strict
-- Links tagged map items to ItemLogic, adds inspect prompts and moves items on swaps.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local Types = require(Shared.Types)
local ItemLogic = require(Shared.Logic.ItemLogic)
local MapService = require(script.Parent.MapService)

local ItemService = {}

local PROMPT_NAME = "FakeFriendItemPrompt"

local itemState: ItemLogic.ItemState? = nil
local instances: { [string]: PVInstance } = {}
local originalPivots: { [string]: CFrame } = {}
local connections: { RBXScriptConnection } = {}
local onTriggered: ((Player, string) -> ())? = nil

-- RoundService decides what a trigger means (inspect or swap).
function ItemService.setTriggerHandler(handler: (Player, string) -> ())
	onTriggered = handler
end

function ItemService.setup(players: { Player }, rng: Types.Rng): ItemLogic.ItemState
	ItemService.cleanup()

	local list = {}
	for index, inst in MapService.getItems() do
		local id = `Item{index}`
		local pivot = inst:GetPivot()
		local room = MapService.roomAt(pivot.Position)
		if not room then
			warn(
				`[FakeFriend] Item "{inst:GetFullName()}" is not inside any Room part. It is labelled "the house".`
			)
		end
		instances[id] = inst
		originalPivots[id] = pivot
		inst:SetAttribute("ItemId", id)
		table.insert(list, { id = id, name = MapService.itemName(inst), room = room or "house" })
	end

	local state = ItemLogic.new(list)
	local ids = {}
	local byId: { [number]: Player } = {}
	for _, player in players do
		table.insert(ids, player.UserId)
		byId[player.UserId] = player
	end
	local short = ItemLogic.assignOwners(state, ids, Config.ItemsPerPlayer, rng)
	if short > 0 then
		warn(
			`[FakeFriend] Not enough items: {short} player(s) own fewer than {Config.ItemsPerPlayer}. Tag more items.`
		)
	end

	for id, inst in instances do
		local item = state.items[id]
		local owner = item.ownerId and byId[item.ownerId]
		inst:SetAttribute("Owner", if owner then owner.DisplayName else "")
		inst:SetAttribute("OwnerUserId", item.ownerId or 0)

		local parent = MapService.promptParent(inst)
		if parent then
			local prompt = Instance.new("ProximityPrompt")
			prompt.Name = PROMPT_NAME
			prompt.ActionText = "Inspect"
			prompt.ObjectText = item.name
			prompt.HoldDuration = Config.ItemPromptHoldSeconds
			prompt.MaxActivationDistance = Config.ItemPromptDistance
			prompt.RequiresLineOfSight = false
			prompt:SetAttribute("ItemId", id)
			prompt.Parent = parent
			table.insert(
				connections,
				prompt.Triggered:Connect(function(player)
					if onTriggered then
						onTriggered(player, id)
					end
				end)
			)
		end
	end

	itemState = state
	return state
end

function ItemService.getState(): ItemLogic.ItemState?
	return itemState
end

-- Swaps the world positions of two items and their logical rooms.
function ItemService.swap(a: string, b: string): boolean
	local state = itemState
	local instA, instB = instances[a], instances[b]
	if not state or not instA or not instB then
		return false
	end
	if not ItemLogic.swap(state, a, b) then
		return false
	end
	local pivotA, pivotB = instA:GetPivot(), instB:GetPivot()
	instA:PivotTo(pivotB)
	instB:PivotTo(pivotA)
	return true
end

function ItemService.cleanup()
	for _, conn in connections do
		conn:Disconnect()
	end
	table.clear(connections)
	for id, inst in instances do
		if inst.Parent then
			local pivot = originalPivots[id]
			if pivot then
				inst:PivotTo(pivot)
			end
			inst:SetAttribute("ItemId", nil)
			inst:SetAttribute("Owner", nil)
			inst:SetAttribute("OwnerUserId", nil)
			local parent = MapService.promptParent(inst)
			local prompt = parent and parent:FindFirstChild(PROMPT_NAME)
			if prompt then
				prompt:Destroy()
			end
		end
	end
	table.clear(instances)
	table.clear(originalPivots)
	itemState = nil
end

return ItemService
