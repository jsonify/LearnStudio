--[[
    TutorialPanel.lua

    Tutorial tab UI that displays tutorial list and active tutorial steps.

    Features:
    - Tutorial list view with cards for each tutorial
    - Active tutorial view with step display
    - Progress tracking
    - Navigation controls
]]

local Theme = require(script.Parent.Theme)
local TabPanel = require(script.Parent.Components.TabPanel)

local TutorialPanel = {}
TutorialPanel.__index = TutorialPanel

--[[
    Creates a new TutorialPanel instance

    @param config table - Configuration options
        - parent: GuiObject - Parent container for the panel
        - tutorialEngine: TutorialEngine - Reference to tutorial engine

    @return table - TutorialPanel instance
]]
function TutorialPanel.new(config)
    local self = setmetatable({}, TutorialPanel)

    -- Validate config
    assert(config and config.parent, "TutorialPanel.new() requires config.parent")
    assert(config.tutorialEngine, "TutorialPanel.new() requires config.tutorialEngine")

    self.tutorialEngine = config.tutorialEngine

    -- Create the base panel using TabPanel
    self.panel = TabPanel.new({
        parent = config.parent,
        visible = false,
        padding = Theme.Components.Panel.Padding,
        name = "TutorialPanel"
    })

    -- Get the container for adding content
    local container = self.panel:getContainer()

    -- Create two main views
    self:_createListView(container)
    self:_createActiveView(container)

    -- Set up tutorial engine callbacks
    self:_setupCallbacks()

    -- Show list view by default
    self:_showListView()

    -- Populate tutorial list
    self:_refreshTutorialList()

    return self
end

--[[
    Create the tutorial list view
]]
function TutorialPanel:_createListView(container)
    -- List view container
    local listView = Instance.new("Frame")
    listView.Name = "ListView"
    listView.Size = UDim2.new(1, 0, 1, 0)
    listView.BackgroundTransparency = 1
    listView.Visible = true
    listView.Parent = container

    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Tutorials"
    title.TextColor3 = Theme.Colors.Text.Primary
    title.TextSize = Theme.Typography.Size.Large
    title.Font = Theme.Typography.Font.Heading
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = listView

    -- Scrolling frame for tutorial list
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "TutorialList"
    scrollFrame.Size = UDim2.new(1, -6, 1, -50)
    scrollFrame.Position = UDim2.new(0, 0, 0, 50)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Theme.Colors.Border.Default
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)  -- Will be updated dynamically
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = listView

    -- List layout
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 12)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollFrame

    -- Store references
    self.listView = listView
    self.tutorialList = scrollFrame
end

--[[
    Create the active tutorial view
]]
function TutorialPanel:_createActiveView(container)
    -- Active view container
    local activeView = Instance.new("Frame")
    activeView.Name = "ActiveView"
    activeView.Size = UDim2.new(1, 0, 1, 0)
    activeView.BackgroundTransparency = 1
    activeView.Visible = false
    activeView.Parent = container

    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 80)
    header.BackgroundColor3 = Theme.Colors.Background.Secondary
    header.BorderSizePixel = 0
    header.Parent = activeView
    Theme.applyCornerRadius(header, Theme.Spacing.CornerRadius.Medium)

    -- Tutorial title
    local tutorialTitle = Instance.new("TextLabel")
    tutorialTitle.Name = "TutorialTitle"
    tutorialTitle.Size = UDim2.new(1, -20, 0, 30)
    tutorialTitle.Position = UDim2.new(0, 10, 0, 10)
    tutorialTitle.BackgroundTransparency = 1
    tutorialTitle.Text = "Tutorial Name"
    tutorialTitle.TextColor3 = Theme.Colors.Text.Primary
    tutorialTitle.TextSize = Theme.Typography.Size.Large
    tutorialTitle.Font = Theme.Typography.Font.Heading
    tutorialTitle.TextXAlignment = Enum.TextXAlignment.Left
    tutorialTitle.Parent = header

    -- Progress text (Step X of Y)
    local progressText = Instance.new("TextLabel")
    progressText.Name = "ProgressText"
    progressText.Size = UDim2.new(1, -20, 0, 20)
    progressText.Position = UDim2.new(0, 10, 0, 45)
    progressText.BackgroundTransparency = 1
    progressText.Text = "Step 1 of 5"
    progressText.TextColor3 = Theme.Colors.Text.Secondary
    progressText.TextSize = Theme.Typography.Size.Small
    progressText.Font = Theme.Typography.Font.Primary
    progressText.TextXAlignment = Enum.TextXAlignment.Left
    progressText.Parent = header

    -- Exit button
    local exitButton = Instance.new("TextButton")
    exitButton.Name = "ExitButton"
    exitButton.Size = UDim2.new(0, 60, 0, 30)
    exitButton.Position = UDim2.new(1, -70, 0, 10)
    exitButton.BackgroundColor3 = Theme.Colors.Background.Tertiary
    exitButton.BorderSizePixel = 0
    exitButton.Text = "Exit"
    exitButton.TextColor3 = Theme.Colors.Text.Secondary
    exitButton.TextSize = Theme.Typography.Size.Body
    exitButton.Font = Theme.Typography.Font.Primary
    exitButton.Parent = header
    Theme.applyCornerRadius(exitButton, Theme.Spacing.CornerRadius.Small)

    -- Step content area
    local stepContent = Instance.new("ScrollingFrame")
    stepContent.Name = "StepContent"
    stepContent.Size = UDim2.new(1, -6, 1, -200)
    stepContent.Position = UDim2.new(0, 0, 0, 90)
    stepContent.BackgroundTransparency = 1
    stepContent.BorderSizePixel = 0
    stepContent.ScrollBarThickness = 6
    stepContent.ScrollBarImageColor3 = Theme.Colors.Border.Default
    stepContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    stepContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    stepContent.Parent = activeView

    -- Content layout
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 12)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = stepContent

    -- Step title
    local stepTitle = Instance.new("TextLabel")
    stepTitle.Name = "StepTitle"
    stepTitle.Size = UDim2.new(1, 0, 0, 30)
    stepTitle.BackgroundTransparency = 1
    stepTitle.Text = "Step Title"
    stepTitle.TextColor3 = Theme.Colors.Text.Primary
    stepTitle.TextSize = Theme.Typography.Size.Medium
    stepTitle.Font = Theme.Typography.Font.Heading
    stepTitle.TextXAlignment = Enum.TextXAlignment.Left
    stepTitle.TextWrapped = true
    stepTitle.Parent = stepContent

    -- Step instruction
    local stepInstruction = Instance.new("TextLabel")
    stepInstruction.Name = "StepInstruction"
    stepInstruction.Size = UDim2.new(1, 0, 0, 60)
    stepInstruction.BackgroundTransparency = 1
    stepInstruction.Text = "Instructions go here"
    stepInstruction.TextColor3 = Theme.Colors.Text.Primary
    stepInstruction.TextSize = Theme.Typography.Size.Body
    stepInstruction.Font = Theme.Typography.Font.Primary
    stepInstruction.TextXAlignment = Enum.TextXAlignment.Left
    stepInstruction.TextYAlignment = Enum.TextYAlignment.Top
    stepInstruction.TextWrapped = true
    stepInstruction.AutomaticSize = Enum.AutomaticSize.Y
    stepInstruction.Parent = stepContent

    -- Step details
    local stepDetails = Instance.new("TextLabel")
    stepDetails.Name = "StepDetails"
    stepDetails.Size = UDim2.new(1, -20, 0, 40)
    stepDetails.BackgroundColor3 = Theme.Colors.Background.Secondary
    stepDetails.BorderSizePixel = 0
    stepDetails.Text = "Details go here"
    stepDetails.TextColor3 = Theme.Colors.Text.Secondary
    stepDetails.TextSize = Theme.Typography.Size.Small
    stepDetails.Font = Theme.Typography.Font.Primary
    stepDetails.TextXAlignment = Enum.TextXAlignment.Left
    stepDetails.TextYAlignment = Enum.TextYAlignment.Top
    stepDetails.TextWrapped = true
    stepDetails.AutomaticSize = Enum.AutomaticSize.Y
    stepDetails.Parent = stepContent
    Theme.applyCornerRadius(stepDetails, Theme.Spacing.CornerRadius.Small)
    Theme.applyPadding(stepDetails, 10)

    -- Hint button
    local hintButton = Instance.new("TextButton")
    hintButton.Name = "HintButton"
    hintButton.Size = UDim2.new(0, 100, 0, 30)
    hintButton.BackgroundColor3 = Theme.Colors.Background.Secondary
    hintButton.BorderSizePixel = 0
    hintButton.Text = "💡 Show Hint"
    hintButton.TextColor3 = Theme.Colors.Text.Secondary
    hintButton.TextSize = Theme.Typography.Size.Body
    hintButton.Font = Theme.Typography.Font.Primary
    hintButton.Parent = stepContent
    Theme.applyCornerRadius(hintButton, Theme.Spacing.CornerRadius.Small)

    -- Hint text (initially hidden)
    local hintText = Instance.new("TextLabel")
    hintText.Name = "HintText"
    hintText.Size = UDim2.new(1, -20, 0, 40)
    hintText.BackgroundColor3 = Color3.fromRGB(80, 70, 50)
    hintText.BorderSizePixel = 0
    hintText.Text = "Hint goes here"
    hintText.TextColor3 = Color3.fromRGB(255, 220, 150)
    hintText.TextSize = Theme.Typography.Size.Small
    hintText.Font = Theme.Typography.Font.Primary
    hintText.TextXAlignment = Enum.TextXAlignment.Left
    hintText.TextYAlignment = Enum.TextYAlignment.Top
    hintText.TextWrapped = true
    hintText.AutomaticSize = Enum.AutomaticSize.Y
    hintText.Visible = false
    hintText.Parent = stepContent
    Theme.applyCornerRadius(hintText, Theme.Spacing.CornerRadius.Small)
    Theme.applyPadding(hintText, 10)

    -- Navigation controls
    local navControls = Instance.new("Frame")
    navControls.Name = "NavControls"
    navControls.Size = UDim2.new(1, 0, 0, 50)
    navControls.Position = UDim2.new(0, 0, 1, -60)
    navControls.BackgroundTransparency = 1
    navControls.Parent = activeView

    -- Previous button
    local prevButton = Instance.new("TextButton")
    prevButton.Name = "PrevButton"
    prevButton.Size = UDim2.new(0, 100, 0, 40)
    prevButton.Position = UDim2.new(0, 0, 0, 0)
    prevButton.BackgroundColor3 = Theme.Colors.Background.Secondary
    prevButton.BorderSizePixel = 0
    prevButton.Text = "← Previous"
    prevButton.TextColor3 = Theme.Colors.Text.Primary
    prevButton.TextSize = Theme.Typography.Size.Body
    prevButton.Font = Theme.Typography.Font.Primary
    prevButton.Parent = navControls
    Theme.applyCornerRadius(prevButton, Theme.Spacing.CornerRadius.Small)

    -- Next button
    local nextButton = Instance.new("TextButton")
    nextButton.Name = "NextButton"
    nextButton.Size = UDim2.new(0, 100, 0, 40)
    nextButton.Position = UDim2.new(1, -100, 0, 0)
    nextButton.BackgroundColor3 = Theme.Colors.Accent.Primary
    nextButton.BorderSizePixel = 0
    nextButton.Text = "Next →"
    nextButton.TextColor3 = Theme.Colors.Text.OnAccent
    nextButton.TextSize = Theme.Typography.Size.Body
    nextButton.Font = Theme.Typography.Font.Primary
    nextButton.Parent = navControls
    Theme.applyCornerRadius(nextButton, Theme.Spacing.CornerRadius.Small)

    -- Store references
    self.activeView = activeView
    self.tutorialTitle = tutorialTitle
    self.progressText = progressText
    self.exitButton = exitButton
    self.stepTitle = stepTitle
    self.stepInstruction = stepInstruction
    self.stepDetails = stepDetails
    self.hintButton = hintButton
    self.hintText = hintText
    self.prevButton = prevButton
    self.nextButton = nextButton

    -- Set up button callbacks
    exitButton.MouseButton1Click:Connect(function()
        self.tutorialEngine:exitTutorial()
    end)

    prevButton.MouseButton1Click:Connect(function()
        self.tutorialEngine:previousStep()
    end)

    nextButton.MouseButton1Click:Connect(function()
        self.tutorialEngine:nextStep()
    end)

    hintButton.MouseButton1Click:Connect(function()
        hintText.Visible = not hintText.Visible
        hintButton.Text = hintText.Visible and "💡 Hide Hint" or "💡 Show Hint"
    end)
end

--[[
    Set up tutorial engine callbacks
]]
function TutorialPanel:_setupCallbacks()
    self.tutorialEngine:onTutorialStarted(function(tutorialId)
        self:_showActiveView()
    end)

    self.tutorialEngine:onStepChanged(function(stepNumber, stepData, tutorial)
        self:_updateStepDisplay(stepNumber, stepData, tutorial)
    end)

    self.tutorialEngine:onTutorialCompleted(function(tutorialId)
        -- Show completion message then return to list
        task.wait(2)
        self.tutorialEngine:exitTutorial()
    end)

    self.tutorialEngine:onTutorialExited(function(tutorialId)
        self:_showListView()
        self:_refreshTutorialList()
    end)
end

--[[
    Show list view
]]
function TutorialPanel:_showListView()
    self.listView.Visible = true
    self.activeView.Visible = false
end

--[[
    Show active tutorial view
]]
function TutorialPanel:_showActiveView()
    self.listView.Visible = false
    self.activeView.Visible = true
end

--[[
    Refresh tutorial list
]]
function TutorialPanel:_refreshTutorialList()
    -- Clear existing cards
    for _, child in ipairs(self.tutorialList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- Get all tutorials
    local tutorials = self.tutorialEngine:getAllTutorials()

    -- Create cards for each tutorial
    for index, tutorial in ipairs(tutorials) do
        self:_createTutorialCard(tutorial, index)
    end
end

--[[
    Create a tutorial card
]]
function TutorialPanel:_createTutorialCard(tutorial, index)
    local card = Instance.new("Frame")
    card.Name = "TutorialCard_" .. tutorial.id
    card.Size = UDim2.new(1, 0, 0, 100)
    card.BackgroundColor3 = Theme.Colors.Background.Secondary
    card.BorderSizePixel = 0
    card.LayoutOrder = index
    card.Parent = self.tutorialList
    Theme.applyCornerRadius(card, Theme.Spacing.CornerRadius.Medium)

    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -120, 0, 25)
    title.Position = UDim2.new(0, 12, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = tutorial.title
    title.TextColor3 = Theme.Colors.Text.Primary
    title.TextSize = Theme.Typography.Size.Medium
    title.Font = Theme.Typography.Font.Heading
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.Parent = card

    -- Description
    local description = Instance.new("TextLabel")
    description.Name = "Description"
    description.Size = UDim2.new(1, -120, 0, 35)
    description.Position = UDim2.new(0, 12, 0, 35)
    description.BackgroundTransparency = 1
    description.Text = tutorial.description
    description.TextColor3 = Theme.Colors.Text.Secondary
    description.TextSize = Theme.Typography.Size.Small
    description.Font = Theme.Typography.Font.Primary
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.TextYAlignment = Enum.TextYAlignment.Top
    description.TextWrapped = true
    description.TextTruncate = Enum.TextTruncate.AtEnd
    description.Parent = card

    -- Metadata (difficulty, time)
    local metadata = Instance.new("TextLabel")
    metadata.Name = "Metadata"
    metadata.Size = UDim2.new(1, -120, 0, 20)
    metadata.Position = UDim2.new(0, 12, 0, 75)
    metadata.BackgroundTransparency = 1
    metadata.Text = string.format("%s • %d min", tutorial.difficulty, tutorial.estimatedTime)
    metadata.TextColor3 = Theme.Colors.Text.Tertiary
    metadata.TextSize = Theme.Typography.Size.Small
    metadata.Font = Theme.Typography.Font.Primary
    metadata.TextXAlignment = Enum.TextXAlignment.Left
    metadata.Parent = card

    -- Start button
    local startButton = Instance.new("TextButton")
    startButton.Name = "StartButton"
    startButton.Size = UDim2.new(0, 90, 0, 35)
    startButton.Position = UDim2.new(1, -100, 0.5, -17.5)
    startButton.BackgroundColor3 = Theme.Colors.Accent.Primary
    startButton.BorderSizePixel = 0
    startButton.Text = "Start"
    startButton.TextColor3 = Theme.Colors.Text.OnAccent
    startButton.TextSize = Theme.Typography.Size.Body
    startButton.Font = Theme.Typography.Font.Primary
    startButton.Parent = card
    Theme.applyCornerRadius(startButton, Theme.Spacing.CornerRadius.Small)

    -- Check if completed
    local completion = self.tutorialEngine:getTutorialCompletion(tutorial.id)
    if completion and completion.completed then
        startButton.Text = "Restart"

        -- Add checkmark
        local checkmark = Instance.new("TextLabel")
        checkmark.Name = "Checkmark"
        checkmark.Size = UDim2.new(0, 30, 0, 30)
        checkmark.Position = UDim2.new(1, -35, 0, 5)
        checkmark.BackgroundTransparency = 1
        checkmark.Text = "✓"
        checkmark.TextColor3 = Color3.fromRGB(100, 200, 100)
        checkmark.TextSize = 24
        checkmark.Font = Enum.Font.GothamBold
        checkmark.Parent = card
    end

    -- Button click handler
    startButton.MouseButton1Click:Connect(function()
        self.tutorialEngine:startTutorial(tutorial.id)
    end)

    -- Hover effects
    startButton.MouseEnter:Connect(function()
        startButton.BackgroundColor3 = Theme.Colors.Accent.Hover
    end)

    startButton.MouseLeave:Connect(function()
        startButton.BackgroundColor3 = Theme.Colors.Accent.Primary
    end)
end

--[[
    Update step display
]]
function TutorialPanel:_updateStepDisplay(stepNumber, stepData, tutorial)
    -- Update header
    self.tutorialTitle.Text = tutorial.title
    self.progressText.Text = string.format("Step %d of %d", stepNumber, #tutorial.steps)

    -- Update step content
    self.stepTitle.Text = stepData.title or ""
    self.stepInstruction.Text = stepData.instruction or ""

    -- Update details (show only if present)
    if stepData.details and stepData.details ~= "" then
        self.stepDetails.Text = stepData.details
        self.stepDetails.Visible = true
    else
        self.stepDetails.Visible = false
    end

    -- Update hint
    if stepData.hint and stepData.hint ~= "" then
        self.hintText.Text = stepData.hint
        self.hintButton.Visible = true
        self.hintText.Visible = false
        self.hintButton.Text = "💡 Show Hint"
    else
        self.hintButton.Visible = false
        self.hintText.Visible = false
    end

    -- Update navigation buttons
    self.prevButton.Visible = stepNumber > 1

    -- Change Next button text for manual validation steps
    if stepData.validation.type == "manual" then
        if stepNumber == #tutorial.steps then
            self.nextButton.Text = "Finish"
        else
            self.nextButton.Text = "Next →"
        end
        self.nextButton.Visible = true
    else
        -- For automatic validation, hide Next button
        self.nextButton.Text = "Waiting..."
        self.nextButton.Visible = false
    end
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
    -- Clean up views
    if self.listView then
        self.listView:Destroy()
    end
    if self.activeView then
        self.activeView:Destroy()
    end

    -- Destroy the base panel
    if self.panel then
        self.panel:destroy()
    end

    -- Clear references
    self.tutorialEngine = nil
    self.panel = nil
end

return TutorialPanel
