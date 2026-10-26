--!strict
-- Between games: stats, outfit picker with purchase buttons, and the private server start button.

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared").Config)
local Kit = require(script.Parent.Kit)
local State = require(script.Parent.Parent.State)

local Lobby = {}

local OUT_OF_GAME = { Lobby = true, Countdown = true, Results = true }

local function productFor(cosmeticId: string): number?
	for productId, id in Config.DevProducts do
		if id == cosmeticId then
			return productId
		end
	end
	return nil
end

local function promptPurchase(cosmetic: Config.Cosmetic): boolean
	local player = Players.LocalPlayer
	if cosmetic.source == "PajamaPack" or cosmetic.source == "FlashlightPack" then
		local passId = Config.GamePasses[cosmetic.source]
		if passId and passId ~= 0 then
			MarketplaceService:PromptGamePassPurchase(player, passId)
			return true
		end
	elseif cosmetic.source == "DevProduct" then
		local productId = productFor(cosmetic.id)
		if productId then
			MarketplaceService:PromptProductPurchase(player, productId)
			return true
		end
	end
	return false
end

function Lobby.mount(equip: (slot: string, id: string) -> (), privateStart: () -> ())
	local gui = Kit.screen("FakeFriendLobby", 2)

	local buttons = Kit.create("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 12, 1, -12),
		Size = UDim2.fromOffset(170, Kit.MinTouch * 2 + 8),
		BackgroundTransparency = 1,
		Parent = gui,
	})
	local layout = Kit.list(buttons, 8)
	layout.VerticalAlignment = Enum.VerticalAlignment.Bottom

	local startButton = Kit.button("Start now", privateStart, {
		BackgroundColor3 = Kit.Colors.Good,
		LayoutOrder = 1,
		Visible = false,
		Parent = buttons,
	})
	local outfitsButton = Kit.button("Outfits", function() end, { LayoutOrder = 2, Parent = buttons })

	local panel = Kit.panel({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.86, 0.72),
		Visible = false,
		Parent = gui,
	})
	Kit.create("UISizeConstraint", { MaxSize = Vector2.new(620, 560), Parent = panel })
	Kit.padding(panel, 12)
	Kit.list(panel, 8)
	Kit.title("Outfits", { Size = UDim2.new(1, 0, 0, 40), LayoutOrder = 1, Parent = panel })
	local stats = Kit.label(
		"",
		{ Size = UDim2.new(1, 0, 0, 24), TextColor3 = Kit.Colors.Muted, LayoutOrder = 2, Parent = panel }
	)
	local list = Kit.create("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, -150),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 6,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		LayoutOrder = 3,
		Parent = panel,
	})
	Kit.list(list, 6)
	Kit.button("Close", function()
		panel.Visible = false
	end, {
		Size = UDim2.new(0.5, 0, 0, Kit.MinTouch),
		BackgroundColor3 = Kit.Colors.PanelLight,
		LayoutOrder = 4,
		Parent = panel,
	})

	outfitsButton.Activated:Connect(function()
		panel.Visible = not panel.Visible
	end)

	State.subscribe(function(data)
		local profile = data.profile
		local inLobby = OUT_OF_GAME[data.phase] == true
		buttons.Visible = inLobby and profile ~= false
		if not inLobby then
			panel.Visible = false
		end
		if not profile then
			return
		end
		startButton.Visible = profile.isPrivateServerOwner == true
			and (data.phase == "Lobby" or data.phase == "Countdown")

		local s = profile.stats
		stats.Text = `Wins: {s.wins}   Games: {s.gamesPlayed}   Shapeshifter wins: {s.winsAsShapeshifter}`

		local unlocked = {}
		for _, id in profile.unlocked do
			unlocked[id] = true
		end

		Kit.clear(list)
		for index, cosmetic in Config.Cosmetics do
			local row = Kit.create("Frame", {
				Size = UDim2.new(1, -8, 0, Kit.MinTouch),
				BackgroundTransparency = 1,
				LayoutOrder = index,
				Parent = list,
			})
			Kit.label(`{cosmetic.slot}: {cosmetic.displayName}`, {
				Size = UDim2.fromScale(0.6, 1),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = row,
			})
			local buttonProps = {
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromScale(0.38, 1),
				Parent = row,
			}
			if profile.equipped[cosmetic.slot] == cosmetic.id then
				buttonProps.BackgroundColor3 = Kit.Colors.Teal
				Kit.button("Wearing", function() end, buttonProps)
			elseif unlocked[cosmetic.id] then
				Kit.button("Wear", function()
					equip(cosmetic.slot, cosmetic.id)
				end, buttonProps)
			else
				buttonProps.BackgroundColor3 = Kit.Colors.PanelLight
				local buy
				buy = Kit.button("Get", function()
					if not promptPurchase(cosmetic) then
						buy.Text = "Soon"
					end
				end, buttonProps)
			end
		end
	end)
end

return Lobby
