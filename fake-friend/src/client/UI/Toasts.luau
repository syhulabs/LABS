--!strict
-- Short private messages near the bottom of the screen.

local TextChatService = game:GetService("TextChatService")

local Kit = require(script.Parent.Kit)

local Toasts = {}

local container: any = nil
local LIFETIME = 5
local MAX_VISIBLE = 3

function Toasts.mount()
	local gui = Kit.screen("FakeFriendToasts", 5)
	container = Kit.create("Frame", {
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -140),
		Size = UDim2.new(0.6, 0, 0, 220),
		BackgroundTransparency = 1,
		Parent = gui,
	})
	Kit.create(
		"UISizeConstraint",
		{ MinSize = Vector2.new(260, 0), MaxSize = Vector2.new(560, 220), Parent = container }
	)
	local layout = Kit.list(container, 6)
	layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
end

function Toasts.show(text: string, color: Color3?)
	if not container then
		return
	end
	local toasts = {}
	for _, child in container:GetChildren() do
		if child:IsA("Frame") then
			table.insert(toasts, child)
		end
	end
	if #toasts >= MAX_VISIBLE then
		toasts[1]:Destroy()
	end

	local toast = Kit.panel({
		Size = UDim2.new(1, 0, 0, 56),
		LayoutOrder = math.floor(os.clock() * 1000) % 1000000,
		Parent = container,
	})
	Kit.padding(toast, 8)
	Kit.label(text, { Size = UDim2.fromScale(1, 1), TextColor3 = color or Kit.Colors.Text, Parent = toast })
	task.delay(LIFETIME, function()
		if toast.Parent then
			toast:Destroy()
		end
	end)
end

-- Also posts to the chat window so shared memories stay readable during the meeting.
function Toasts.chat(text: string)
	pcall(function()
		local channels = TextChatService:FindFirstChild("TextChannels")
		local general = channels and channels:FindFirstChild("RBXGeneral")
		if general and general:IsA("TextChannel") then
			general:DisplaySystemMessage(text)
		end
	end)
end

return Toasts
