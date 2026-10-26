--!strict
-- Blackout actions for the shapeshifter: copy a player, or swap items through prompts.

local Kit = require(script.Parent.Kit)
local State = require(script.Parent.Parent.State)

local ShapeshifterPanel = {}

function ShapeshifterPanel.mount(disguiseAs: (userId: number) -> ())
	local gui = Kit.screen("FakeFriendShapeshifter", 4)
	local panel = Kit.panel({
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromScale(0.34, 0.6),
		BackgroundColor3 = Color3.fromRGB(48, 18, 40),
		Visible = false,
		Parent = gui,
	})
	Kit.create(
		"UISizeConstraint",
		{ MinSize = Vector2.new(230, 220), MaxSize = Vector2.new(380, 520), Parent = panel }
	)
	Kit.padding(panel, 10)
	Kit.list(panel, 6)

	local header = Kit.title(
		"",
		{ Size = UDim2.new(1, 0, 0, 34), TextColor3 = Kit.Colors.Danger, LayoutOrder = 1, Parent = panel }
	)
	local hint = Kit.label(
		"",
		{ Size = UDim2.new(1, 0, 0, 54), TextColor3 = Kit.Colors.Muted, LayoutOrder = 2, Parent = panel }
	)
	local list = Kit.create("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, -100),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 6,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		LayoutOrder = 3,
		Parent = panel,
	})
	Kit.list(list, 6)

	State.subscribe(function(data)
		local s = data.shapeshifter
		local show = data.role == "Shapeshifter" and s.active and data.phase == "Blackout"
		panel.Visible = show
		if not show then
			return
		end
		Kit.clear(list)
		if s.actionsLeft <= 0 then
			header.Text = "Action used"
			hint.Text = "Blend in before the lights come back."
			return
		end
		header.Text = if s.actionsLeft == 1 then "1 action left" else `{s.actionsLeft} actions left`
		hint.Text = "Hold any item's prompt to swap it with one in another room, or copy someone:"
		for index, target in s.targets do
			Kit.button(`Copy {target.name}`, function()
				disguiseAs(target.userId)
			end, {
				Size = UDim2.new(1, -8, 0, Kit.MinTouch),
				BackgroundColor3 = Kit.Colors.Accent,
				LayoutOrder = index,
				Parent = list,
			})
		end
	end)
end

return ShapeshifterPanel
