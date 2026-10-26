--!strict
-- Vote result banner and the end-of-game screen.

local Kit = require(script.Parent.Kit)
local State = require(script.Parent.Parent.State)

local Results = {}

local REASONS: { [string]: string } = {
	Caught = "The shapeshifter was caught!",
	ShapeshifterLeft = "The shapeshifter ran away.",
	Outnumbered = "Too few friends were left.",
	Sunrise = "The shapeshifter survived until sunrise.",
	Abandoned = "Everyone left, so the game was cancelled.",
}

local function voteText(result: { [string]: any }): string
	local lines = {}
	if result.outcome == "Eliminated" then
		table.insert(lines, `{result.name} was sent home.`)
		if result.wasShapeshifter == true then
			table.insert(lines, "They WERE the shapeshifter!")
		elseif result.wasShapeshifter == false then
			table.insert(lines, "They were not the shapeshifter.")
		end
	elseif result.outcome == "Tie" then
		table.insert(lines, "It's a tie. Nobody goes home.")
	elseif result.outcome == "Skipped" then
		table.insert(lines, "Most people skipped. Nobody goes home.")
	else
		table.insert(lines, "Nobody voted.")
	end
	local counts = {}
	for _, c in result.counts do
		table.insert(counts, `{c.name}: {c.count}`)
	end
	if #counts > 0 then
		table.insert(lines, table.concat(counts, "   "))
	end
	return table.concat(lines, "\n")
end

function Results.mount()
	local gui = Kit.screen("FakeFriendResults", 15)

	local banner = Kit.panel({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.45),
		Size = UDim2.fromScale(0.8, 0.3),
		Visible = false,
		Parent = gui,
	})
	Kit.create("UISizeConstraint", { MaxSize = Vector2.new(600, 220), Parent = banner })
	Kit.padding(banner, 14)
	local bannerText = Kit.label("", { Size = UDim2.fromScale(1, 1), Parent = banner })
	local bannerSize = bannerText:FindFirstChildOfClass("UITextSizeConstraint")
	if bannerSize then
		bannerSize.MaxTextSize = 28
	end

	local overlay = Kit.create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Kit.Colors.Background,
		BackgroundTransparency = 0.2,
		Visible = false,
		Parent = gui,
	})
	local card = Kit.panel({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.8, 0.5),
		Parent = overlay,
	})
	Kit.create("UISizeConstraint", { MaxSize = Vector2.new(600, 340), Parent = card })
	Kit.padding(card, 16)
	Kit.list(card, 10)
	local winnerText = Kit.title("", { Size = UDim2.new(1, 0, 0, 60), LayoutOrder = 1, Parent = card })
	local reasonText = Kit.label("", { Size = UDim2.new(1, 0, 0, 40), LayoutOrder = 2, Parent = card })
	local whoText = Kit.label(
		"",
		{ Size = UDim2.new(1, 0, 0, 40), TextColor3 = Kit.Colors.Muted, LayoutOrder = 3, Parent = card }
	)
	local youText = Kit.title("", { Size = UDim2.new(1, 0, 0, 44), LayoutOrder = 4, Parent = card })

	State.subscribe(function(data)
		local vote = data.voteResult
		banner.Visible = data.phase == "VoteResult" and vote ~= false
		if banner.Visible then
			bannerText.Text = voteText(vote)
		end

		local over = data.gameOver
		overlay.Visible = data.phase == "Results" and over ~= false
		if overlay.Visible then
			if over.winner == "Friends" then
				winnerText.Text = "FRIENDS WIN"
				winnerText.TextColor3 = Kit.Colors.Teal
			elseif over.winner == "Shapeshifter" then
				winnerText.Text = "SHAPESHIFTER WINS"
				winnerText.TextColor3 = Kit.Colors.Danger
			else
				winnerText.Text = "NO WINNER"
				winnerText.TextColor3 = Kit.Colors.Muted
			end
			reasonText.Text = REASONS[over.reason or ""] or ""
			local names = over.shapeshifters or {}
			whoText.Text = if #names > 0 then `The shapeshifter was {table.concat(names, " and ")}.` else ""

			local role = data.role
			if role and over.winner then
				local won = (over.winner == "Friends" and role == "Friend")
					or (over.winner == "Shapeshifter" and role == "Shapeshifter")
				youText.Text = if won then "You won!" else "You lost."
				youText.TextColor3 = if won then Kit.Colors.Good else Kit.Colors.Danger
			else
				youText.Text = ""
			end
		end
	end)
end

return Results
