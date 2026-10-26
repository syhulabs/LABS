--!strict
-- Full-screen card that tells the player their secret role at the start of a game.

local Kit = require(script.Parent.Kit)
local State = require(script.Parent.Parent.State)

local RoleReveal = {}

local TEXT = {
	Friend = {
		title = "You are a FRIEND",
		body = "One of your friends is a shapeshifter. After each blackout, check your stuff, compare memories, and vote the fake out before sunrise.",
		color = Kit.Colors.Teal,
	},
	Shapeshifter = {
		title = "You are the SHAPESHIFTER",
		body = "Blend in. In each blackout you can copy someone's look, or hold an item's prompt to swap it with one in another room. Survive until sunrise.",
		color = Kit.Colors.Danger,
	},
}

function RoleReveal.mount()
	local gui = Kit.screen("FakeFriendRoleReveal", 20)
	local overlay = Kit.create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Kit.Colors.Background,
		BackgroundTransparency = 0.15,
		Visible = false,
		Parent = gui,
	})
	local card = Kit.panel({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.8, 0.7),
		Parent = overlay,
	})
	Kit.create("UISizeConstraint", { MaxSize = Vector2.new(560, 480), Parent = card })
	Kit.padding(card, 16)
	Kit.list(card, 10)

	local title = Kit.title("", { Size = UDim2.new(1, 0, 0, 52), LayoutOrder = 1, Parent = card })
	local body = Kit.label("", { Size = UDim2.new(1, 0, 0, 90), LayoutOrder = 2, Parent = card })
	local memoryHeader = Kit.label(
		"Your memories:",
		{ Size = UDim2.new(1, 0, 0, 24), TextColor3 = Kit.Colors.Muted, LayoutOrder = 3, Parent = card }
	)
	local memoryText = Kit.label("", { Size = UDim2.new(1, 0, 0, 70), LayoutOrder = 4, Parent = card })
	Kit.button("Got it", function()
		overlay.Visible = false
	end, { Size = UDim2.new(0.6, 0, 0, Kit.MinTouch), LayoutOrder = 5, Parent = card })

	local shownFor: any = nil
	State.subscribe(function(data)
		local role = data.role
		if not role then
			overlay.Visible = false
			shownFor = nil
			return
		end
		-- Show once per game, when the role first arrives.
		if shownFor ~= role and data.phase == "Setup" then
			shownFor = role
			local info = TEXT[role]
			title.Text = info.title
			title.TextColor3 = info.color
			body.Text = info.body
			memoryText.Text = table.concat(data.memories, "\n")
			memoryHeader.Visible = #data.memories > 0
			overlay.Visible = true
		end
		if data.phase ~= "Setup" then
			overlay.Visible = false
		end
	end)
end

return RoleReveal
