--!strict
-- Blackouts, flicker and flashlights.

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared").Config)
local MapService = require(script.Parent.MapService)

local LightingService = {}

local FLASHLIGHT_NAME = "FakeFriendFlashlight"

local savedLighting: { [string]: any } = {}
local savedLights: { [Light]: boolean } = {}
local savedNeon: { [BasePart]: Enum.Material } = {}
local isDark = false

local LIGHTING_PROPS = {
	"Brightness",
	"Ambient",
	"OutdoorAmbient",
	"ClockTime",
	"EnvironmentDiffuseScale",
	"EnvironmentSpecularScale",
	"ExposureCompensation",
}

function LightingService.init()
	for _, prop in LIGHTING_PROPS do
		savedLighting[prop] = (Lighting :: any)[prop]
	end
end

-- Lights tagged "Light" may be Light objects, or Parts/Models holding lights.
local function collectLights(): ({ Light }, { BasePart })
	local lights, neon = {}, {}
	for _, target in MapService.getLightTargets() do
		if target:IsA("Light") then
			table.insert(lights, target)
		end
		if target:IsA("BasePart") and target.Material == Enum.Material.Neon then
			table.insert(neon, target)
		end
		for _, d in target:GetDescendants() do
			if d:IsA("Light") then
				table.insert(lights, d)
			elseif d:IsA("BasePart") and d.Material == Enum.Material.Neon then
				table.insert(neon, d)
			end
		end
	end
	return lights, neon
end

local function setLamps(on: boolean)
	local lights, neon = collectLights()
	for _, light in lights do
		if savedLights[light] == nil then
			savedLights[light] = light.Enabled
		end
		light.Enabled = if on then savedLights[light] else false
	end
	for _, part in neon do
		if savedNeon[part] == nil then
			savedNeon[part] = part.Material
		end
		part.Material = if on then savedNeon[part] else Enum.Material.SmoothPlastic
	end
end

-- Yields for `duration` seconds while lamps flicker.
function LightingService.flicker(duration: number)
	local deadline = os.clock() + duration
	local on = true
	while os.clock() < deadline do
		on = not on
		setLamps(on)
		task.wait(math.random(5, 25) / 100)
	end
	setLamps(true)
end

function LightingService.blackout()
	isDark = true
	setLamps(false)
	local c = Config.BlackoutAmbient
	local dark = Color3.fromRGB(c.r, c.g, c.b)
	Lighting.Brightness = 0
	Lighting.Ambient = dark
	Lighting.OutdoorAmbient = dark
	Lighting.ClockTime = 0
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	Lighting.ExposureCompensation = -1
end

function LightingService.restore()
	isDark = false
	setLamps(true)
	for prop, value in savedLighting do
		(Lighting :: any)[prop] = value
	end
	table.clear(savedLights)
	table.clear(savedNeon)
end

function LightingService.isDark(): boolean
	return isDark
end

function LightingService.giveFlashlight(player: Player, color: Color3)
	local character = player.Character
	local head = character and character:FindFirstChild("Head")
	if not head or head:FindFirstChild(FLASHLIGHT_NAME) then
		return
	end
	local light = Instance.new("SpotLight")
	light.Name = FLASHLIGHT_NAME
	light.Face = Enum.NormalId.Front
	light.Range = Config.FlashlightRange
	light.Brightness = Config.FlashlightBrightness
	light.Angle = Config.FlashlightAngle
	light.Shadows = true
	light.Color = color
	light.Parent = head
end

function LightingService.removeFlashlight(player: Player)
	local character = player.Character
	local head = character and character:FindFirstChild("Head")
	local light = head and head:FindFirstChild(FLASHLIGHT_NAME)
	if light then
		light:Destroy()
	end
end

return LightingService
