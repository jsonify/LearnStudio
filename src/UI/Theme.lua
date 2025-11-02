--[[
	Theme.lua
	Centralized design system for LearnStudio UI
	Provides consistent colors, typography, spacing, and component styles
]]

local Theme = {}

-- ============================================================================
-- COLOR PALETTE
-- ============================================================================

Theme.Colors = {
	-- Background colors (dark theme)
	Background = {
		Primary = Color3.fromRGB(50, 50, 50),      -- Main content area
		Secondary = Color3.fromRGB(45, 45, 45),    -- Container backgrounds
		Sidebar = Color3.fromRGB(35, 35, 35),      -- Left sidebar
		Header = Color3.fromRGB(35, 35, 35),       -- Top header bar
		Elevated = Color3.fromRGB(60, 60, 60),     -- Cards, elevated elements
	},

	-- Text colors
	Text = {
		Primary = Color3.fromRGB(255, 255, 255),   -- Main headings, active text
		Secondary = Color3.fromRGB(200, 200, 200), -- Body text, descriptions
		Tertiary = Color3.fromRGB(150, 150, 150),  -- Muted text, hints
		Disabled = Color3.fromRGB(100, 100, 100),  -- Disabled state
	},

	-- Accent colors
	Accent = {
		Primary = Color3.fromRGB(88, 166, 255),    -- Primary actions, links
		Success = Color3.fromRGB(76, 175, 80),     -- Success states, completed
		Warning = Color3.fromRGB(255, 152, 0),     -- Warnings, caution
		Error = Color3.fromRGB(244, 67, 54),       -- Errors, danger
		Info = Color3.fromRGB(33, 150, 243),       -- Information, tips
	},

	-- Interactive states
	Interactive = {
		Hover = Color3.fromRGB(70, 70, 70),        -- Hover backgrounds
		Active = Color3.fromRGB(80, 80, 80),       -- Active/pressed state
		Selected = Color3.fromRGB(65, 65, 65),     -- Selected item background
		Border = Color3.fromRGB(100, 100, 100),    -- Borders, dividers
		BorderActive = Color3.fromRGB(88, 166, 255), -- Active element borders
	},
}

-- ============================================================================
-- TYPOGRAPHY
-- ============================================================================

Theme.Typography = {
	-- Font families
	Font = {
		Primary = Enum.Font.Gotham,           -- Body text, UI elements
		Heading = Enum.Font.GothamBold,       -- Headings, emphasis
		Mono = Enum.Font.RobotoMono,          -- Code, monospace
	},

	-- Font sizes
	Size = {
		Tiny = 10,        -- Very small labels
		Small = 12,       -- Tab labels, small UI text
		Body = 14,        -- Default body text
		Medium = 16,      -- Subheadings
		Large = 18,       -- Section headings
		XLarge = 22,      -- Main headings
		XXLarge = 28,     -- Hero text
	},

	-- Text weights (using font variants)
	Weight = {
		Regular = Enum.Font.Gotham,
		Medium = Enum.Font.GothamMedium,
		Bold = Enum.Font.GothamBold,
	},
}

-- ============================================================================
-- SPACING & LAYOUT
-- ============================================================================

Theme.Spacing = {
	-- Base unit: 4px
	-- All spacing should be multiples of this for consistency
	Base = 4,

	-- Padding presets
	Padding = {
		None = 0,
		Tiny = 4,
		Small = 8,
		Medium = 12,
		Large = 16,
		XLarge = 24,
		XXLarge = 32,
	},

	-- Gap between elements
	Gap = {
		Tiny = 4,
		Small = 8,
		Medium = 12,
		Large = 16,
		XLarge = 24,
	},

	-- Component-specific dimensions
	Dimensions = {
		HeaderHeight = 50,       -- Top header bar
		SidebarWidth = 70,       -- Left sidebar for tabs
		TabHeight = 60,          -- Individual tab button height
		BorderWidth = 1,         -- Standard border width
		BorderWidthThick = 3,    -- Accent borders
		CornerRadius = 4,        -- UI corner rounding (future use)
	},
}

-- ============================================================================
-- ANIMATION & TRANSITIONS
-- ============================================================================

Theme.Animation = {
	-- Duration in seconds
	Duration = {
		Instant = 0,
		Fast = 0.1,       -- Quick hover states
		Normal = 0.2,     -- Standard transitions
		Slow = 0.3,       -- Emphasized transitions
	},

	-- Easing styles
	Easing = {
		Linear = Enum.EasingStyle.Linear,
		Smooth = Enum.EasingStyle.Quad,
		Bounce = Enum.EasingStyle.Bounce,
		Elastic = Enum.EasingStyle.Elastic,
	},
}

-- ============================================================================
-- COMPONENT STYLES
-- ============================================================================

-- Pre-configured styles for common components
Theme.Components = {
	-- Tab button styles
	Tab = {
		Width = 70,
		Height = 60,
		Padding = 8,
		FontSize = 12,
		Font = Enum.Font.Gotham,

		-- States
		Inactive = {
			BackgroundColor = Color3.fromRGB(35, 35, 35),
			BackgroundTransparency = 1,  -- Fully transparent
			TextColor = Color3.fromRGB(150, 150, 150),
			BorderColor = Color3.fromRGB(35, 35, 35),
		},

		Hover = {
			BackgroundColor = Color3.fromRGB(45, 45, 45),
			BackgroundTransparency = 0,
			TextColor = Color3.fromRGB(200, 200, 200),
			BorderColor = Color3.fromRGB(45, 45, 45),
		},

		Active = {
			BackgroundColor = Color3.fromRGB(50, 50, 50),
			BackgroundTransparency = 0,
			TextColor = Color3.fromRGB(255, 255, 255),
			BorderColor = Color3.fromRGB(88, 166, 255),  -- Accent color
		},
	},

	-- Panel/container styles
	Panel = {
		BackgroundColor = Color3.fromRGB(50, 50, 50),
		Padding = 16,
		BorderColor = Color3.fromRGB(100, 100, 100),
	},

	-- Button styles (for future use)
	Button = {
		Height = 32,
		Padding = 12,
		FontSize = 14,
		Font = Enum.Font.Gotham,

		Primary = {
			BackgroundColor = Color3.fromRGB(88, 166, 255),
			TextColor = Color3.fromRGB(255, 255, 255),
			HoverColor = Color3.fromRGB(100, 180, 255),
		},

		Secondary = {
			BackgroundColor = Color3.fromRGB(70, 70, 70),
			TextColor = Color3.fromRGB(255, 255, 255),
			HoverColor = Color3.fromRGB(80, 80, 80),
		},
	},
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Apply standard padding to a frame
function Theme.ApplyPadding(frame, padding)
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingTop = UDim.new(0, padding)
	uiPadding.PaddingBottom = UDim.new(0, padding)
	uiPadding.PaddingLeft = UDim.new(0, padding)
	uiPadding.PaddingRight = UDim.new(0, padding)
	uiPadding.Parent = frame
	return uiPadding
end

-- Apply rounded corners to a frame (using UICorner)
function Theme.ApplyCornerRadius(frame, radius)
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, radius or Theme.Spacing.Dimensions.CornerRadius)
	uiCorner.Parent = frame
	return uiCorner
end

-- Create a divider line
function Theme.CreateDivider(parent, orientation)
	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.BackgroundColor3 = Theme.Colors.Interactive.Border
	divider.BorderSizePixel = 0

	if orientation == "Horizontal" then
		divider.Size = UDim2.new(1, 0, 0, 1)
	else -- Vertical
		divider.Size = UDim2.new(0, 1, 1, 0)
	end

	divider.Parent = parent
	return divider
end

-- ============================================================================
-- EXPORT
-- ============================================================================

return Theme
