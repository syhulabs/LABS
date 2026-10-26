--!strict
-- Studio-only "Skip phase" button. The server ignores it unless Config.DebugMode is on in Studio.

local Kit = require(script.Parent.Kit)
local State = require(script.Parent.Parent.State)

local DebugPanel = {}

function DebugPanel.mount(skip: () -> ())
	local gui = Kit.screen("FakeFriendDebug", 30)
	local button = Kit.button("Skip phase", skip, {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 116),
		Size = UDim2.fromOffset(150, Kit.MinTouch),
		BackgroundColor3 = Kit.Colors.Danger,
		Visible = false,
		Parent = gui,
	})
	State.subscribe(function(data)
		button.Visible = data.profile ~= false and data.profile.isDebug == true
	end)
end

return DebugPanel
