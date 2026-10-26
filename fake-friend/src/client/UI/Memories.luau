--!strict
-- The player's private memory card. During meetings, each memory can be shared once.

local Kit = require(script.Parent.Kit)
local State = require(script.Parent.Parent.State)

local Memories = {}

function Memories.mount(shareMemory: (index: number) -> ())
	local gui = Kit.screen("FakeFriendMemories", 3)
	local toggle = Kit.button("Memories", function() end, {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 12, 1, -12),
		Size = UDim2.fromOffset(150, Kit.MinTouch),
		BackgroundColor3 = Kit.Colors.PanelLight,
		Visible = false,
		Parent = gui,
	})
	local card = Kit.panel({
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 12, 1, -12 - Kit.MinTouch - 8),
		Size = UDim2.new(0.42, 0, 0, 260),
		Visible = false,
		Parent = gui,
	})
	Kit.create(
		"UISizeConstraint",
		{ MinSize = Vector2.new(260, 120), MaxSize = Vector2.new(460, 320), Parent = card }
	)
	Kit.padding(card, 10)
	local content = Kit.create("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 6,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		Parent = card,
	})
	Kit.list(content, 8)

	toggle.Activated:Connect(function()
		card.Visible = not card.Visible
	end)

	State.subscribe(function(data)
		local hasMemories = data.role and #data.memories > 0
		toggle.Visible = hasMemories and true or false
		if not hasMemories then
			card.Visible = false
			return
		end

		Kit.clear(content)
		local canShare = (data.phase == "Discussion" or data.phase == "Vote") and State.isAlive()
		local sharedSet = {}
		for _, index in data.shared do
			sharedSet[index] = true
		end
		for index, text in data.memories do
			local row = Kit.create("Frame", {
				Size = UDim2.new(1, -8, 0, if canShare then 120 else 64),
				BackgroundTransparency = 1,
				LayoutOrder = index,
				Parent = content,
			})
			Kit.list(row, 4)
			Kit.label(text, { Size = UDim2.new(1, 0, 0, 60), Parent = row })
			if canShare then
				if sharedSet[index] then
					Kit.label(
						"Shared with everyone",
						{ TextColor3 = Kit.Colors.Muted, Size = UDim2.new(1, 0, 0, 24), Parent = row }
					)
				else
					Kit.button("Share", function()
						shareMemory(index)
					end, {
						Size = UDim2.new(0.6, 0, 0, Kit.MinTouch),
						BackgroundColor3 = Kit.Colors.Teal,
						Parent = row,
					})
				end
			end
		end
	end)
end

-- Marks a memory as shared on this client once the server confirms it.
function Memories.markShared(index: number)
	local shared = table.clone(State.data.shared)
	if not table.find(shared, index) then
		table.insert(shared, index)
	end
	State.set({ shared = shared })
end

return Memories
