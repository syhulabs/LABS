--!strict
-- Every tunable number lives here. Change values, not code.

local Config = {}

-- Players ---------------------------------------------------------------
Config.MinPlayers = 6
Config.MaxPlayers = 10 -- Also set the server size in Studio: Game Settings > Places.
Config.ShapeshifterCount = 1

-- Phase durations in seconds -------------------------------------------
Config.LobbyCountdown = 15
Config.SetupDuration = 8 -- Role reveal and memory reading time.
Config.ExploreDuration = 60
Config.FlickerDuration = 3 -- Lights flicker this long before each blackout.
Config.BlackoutDuration = 15
Config.InvestigateDuration = 30
Config.DiscussionDuration = 60
Config.VoteDuration = 20
Config.VoteResultDuration = 6
Config.ResultsDuration = 12

-- Rules ------------------------------------------------------------------
Config.RoundsUntilSunrise = 5 -- Shapeshifter wins if it survives this many meetings.
Config.ShapeshifterWinsAtFriendsAlive = 2 -- Shapeshifter wins when this many friends or fewer remain.
Config.ShapeshifterActionsPerBlackout = 1
Config.ItemsPerPlayer = 1
Config.MemoriesPerPlayer = 2
Config.AllowSelfVote = false
Config.RevealRoleOnVote = true -- Announce whether the player sent home was the shapeshifter.

-- Blackout ---------------------------------------------------------------
Config.FlashlightRange = 16
Config.FlashlightBrightness = 3
Config.FlashlightAngle = 45
Config.BlackoutAmbient = { r = 6, g = 6, b = 12 } -- 0-255 colour used for ambient light in blackouts.

-- Interaction --------------------------------------------------------------
Config.ItemPromptDistance = 8
Config.ItemPromptHoldSeconds = 0.4

-- Remote rate limits: `capacity` requests, refilled at `perSecond`.
Config.RateLimits = {
	Default = { capacity = 5, perSecond = 1 },
	CastVote = { capacity = 3, perSecond = 0.5 },
	ShareMemory = { capacity = 3, perSecond = 0.2 },
	ShapeshifterAction = { capacity = 3, perSecond = 0.5 },
	EquipCosmetic = { capacity = 5, perSecond = 1 },
	DebugSkipPhase = { capacity = 3, perSecond = 1 },
	PrivateServerStart = { capacity = 2, perSecond = 0.2 },
}

-- Data ---------------------------------------------------------------------
Config.DataStoreName = "FakeFriend_PlayerData_v1"
Config.AutosaveInterval = 120
Config.SessionLockTimeout = 600 -- A lock older than this is treated as abandoned.
Config.DataRetryAttempts = 5
Config.DataRetryBaseDelay = 1 -- Backoff doubles each attempt: 1, 2, 4, 8...
Config.SessionLockWaitAttempts = 6

-- Monetization: replace 0 with real IDs from the Creator Dashboard. -------
-- Nothing sold here may reveal roles or change who wins.
Config.GamePasses = {
	PajamaPack = 0, -- Unlocks every cosmetic with source "PajamaPack".
	FlashlightPack = 0, -- Unlocks every cosmetic with source "FlashlightPack".
}

Config.DevProducts = {
	-- [productId] = cosmeticId granted permanently.
	-- [1234567] = "Pajamas_Dino",
} :: { [number]: string }

-- Cosmetics. Shirt and Pants are Roblox clothing asset IDs (0 = not set yet).
export type Cosmetic = {
	id: string,
	slot: "Pajamas" | "Flashlight",
	displayName: string,
	source: "Free" | "PajamaPack" | "FlashlightPack" | "DevProduct",
	shirt: number?,
	pants: number?,
	color: { r: number, g: number, b: number }?,
}

Config.Cosmetics = {
	{ id = "Pajamas_Default", slot = "Pajamas", displayName = "Own Clothes", source = "Free" },
	{
		id = "Pajamas_Stripes",
		slot = "Pajamas",
		displayName = "Striped PJs",
		source = "PajamaPack",
		shirt = 0,
		pants = 0,
	},
	{
		id = "Pajamas_Stars",
		slot = "Pajamas",
		displayName = "Starry PJs",
		source = "PajamaPack",
		shirt = 0,
		pants = 0,
	},
	{
		id = "Pajamas_Dino",
		slot = "Pajamas",
		displayName = "Dino Onesie",
		source = "DevProduct",
		shirt = 0,
		pants = 0,
	},
	{
		id = "Flashlight_Warm",
		slot = "Flashlight",
		displayName = "Warm",
		source = "Free",
		color = { r = 255, g = 236, b = 200 },
	},
	{
		id = "Flashlight_Purple",
		slot = "Flashlight",
		displayName = "Purple",
		source = "FlashlightPack",
		color = { r = 190, g = 120, b = 255 },
	},
	{
		id = "Flashlight_Teal",
		slot = "Flashlight",
		displayName = "Teal",
		source = "FlashlightPack",
		color = { r = 90, g = 230, b = 220 },
	},
} :: { Cosmetic }

Config.DefaultEquipped = { Pajamas = "Pajamas_Default", Flashlight = "Flashlight_Warm" }

-- Private server perk: the owner can start a game with fewer players.
Config.PrivateServerMinPlayers = 3

-- Debug mode ---------------------------------------------------------------
-- Only takes effect inside Roblox Studio. Lets one person play every phase alone.
Config.DebugMode = false
Config.Debug = {
	MinPlayers = 1,
	ForceRole = "Shapeshifter" :: "Shapeshifter" | "Friend" | nil,
	DisableWinCheck = true, -- Keeps phases cycling even when a side would have won.
	DurationScale = 0.3, -- Multiplies every phase duration.
}

return Config
