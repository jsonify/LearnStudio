--[[
	TabPanel.lua
	Reusable content container for tab content
	Provides consistent styling and show/hide functionality
]]

local Theme = require(script.Parent.Parent.Theme)

local TabPanel = {}
TabPanel.__index = TabPanel

--[[
	Creates a new TabPanel instance

	@param config table - Configuration options
		- parent: GuiObject - Parent container for the panel
		- visible: boolean - Initial visibility state (default: false)
		- padding: number - Internal padding (default: Theme.Components.Panel.Padding)
		- name: string - Optional name for the panel frame

	@return table - TabPanel instance with methods: show(), hide(), destroy()
]]
function TabPanel.new(config)
	local self = setmetatable({}, TabPanel)

	-- Validate config
	assert(config and config.parent, "TabPanel.new() requires config.parent")

	-- Store configuration
	self.parent = config.parent
	self.isVisible = config.visible or false
	self.padding = config.padding or Theme.Components.Panel.Padding

	-- Create the main container frame
	self.container = Instance.new("Frame")
	self.container.Name = config.name or "TabPanel"
	self.container.Size = UDim2.new(1, 0, 1, 0)
	self.container.Position = UDim2.new(0, 0, 0, 0)
	self.container.BackgroundColor3 = Theme.Components.Panel.BackgroundColor
	self.container.BorderSizePixel = 0
	self.container.Visible = self.isVisible
	self.container.Parent = self.parent

	-- Apply padding to content area
	self.uiPadding = Theme.ApplyPadding(self.container, self.padding)

	-- Track if panel has been destroyed
	self.isDestroyed = false

	return self
end

--[[
	Shows the panel (makes it visible)
]]
function TabPanel:show()
	if self.isDestroyed then
		warn("[TabPanel] Cannot show destroyed panel")
		return
	end

	self.isVisible = true
	self.container.Visible = true
end

--[[
	Hides the panel (makes it invisible)
]]
function TabPanel:hide()
	if self.isDestroyed then
		warn("[TabPanel] Cannot hide destroyed panel")
		return
	end

	self.isVisible = false
	self.container.Visible = false
end

--[[
	Checks if the panel is currently visible

	@return boolean - True if visible, false otherwise
]]
function TabPanel:getVisible()
	return self.isVisible
end

--[[
	Sets the padding of the panel

	@param padding number - New padding value in pixels
]]
function TabPanel:setPadding(padding)
	if self.isDestroyed then
		warn("[TabPanel] Cannot set padding on destroyed panel")
		return
	end

	self.padding = padding
	self.uiPadding.PaddingTop = UDim.new(0, padding)
	self.uiPadding.PaddingBottom = UDim.new(0, padding)
	self.uiPadding.PaddingLeft = UDim.new(0, padding)
	self.uiPadding.PaddingRight = UDim.new(0, padding)
end

--[[
	Gets the container frame for adding content

	@return Frame - The container frame
]]
function TabPanel:getContainer()
	return self.container
end

--[[
	Cleans up and destroys the panel
	Should be called when the panel is no longer needed
]]
function TabPanel:destroy()
	if self.isDestroyed then
		warn("[TabPanel] Panel already destroyed")
		return
	end

	self.isDestroyed = true

	-- Destroy UI elements
	if self.container then
		self.container:Destroy()
	end

	-- Clear references
	self.container = nil
	self.uiPadding = nil
	self.parent = nil
end

return TabPanel
