--[[
	LearnStudio - Educational Roblox Studio Plugin
	Main entry point for the plugin

	Phase 1 MVP: Basic UI with tutorials and code explanation
]]

local plugin = plugin

-- Plugin metadata
local PLUGIN_NAME = "LearnStudio"
local PLUGIN_VERSION = "0.1.0-alpha"

-- Toolbar and button setup
local toolbar = plugin:CreateToolbar("LearnStudio")
local toggleButton = toolbar:CreateButton(
	"LearnStudio",
	"Open LearnStudio educational assistant",
	"rbxasset://textures/ui/GuiImagePlaceholder.png" -- TODO: Replace with custom icon
)

-- Widget info for the main dockable window
local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Start as floating window
	false,  -- Don't start enabled
	false,  -- Don't override previous enabled state
	400,    -- Default width
	600,    -- Default height
	300,    -- Minimum width
	400     -- Minimum height
)

-- Create the main widget
local mainWidget = plugin:CreateDockWidgetPluginGui("LearnStudioMainWidget", widgetInfo)
mainWidget.Title = PLUGIN_NAME
mainWidget.Name = "LearnStudioWidget"

-- Toggle button click handler
toggleButton.Click:Connect(function()
	mainWidget.Enabled = not mainWidget.Enabled
end)

-- Sync button state with widget visibility
mainWidget:GetPropertyChangedSignal("Enabled"):Connect(function()
	toggleButton:SetActive(mainWidget.Enabled)
end)

-- Initialize UI
local function initializeUI()
	-- Create basic UI structure
	local container = Instance.new("Frame")
	container.Name = "MainContainer"
	container.Size = UDim2.new(1, 0, 1, 0)
	container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	container.BorderSizePixel = 0
	container.Parent = mainWidget

	-- Header
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 50)
	header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	header.BorderSizePixel = 0
	header.Parent = container

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -20, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = PLUGIN_NAME .. " v" .. PLUGIN_VERSION
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 18
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	-- Content area (will hold tabs later)
	local content = Instance.new("Frame")
	content.Name = "ContentArea"
	content.Size = UDim2.new(1, 0, 1, -50)
	content.Position = UDim2.new(0, 0, 0, 50)
	content.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	content.BorderSizePixel = 0
	content.Parent = container

	-- Placeholder text
	local placeholder = Instance.new("TextLabel")
	placeholder.Name = "Placeholder"
	placeholder.Size = UDim2.new(1, -40, 1, -40)
	placeholder.Position = UDim2.new(0, 20, 0, 20)
	placeholder.BackgroundTransparency = 1
	placeholder.Text = "LearnStudio Phase 1 Setup Complete!\n\nNext steps:\n• Add tutorial content\n• Implement code analyzer\n• Build interactive UI components"
	placeholder.TextColor3 = Color3.fromRGB(200, 200, 200)
	placeholder.TextSize = 16
	placeholder.Font = Enum.Font.Gotham
	placeholder.TextWrapped = true
	placeholder.TextYAlignment = Enum.TextYAlignment.Top
	placeholder.Parent = content

	print("[LearnStudio] Plugin initialized successfully!")
end

-- Initialize the plugin
initializeUI()

-- Clean up on plugin unload
plugin.Unloading:Connect(function()
	mainWidget:Destroy()
	print("[LearnStudio] Plugin unloaded")
end)
