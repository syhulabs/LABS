--!strict
-- Meeting vote screen. Shows who has voted, never who they voted for.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared").Config)
local Kit = require(script.Parent.Kit)
local State = require(script.Parent.Parent.State)

local VotePanel = {}

local SKIP = 0

function VotePanel.mount(castVote: (targetId: number) -> ())
	local gui = Kit.screen("FakeFriendVote", 10)
	local panel = Kit.panel({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.55),
		Size = UDim2.fromScale(0.86, 0.62),
		Visible = false,
		Parent = gui,
	})
	Kit.create("UISizeConstraint", { MaxSize = Vector2.new(680, 520), Parent = panel })
	Kit.padding(panel, 12)
	Kit.list(panel, 8)

	local header =
		Kit.title("Who is the fake?", { Size = UDim2.new(1, 0, 0, 40), LayoutOrder = 1, Parent = panel })
	local sub = Kit.label(
		"",
		{ Size = UDim2.new(1, 0, 0, 24), TextColor3 = Kit.Colors.Muted, LayoutOrder = 2, Parent = panel }
	)
	local grid = Kit.create("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, -82),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 6,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		LayoutOrder = 3,
		Parent = panel,
	})
	Kit.create("UIGridLayout", {
		CellSize = UDim2.new(0.48, 0, 0, Kit.MinTouch + 8),
		CellPadding = UDim2.new(0.02, 0, 0, 8),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = grid,
	})

	local myId = Players.LocalPlayer.UserId

	State.subscribe(function(data)
		local show = data.phase == "Vote" and State.isAlive()
		panel.Visible = show
		if not show then
			return
		end

		local votedSet = {}
		local votedCount = 0
		for _, id in data.voted do
			votedSet[id] = true
			votedCount += 1
		end
		local aliveCount = 0
		for _, entry in data.players do
			if entry.alive then
				aliveCount += 1
			end
		end

		local myVote = data.myVote
		header.Text = if myVote ~= false then "Vote locked in" else "Who is the fake?"
		sub.Text = `{votedCount}/{aliveCount} voted`

		Kit.clear(grid)
		local order = 0
		for _, entry in data.players do
			if entry.alive and (entry.userId ~= myId or Config.AllowSelfVote) then
				order += 1
				local label = entry.name .. (if votedSet[entry.userId] then "  ✓" else "")
				local isMine = myVote == entry.userId
				Kit.button(label, function()
					if State.data.myVote == false then
						castVote(entry.userId)
					end
				end, {
					LayoutOrder = order,
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = if isMine then Kit.Colors.Danger else Kit.Colors.PanelLight,
					Active = myVote == false,
					AutoButtonColor = myVote == false,
					Parent = grid,
				})
			end
		end
		Kit.button("Skip vote", function()
			if State.data.myVote == false then
				castVote(SKIP)
			end
		end, {
			LayoutOrder = order + 1,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = if myVote == SKIP then Kit.Colors.Teal else Kit.Colors.Panel,
			Active = myVote == false,
			AutoButtonColor = myVote == false,
			Parent = grid,
		})
	end)
end

return VotePanel
