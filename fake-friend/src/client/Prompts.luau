--!strict
-- Local-only tweaks to item prompts: ghosts and spectators can't use them, and the
-- shapeshifter sees "Swap" during blackouts. The server enforces the same rules.

local CollectionService = game:GetService("CollectionService")

local State = require(script.Parent.State)

local Prompts = {}

local PROMPT_NAME = "FakeFriendItemPrompt"
local prompts: { [ProximityPrompt]: boolean } = {}

local function apply(prompt: ProximityPrompt)
	local data = State.data
	local s = data.shapeshifter
	prompt.Enabled = State.isAlive()
	local canSwap = data.role == "Shapeshifter"
		and data.phase == "Blackout"
		and s.active
		and s.actionsLeft > 0
	prompt.ActionText = if canSwap then "Swap" else "Inspect"
end

local function track(inst: Instance)
	if inst:IsA("ProximityPrompt") and inst.Name == PROMPT_NAME and not prompts[inst] then
		prompts[inst] = true
		apply(inst)
		inst.AncestryChanged:Connect(function(_, parent)
			if not parent then
				prompts[inst] = nil
			end
		end)
	end
end

function Prompts.mount()
	local function watchItem(item: Instance)
		for _, d in item:GetDescendants() do
			track(d)
		end
		item.DescendantAdded:Connect(track)
		if item:IsA("ProximityPrompt") then
			track(item)
		end
	end
	for _, item in CollectionService:GetTagged("Item") do
		watchItem(item)
	end
	CollectionService:GetInstanceAddedSignal("Item"):Connect(watchItem)

	State.subscribe(function()
		for prompt in prompts do
			apply(prompt)
		end
	end)
end

return Prompts
