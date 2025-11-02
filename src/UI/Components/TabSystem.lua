--[[
	TabSystem.lua
	Reusable tab navigation system with left vertical sidebar
	Provides tab buttons, active state management, and callbacks
]]

local Theme = require(script.Parent.Parent.Theme)

local TabSystem = {}
TabSystem.__index = TabSystem

--[[
	Creates a new TabSystem instance

	@param config table - Configuration options
		- parent: GuiObject - Parent container for the tab system
		- tabs: array - List of tab definitions {name: string, icon: string?}
		- defaultTab: number - Index of the default active tab (default: 1)
		- onTabChange: function - Callback when tab changes (tabIndex, tabName)

	@return table - TabSystem instance with methods: selectTab(), getActiveTab(), destroy()
]]
function TabSystem.new(config)
	local self = setmetatable({}, TabSystem)

	-- Validate config
	assert(config and config.parent, "TabSystem.new() requires config.parent")
	assert(config.tabs and #config.tabs > 0, "TabSystem.new() requires at least one tab")

	-- Store configuration
	self.parent = config.parent
	self.tabs = config.tabs
	self.activeTabIndex = config.defaultTab or 1
	self.onTabChange = config.onTabChange or function() end

	-- Track button instances for state management
	self.tabButtons = {}
	self.connections = {}
	self.isDestroyed = false

	-- Create the sidebar container
	self:_createSidebar()

	-- Create tab buttons
	self:_createTabButtons()

	-- Set initial active tab
	self:selectTab(self.activeTabIndex, true) -- true = skip callback on init

	return self
end

--[[
	Creates the left sidebar container
]]
function TabSystem:_createSidebar()
	local sidebar = Instance.new("Frame")
	sidebar.Name = "TabSidebar"
	sidebar.Size = UDim2.new(0, Theme.Spacing.Dimensions.SidebarWidth, 1, 0)
	sidebar.Position = UDim2.new(0, 0, 0, 0)
	sidebar.BackgroundColor3 = Theme.Colors.Background.Sidebar
	sidebar.BorderSizePixel = 0
	sidebar.Parent = self.parent

	-- Add vertical layout for tab buttons
	local layout = Instance.new("UIListLayout")
	layout.Name = "TabLayout"
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, Theme.Spacing.Gap.Tiny)
	layout.Parent = sidebar

	self.sidebar = sidebar
	self.layout = layout
end

--[[
	Creates individual tab buttons in the sidebar
]]
function TabSystem:_createTabButtons()
	for index, tab in ipairs(self.tabs) do
		local button = self:_createTabButton(tab, index)
		self.tabButtons[index] = button
	end
end

--[[
	Creates a single tab button

	@param tab table - Tab definition {name: string, icon: string?}
	@param index number - Tab index in the list

	@return Frame - The created tab button frame
]]
function TabSystem:_createTabButton(tab, index)
	local styles = Theme.Components.Tab

	-- Main button container
	local button = Instance.new("TextButton")
	button.Name = "Tab_" .. tab.name
	button.Size = UDim2.new(1, 0, 0, styles.Height)
	button.BackgroundColor3 = styles.Inactive.BackgroundColor
	button.BackgroundTransparency = styles.Inactive.BackgroundTransparency
	button.BorderSizePixel = 0
	button.Text = "" -- We'll use a TextLabel instead
	button.AutoButtonColor = false -- We'll handle states manually
	button.LayoutOrder = index
	button.Parent = self.sidebar

	-- Left border indicator (for active state)
	local border = Instance.new("Frame")
	border.Name = "ActiveBorder"
	border.Size = UDim2.new(0, Theme.Spacing.Dimensions.BorderWidthThick, 1, 0)
	border.Position = UDim2.new(0, 0, 0, 0)
	border.BackgroundColor3 = styles.Inactive.BorderColor
	border.BorderSizePixel = 0
	border.Visible = false -- Hidden by default
	border.Parent = button

	-- Tab label
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -styles.Padding * 2, 1, -styles.Padding * 2)
	label.Position = UDim2.new(0, styles.Padding, 0, styles.Padding)
	label.BackgroundTransparency = 1
	label.Text = tab.name
	label.TextColor3 = styles.Inactive.TextColor
	label.TextSize = styles.FontSize
	label.Font = styles.Font
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.Parent = button

	-- Store references for state management
	button:SetAttribute("TabIndex", index)
	button:SetAttribute("TabName", tab.name)

	-- Connect click event
	local clickConnection = button.MouseButton1Click:Connect(function()
		self:selectTab(index)
	end)
	table.insert(self.connections, clickConnection)

	-- Connect hover events
	local enterConnection = button.MouseEnter:Connect(function()
		if index ~= self.activeTabIndex then
			self:_applyButtonState(button, label, border, "Hover")
		end
	end)
	table.insert(self.connections, enterConnection)

	local leaveConnection = button.MouseLeave:Connect(function()
		if index ~= self.activeTabIndex then
			self:_applyButtonState(button, label, border, "Inactive")
		end
	end)
	table.insert(self.connections, leaveConnection)

	return button
end

--[[
	Applies a visual state to a tab button

	@param button Frame - The tab button
	@param label TextLabel - The tab label
	@param border Frame - The active border
	@param state string - State name: "Inactive", "Hover", or "Active"
]]
function TabSystem:_applyButtonState(button, label, border, state)
	local styles = Theme.Components.Tab[state]

	if not styles then
		warn("[TabSystem] Invalid state:", state)
		return
	end

	-- Apply background
	button.BackgroundColor3 = styles.BackgroundColor
	button.BackgroundTransparency = styles.BackgroundTransparency

	-- Apply text color
	label.TextColor3 = styles.TextColor

	-- Apply border (only visible for active state)
	if state == "Active" then
		border.BackgroundColor3 = styles.BorderColor
		border.Visible = true
	else
		border.Visible = false
	end
end

--[[
	Selects a tab by index

	@param index number - Tab index to activate (1-based)
	@param skipCallback boolean - If true, don't trigger onTabChange callback
]]
function TabSystem:selectTab(index, skipCallback)
	if self.isDestroyed then
		warn("[TabSystem] Cannot select tab on destroyed TabSystem")
		return
	end

	-- Validate index
	if index < 1 or index > #self.tabs then
		warn("[TabSystem] Invalid tab index:", index)
		return
	end

	-- If already active, do nothing
	if index == self.activeTabIndex then
		return
	end

	-- Deactivate current tab
	if self.activeTabIndex and self.tabButtons[self.activeTabIndex] then
		local oldButton = self.tabButtons[self.activeTabIndex]
		local oldLabel = oldButton:FindFirstChild("Label")
		local oldBorder = oldButton:FindFirstChild("ActiveBorder")
		if oldLabel and oldBorder then
			self:_applyButtonState(oldButton, oldLabel, oldBorder, "Inactive")
		end
	end

	-- Activate new tab
	self.activeTabIndex = index
	local newButton = self.tabButtons[index]
	local newLabel = newButton:FindFirstChild("Label")
	local newBorder = newButton:FindFirstChild("ActiveBorder")
	if newLabel and newBorder then
		self:_applyButtonState(newButton, newLabel, newBorder, "Active")
	end

	-- Trigger callback (unless explicitly skipped)
	if not skipCallback then
		local tabName = self.tabs[index].name
		self.onTabChange(index, tabName)
	end
end

--[[
	Gets the currently active tab index

	@return number - Active tab index (1-based)
]]
function TabSystem:getActiveTab()
	return self.activeTabIndex
end

--[[
	Gets the currently active tab name

	@return string - Active tab name
]]
function TabSystem:getActiveTabName()
	return self.tabs[self.activeTabIndex].name
end

--[[
	Gets the total number of tabs

	@return number - Total tab count
]]
function TabSystem:getTabCount()
	return #self.tabs
end

--[[
	Cleans up and destroys the tab system
	Disconnects all events and destroys UI elements
]]
function TabSystem:destroy()
	if self.isDestroyed then
		warn("[TabSystem] TabSystem already destroyed")
		return
	end

	self.isDestroyed = true

	-- Disconnect all event connections
	for _, connection in ipairs(self.connections) do
		connection:Disconnect()
	end

	-- Destroy sidebar and all tab buttons
	if self.sidebar then
		self.sidebar:Destroy()
	end

	-- Clear references
	self.sidebar = nil
	self.layout = nil
	self.tabButtons = {}
	self.connections = {}
	self.tabs = nil
	self.parent = nil
	self.onTabChange = nil
end

return TabSystem
