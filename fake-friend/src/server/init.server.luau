--!strict
-- Server entry point. Order matters: remotes first, the round loop last.

local Services = script.Services
local RemoteService = require(Services.RemoteService)
local GhostService = require(Services.GhostService)
local LightingService = require(Services.LightingService)
local ChatService = require(Services.ChatService)
local DataService = require(Services.DataService)
local MonetizationService = require(Services.MonetizationService)
local MapService = require(Services.MapService)
local RoundService = require(Services.RoundService)

RemoteService.init()
GhostService.init()
LightingService.init()
ChatService.init()
DataService.init()
MonetizationService.init()

if not MapService.validate() then
	warn("[FakeFriend] The map is incomplete. The game will run, but see the warnings above and the README.")
end

RoundService.init()
RoundService.start()
