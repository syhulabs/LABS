--!strict
-- Game passes, developer products and cosmetics. Nothing here affects roles or winning.

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local CosmeticLogic = require(Shared.Logic.CosmeticLogic)
local DataService = require(script.Parent.DataService)
local RemoteService = require(script.Parent.RemoteService)

local MonetizationService = {}

local ownedPasses: { [Player]: { [string]: boolean } } = {}
local canChangeCosmetics: () -> boolean = function()
	return true
end
local extraProfileInfo: (Player) -> { [string]: any } = function(_player: Player)
	return {}
end

local function refreshPasses(player: Player)
	local owned = {}
	for source, passId in Config.GamePasses do
		if passId ~= 0 then
			local ok, result =
				pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, player.UserId, passId)
			if ok and result then
				owned[source] = true
			elseif not ok then
				warn(`[FakeFriend] Game pass check failed for {player.Name}: {result}`)
			end
		end
	end
	ownedPasses[player] = owned
end

function MonetizationService.unlocked(player: Player): { [string]: boolean }
	local data = DataService.get(player)
	return CosmeticLogic.unlocked(
		Config.Cosmetics,
		ownedPasses[player] or {},
		if data then data.granted else {}
	)
end

local function equipped(player: Player): { [string]: string }
	local data = DataService.get(player)
	local wanted = if data then data.equipped else {}
	return CosmeticLogic.sanitizeEquipped(
		Config.Cosmetics,
		MonetizationService.unlocked(player),
		wanted,
		Config.DefaultEquipped
	)
end

function MonetizationService.sendProfile(player: Player)
	local data = DataService.get(player)
	if not data then
		return
	end
	local unlockedList = {}
	for id in MonetizationService.unlocked(player) do
		table.insert(unlockedList, id)
	end
	local payload = {
		unlocked = unlockedList,
		equipped = equipped(player),
		stats = {
			wins = data.wins,
			gamesPlayed = data.gamesPlayed,
			gamesAsShapeshifter = data.gamesAsShapeshifter,
			winsAsShapeshifter = data.winsAsShapeshifter,
		},
	}
	for k, v in extraProfileInfo(player) do
		payload[k] = v
	end
	RemoteService.fire("ProfileUpdate", player, payload)
end

function MonetizationService.getFlashlightColor(player: Player): Color3
	local cosmetic = CosmeticLogic.find(Config.Cosmetics, equipped(player).Flashlight)
	local c = cosmetic and cosmetic.color
	return if c then Color3.fromRGB(c.r, c.g, c.b) else Color3.new(1, 1, 1)
end

-- Clothing from the equipped pajamas. Asset IDs of 0 are skipped until you add real ones.
function MonetizationService.applyPajamas(player: Player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local cosmetic = CosmeticLogic.find(Config.Cosmetics, equipped(player).Pajamas)
	if not humanoid or not cosmetic or not cosmetic.shirt or cosmetic.shirt == 0 then
		return
	end
	local ok, err = pcall(function()
		local description = humanoid:GetAppliedDescription()
		description.Shirt = cosmetic.shirt or 0
		description.Pants = cosmetic.pants or 0
		humanoid:ApplyDescription(description)
	end)
	if not ok then
		warn(`[FakeFriend] Could not apply pajamas: {err}`)
	end
end

-- Hooks for RoundService.
function MonetizationService.setCanChangeCosmetics(fn: () -> boolean)
	canChangeCosmetics = fn
end

function MonetizationService.setExtraProfileInfo(fn: (Player) -> { [string]: any })
	extraProfileInfo = fn
end

local function processReceipt(receipt: { [string]: any }): Enum.ProductPurchaseDecision
	local player = Players:GetPlayerByUserId(receipt.PlayerId)
	if not player or not DataService.isLoaded(player) then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	local cosmeticId = Config.DevProducts[receipt.ProductId]
	if not cosmeticId then
		warn(`[FakeFriend] Unknown developer product {receipt.ProductId}. Add it to Config.DevProducts.`)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	local data = DataService.get(player)
	if data and data.purchases[receipt.PurchaseId] then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
	DataService.update(player, function(d)
		d.granted[cosmeticId] = true
		d.purchases[receipt.PurchaseId] = true
	end)
	-- Only confirm once the grant is stored, so Roblox retries if saving fails.
	if not DataService.saveNow(player) then
		DataService.update(player, function(d)
			d.purchases[receipt.PurchaseId] = nil
			d.granted[cosmeticId] = nil
		end)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	MonetizationService.sendProfile(player)
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

function MonetizationService.init()
	MarketplaceService.ProcessReceipt = processReceipt

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, _passId, purchased)
		if purchased then
			refreshPasses(player)
			MonetizationService.sendProfile(player)
		end
	end)

	DataService.onLoaded(function(player)
		refreshPasses(player)
		MonetizationService.sendProfile(player)
		MonetizationService.applyPajamas(player)
		player.CharacterAppearanceLoaded:Connect(function()
			MonetizationService.applyPajamas(player)
		end)
	end)

	Players.PlayerRemoving:Connect(function(player)
		ownedPasses[player] = nil
	end)

	RemoteService.on("EquipCosmetic", function(player, slot, id)
		if not RemoteService.isShortString(slot) or not RemoteService.isShortString(id) then
			return
		end
		if not canChangeCosmetics() then
			RemoteService.fire("PrivateMessage", player, "You can change outfits between games.")
			return
		end
		if not CosmeticLogic.canEquip(Config.Cosmetics, MonetizationService.unlocked(player), slot, id) then
			return
		end
		DataService.update(player, function(d)
			d.equipped[slot] = id
		end)
		if slot == "Pajamas" then
			-- Reload so the default outfit comes back cleanly when switching to "Own Clothes".
			player:LoadCharacter()
		end
		MonetizationService.sendProfile(player)
	end)
end

return MonetizationService
