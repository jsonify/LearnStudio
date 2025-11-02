--[[
	Dashboard.lua
	Progress dashboard tab content (Phase 1 placeholder)
	Will eventually contain user progress tracking and stats visualization
]]

local Theme = require(script.Parent.Theme)
local TabPanel = require(script.Parent.Components.TabPanel)

local Dashboard = {}
Dashboard.__index = Dashboard

--[[
	Creates a new Dashboard instance

	@param config table - Configuration options
		- parent: GuiObject - Parent container for the panel

	@return table - Dashboard instance with methods from TabPanel
]]
function Dashboard.new(config)
	local self = setmetatable({}, Dashboard)

	-- Validate config
	assert(config and config.parent, "Dashboard.new() requires config.parent")

	-- Create the base panel using TabPanel
	self.panel = TabPanel.new({
		parent = config.parent,
		visible = false,
		padding = Theme.Components.Panel.Padding,
		name = "DashboardPanel"
	})

	-- Get the container for adding content
	local container = self.panel:getContainer()

	-- Create placeholder content
	self:_createPlaceholderContent(container)

	return self
end

--[[
	Creates placeholder content for Phase 1
	This will be replaced with actual dashboard UI in future phases
]]
function Dashboard:_createPlaceholderContent(container)
	-- Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 40)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "📊 Progress Dashboard"
	title.TextColor3 = Theme.Colors.Text.Primary
	title.TextSize = Theme.Typography.Size.Large
	title.Font = Theme.Typography.Font.Heading
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = container

	-- Description
	local description = Instance.new("TextLabel")
	description.Name = "Description"
	description.Size = UDim2.new(1, 0, 1, -60)
	description.Position = UDim2.new(0, 0, 0, 60)
	description.BackgroundTransparency = 1
	description.Text = "Progress tracking coming soon!\n\nThis tab will feature:\n\n• Tutorials completed tracker\n• Challenge success rates\n• Time spent learning\n• Skill level assessments\n• Achievement system\n• Learning streak tracking\n\nStay tuned for Phase 1 implementation! 🎯"
	description.TextColor3 = Theme.Colors.Text.Secondary
	description.TextSize = Theme.Typography.Size.Body
	description.Font = Theme.Typography.Font.Primary
	description.TextWrapped = true
	description.TextXAlignment = Enum.TextXAlignment.Left
	description.TextYAlignment = Enum.TextYAlignment.Top
	description.Parent = container

	-- Store references
	self.title = title
	self.description = description
end

-- Proxy methods to TabPanel
function Dashboard:show()
	return self.panel:show()
end

function Dashboard:hide()
	return self.panel:hide()
end

function Dashboard:getVisible()
	return self.panel:getVisible()
end

function Dashboard:getContainer()
	return self.panel:getContainer()
end

function Dashboard:destroy()
	-- Clean up our content
	if self.title then
		self.title:Destroy()
	end
	if self.description then
		self.description:Destroy()
	end

	-- Destroy the base panel
	if self.panel then
		self.panel:destroy()
	end

	-- Clear references
	self.title = nil
	self.description = nil
	self.panel = nil
end

return Dashboard
