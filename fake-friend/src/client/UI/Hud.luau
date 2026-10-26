--!strict
-- Top bar: phase name, timer, night counter and status line.

local RunService = game:GetService("RunService")

local Kit = require(script.Parent.Kit)
local State = require(script.Parent.Parent.State)

local Hud = {}

local TITLES: { [string]: string } = {
	Lobby = "Lobby",
	Countdown = "Sleepover starting",
	Setup = "Lights on",
	Explore = "Explore the house",
	Blackout = "BLACKOUT",
	Investigate = "Investigate",
	Discussion = "Meeting: talk it out",
	Vote = "Vote",
	VoteResult = "The votes are in",
	Results = "Game over",
}

local IN_GAME = {
	Setup = true,
	Explore = true,
	Blackout = true,
	Investigate = true,
	Discussion = true,
	Vote = true,
	VoteResult = true,
}

function Hud.mount()
	local gui = Kit.screen("FakeFriendHud", 1)
	local bar = Kit.panel({
		Name = "Bar",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 8),
		Size = UDim2.new(0.5, 0, 0, 96),
		Parent = gui,
	})
	Kit.create(
		"UISizeConstraint",
		{ MinSize = Vector2.new(280, 96), MaxSize = Vector2.new(560, 96), Parent = bar }
	)
	Kit.padding(bar, 8)
	Kit.list(bar, 2)

	local title = Kit.title("Lobby", { Size = UDim2.new(1, 0, 0, 34), LayoutOrder = 1, Parent = bar })
	local timer = Kit.label(
		"",
		{ Size = UDim2.new(1, 0, 0, 22), TextColor3 = Kit.Colors.Teal, LayoutOrder = 2, Parent = bar }
	)
	local status = Kit.label(
		"",
		{ Size = UDim2.new(1, 0, 0, 20), TextColor3 = Kit.Colors.Muted, LayoutOrder = 3, Parent = bar }
	)

	State.subscribe(function(data)
		title.Text = TITLES[data.phase] or data.phase
		title.TextColor3 = if data.phase == "Blackout" then Kit.Colors.Danger else Kit.Colors.Text

		local line = ""
		if IN_GAME[data.phase] then
			if not State.isParticipant() then
				line = "Game in progress. You'll join the next one."
			elseif not State.isAlive() then
				line = "You're a ghost. Watch quietly."
			else
				line = `Night {math.min(data.round, data.totalRounds)} of {data.totalRounds}`
			end
		elseif data.phase == "Lobby" then
			line = data.lobbyStatus
		end
		status.Text = line
	end)

	local accumulated = 0
	RunService.Heartbeat:Connect(function(dt)
		accumulated += dt
		if accumulated < 0.25 then
			return
		end
		accumulated = 0
		local left = State.timeLeft()
		if left <= 0 then
			timer.Text = ""
		else
			local seconds = math.ceil(left)
			timer.Text = string.format("%d:%02d", seconds // 60, seconds % 60)
		end
	end)
end

return Hud
