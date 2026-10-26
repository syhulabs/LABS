--!strict
-- Small helpers for building mobile-friendly UI in code.

local Players = game:GetService("Players")

local Kit = {}

Kit.Colors = {
	Background = Color3.fromRGB(22, 18, 38),
	Panel = Color3.fromRGB(38, 31, 64),
	PanelLight = Color3.fromRGB(58, 48, 94),
	Accent = Color3.fromRGB(168, 110, 255),
	Teal = Color3.fromRGB(70, 222, 208),
	Text = Color3.fromRGB(245, 242, 255),
	Muted = Color3.fromRGB(184, 174, 210),
	Danger = Color3.fromRGB(255, 92, 120),
	Good = Color3.fromRGB(110, 230, 140),
}

Kit.TitleFont = Enum.Font.FredokaOne
Kit.BodyFont = Enum.Font.GothamMedium
Kit.MinTouch = 52 -- Smallest button height in pixels, comfortable for thumbs.

function Kit.create(className: string, props: { [string]: any }, children: { Instance }?): any
	local inst = Instance.new(className) :: any
	for key, value in props do
		if key ~= "Parent" then
			inst[key] = value
		end
	end
	if children then
		for _, child in children do
			child.Parent = inst
		end
	end
	if props.Parent then
		inst.Parent = props.Parent
	end
	return inst
end

function Kit.screen(name: string, displayOrder: number): any
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	return Kit.create("ScreenGui", {
		Name = name,
		ResetOnSpawn = false,
		DisplayOrder = displayOrder,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = playerGui,
	})
end

function Kit.corner(parent: Instance, radius: number?)
	Kit.create("UICorner", { CornerRadius = UDim.new(0, radius or 14), Parent = parent })
end

function Kit.padding(parent: Instance, px: number)
	Kit.create("UIPadding", {
		PaddingTop = UDim.new(0, px),
		PaddingBottom = UDim.new(0, px),
		PaddingLeft = UDim.new(0, px),
		PaddingRight = UDim.new(0, px),
		Parent = parent,
	})
end

function Kit.list(parent: Instance, spacing: number, horizontal: boolean?): any
	return Kit.create("UIListLayout", {
		Padding = UDim.new(0, spacing),
		FillDirection = if horizontal then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = parent,
	})
end

function Kit.panel(props: { [string]: any }): any
	local frame = Kit.create("Frame", {
		BackgroundColor3 = Kit.Colors.Panel,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
	})
	for key, value in props do
		frame[key] = value
	end
	Kit.corner(frame, 18)
	Kit.create("UIStroke", { Color = Kit.Colors.Accent, Transparency = 0.55, Thickness = 2, Parent = frame })
	return frame
end

function Kit.label(text: string, props: { [string]: any }?): any
	local label = Kit.create("TextLabel", {
		Text = text,
		BackgroundTransparency = 1,
		TextColor3 = Kit.Colors.Text,
		Font = Kit.BodyFont,
		TextScaled = true,
		TextWrapped = true,
		Size = UDim2.new(1, 0, 0, 28),
	})
	Kit.create("UITextSizeConstraint", { MaxTextSize = 22, MinTextSize = 12, Parent = label })
	if props then
		for key, value in props do
			label[key] = value
		end
	end
	return label
end

function Kit.title(text: string, props: { [string]: any }?): any
	local label = Kit.label(text, props)
	label.Font = Kit.TitleFont
	local constraint = label:FindFirstChildOfClass("UITextSizeConstraint")
	if constraint then
		constraint.MaxTextSize = 40
	end
	return label
end

function Kit.button(text: string, onClick: () -> (), props: { [string]: any }?): any
	local button = Kit.create("TextButton", {
		Text = text,
		AutoButtonColor = true,
		BackgroundColor3 = Kit.Colors.Accent,
		TextColor3 = Kit.Colors.Text,
		Font = Kit.TitleFont,
		TextScaled = true,
		Size = UDim2.new(1, 0, 0, Kit.MinTouch),
	})
	Kit.corner(button, 12)
	Kit.padding(button, 8)
	Kit.create("UITextSizeConstraint", { MaxTextSize = 24, MinTextSize = 12, Parent = button })
	if props then
		for key, value in props do
			button[key] = value
		end
	end
	button.Activated:Connect(onClick)
	return button
end

function Kit.clear(container: Instance)
	for _, child in container:GetChildren() do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
end

return Kit
