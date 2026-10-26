--!strict
-- Ghosts can talk to each other, but living players never see ghost messages.
-- Uses TextChatService. Legacy chat is not supported.

local TextChatService = game:GetService("TextChatService")

local ChatService = {}

-- Returns true when a message from `senderId` may reach `recipientId`.
local canDeliver: (number, number) -> boolean = function(_senderId: number, _recipientId: number)
	return true
end

function ChatService.setFilter(filter: (senderId: number, recipientId: number) -> boolean)
	canDeliver = filter
end

local function hook(channel: TextChannel)
	channel.ShouldDeliverCallback = function(message: TextChatMessage, target: TextSource)
		local source = message.TextSource
		if not source then
			return true
		end
		local ok, allowed = pcall(canDeliver, source.UserId, target.UserId)
		return not ok or allowed
	end
end

function ChatService.init()
	if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
		warn(
			"[FakeFriend] Legacy chat is on. Switch TextChatService.ChatVersion to TextChatService to hide ghost chat."
		)
		return
	end
	task.spawn(function()
		local channels = TextChatService:WaitForChild("TextChannels", 30)
		local general = channels and channels:WaitForChild("RBXGeneral", 30)
		if general and general:IsA("TextChannel") then
			hook(general)
		else
			warn("[FakeFriend] RBXGeneral chat channel not found. Ghost chat filtering is off.")
		end
	end)
end

return ChatService
