--[[
	TutorialPanel.lua
	Tutorials tab content (Phase 1 placeholder)
	Will eventually contain interactive tutorial list and step display
]]

local Theme = require(script.Parent.Theme)
local TabPanel = require(script.Parent.Components.TabPanel)

local TutorialPanel = {}
TutorialPanel.__index = TutorialPanel

--[[
	Creates a new TutorialPanel instance

	@param config table - Configuration options
		- parent: GuiObject - Parent container for the panel

	@return table - TutorialPanel instance with methods from TabPanel
]]
function TutorialPanel.new(config)
	local self = setmetatable({}, TutorialPanel)

	-- Validate config
	assert(config and config.parent, "TutorialPanel.new() requires config.parent")

	-- Create the base panel using TabPanel
	self.panel = TabPanel.new({
		parent = config.parent,
		visible = false,
		padding = Theme.Components.Panel.Padding,
		name = "TutorialPanel"
	})

	-- Get the container for adding content
	local container = self.panel:getContainer()

	-- Create placeholder content
	self:_createPlaceholderContent(container)

	return self
end

--[[
	Creates placeholder content for Phase 1
	This will be replaced with actual tutorial UI in future phases
]]
function TutorialPanel:_createPlaceholderContent(container)
	-- Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 40)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "📚 Tutorials"
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
	description.Text = "Interactive tutorials coming soon!\n\nThis tab will feature:\n\n• Step-by-step guided tutorials\n• Visual highlights of Studio UI\n• Progress tracking and checkpoints\n• Beginner to advanced content\n\nStay tuned for Phase 1 implementation! 🚀"
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
function TutorialPanel:show()
	return self.panel:show()
end

function TutorialPanel:hide()
	return self.panel:hide()
end

function TutorialPanel:getVisible()
	return self.panel:getVisible()
end

function TutorialPanel:getContainer()
	return self.panel:getContainer()
end

function TutorialPanel:destroy()
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

return TutorialPanel
