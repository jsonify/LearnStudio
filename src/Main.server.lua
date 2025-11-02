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

-- Import UI modules
local Theme = require(script.Parent.UI.Theme)
local TabSystem = require(script.Parent.UI.Components.TabSystem)
local TutorialPanel = require(script.Parent.UI.TutorialPanel)
local CodeExplainer = require(script.Parent.UI.CodeExplainer)
local Dashboard = require(script.Parent.UI.Dashboard)

-- Store references for cleanup
local uiComponents = {}

-- Initialize UI
local function initializeUI()
	-- Create basic UI structure
	local container = Instance.new("Frame")
	container.Name = "MainContainer"
	container.Size = UDim2.new(1, 0, 1, 0)
	container.BackgroundColor3 = Theme.Colors.Background.Secondary
	container.BorderSizePixel = 0
	container.Parent = mainWidget

	-- Header
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, Theme.Spacing.Dimensions.HeaderHeight)
	header.BackgroundColor3 = Theme.Colors.Background.Header
	header.BorderSizePixel = 0
	header.Parent = container

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -20, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = PLUGIN_NAME .. " v" .. PLUGIN_VERSION
	title.TextColor3 = Theme.Colors.Text.Primary
	title.TextSize = Theme.Typography.Size.Large
	title.Font = Theme.Typography.Font.Heading
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	-- Content area (holds tab system and panels)
	local content = Instance.new("Frame")
	content.Name = "ContentArea"
	content.Size = UDim2.new(1, 0, 1, -Theme.Spacing.Dimensions.HeaderHeight)
	content.Position = UDim2.new(0, 0, 0, Theme.Spacing.Dimensions.HeaderHeight)
	content.BackgroundColor3 = Theme.Colors.Background.Primary
	content.BorderSizePixel = 0
	content.Parent = container

	-- Create tab panel container (right of sidebar)
	local panelContainer = Instance.new("Frame")
	panelContainer.Name = "PanelContainer"
	panelContainer.Size = UDim2.new(1, -Theme.Spacing.Dimensions.SidebarWidth, 1, 0)
	panelContainer.Position = UDim2.new(0, Theme.Spacing.Dimensions.SidebarWidth, 0, 0)
	panelContainer.BackgroundColor3 = Theme.Colors.Background.Primary
	panelContainer.BorderSizePixel = 0
	panelContainer.Parent = content

	-- Create tab content panels
	local tutorialPanel = TutorialPanel.new({ parent = panelContainer })
	local codeExplainer = CodeExplainer.new({ parent = panelContainer })
	local dashboard = Dashboard.new({ parent = panelContainer })

	-- Store panels for tab switching
	local panels = {
		tutorialPanel,
		codeExplainer,
		dashboard
	}

	-- Tab switching handler
	local function onTabChange(tabIndex, tabName)
		-- Hide all panels
		for _, panel in ipairs(panels) do
			panel:hide()
		end

		-- Show the selected panel
		panels[tabIndex]:show()

		print("[LearnStudio] Switched to tab:", tabName)
	end

	-- Create tab system
	local tabSystem = TabSystem.new({
		parent = content,
		tabs = {
			{ name = "Tutorials" },
			{ name = "Code Help" },
			{ name = "Dashboard" }
		},
		defaultTab = 1,
		onTabChange = onTabChange
	})

	-- Show the default tab panel
	panels[1]:show()

	-- Store references for cleanup
	uiComponents.container = container
	uiComponents.tabSystem = tabSystem
	uiComponents.panels = panels

	print("[LearnStudio] Plugin initialized successfully with tab system!")
end

-- Initialize the plugin
initializeUI()

-- Clean up on plugin unload
plugin.Unloading:Connect(function()
	-- Destroy tab system
	if uiComponents.tabSystem then
		uiComponents.tabSystem:destroy()
	end

	-- Destroy all panels
	if uiComponents.panels then
		for _, panel in ipairs(uiComponents.panels) do
			panel:destroy()
		end
	end

	-- Destroy main widget
	if mainWidget then
		mainWidget:Destroy()
	end

	print("[LearnStudio] Plugin unloaded and cleaned up")
end)
