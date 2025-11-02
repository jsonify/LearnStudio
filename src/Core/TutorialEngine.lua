--[[
    TutorialEngine.lua

    Core tutorial system that manages tutorial state, step progression, and validation.

    State Machine:
    - Idle: No tutorial active
    - Active: Tutorial in progress, showing current step
    - Waiting: Waiting for user to complete step validation
    - Completed: Tutorial finished

    Events:
    - TutorialStarted(tutorialId)
    - StepChanged(stepNumber, stepData)
    - StepCompleted(stepNumber)
    - TutorialCompleted(tutorialId)
    - TutorialExited(tutorialId)
]]

local TutorialEngine = {}
TutorialEngine.__index = TutorialEngine

-- State constants
TutorialEngine.States = {
    IDLE = "idle",
    ACTIVE = "active",
    WAITING = "waiting",
    COMPLETED = "completed"
}

-- Create a new TutorialEngine instance
function TutorialEngine.new(plugin)
    local self = setmetatable({}, TutorialEngine)

    self.plugin = plugin
    self.state = TutorialEngine.States.IDLE

    -- Tutorial data
    self.tutorials = {}  -- Loaded tutorial data
    self.currentTutorial = nil
    self.currentStep = 0

    -- Event callbacks
    self.callbacks = {
        onTutorialStarted = nil,
        onStepChanged = nil,
        onStepCompleted = nil,
        onTutorialCompleted = nil,
        onTutorialExited = nil,
    }

    -- Load tutorials
    self:loadTutorials()

    -- Load saved progress
    self:loadProgress()

    return self
end

-- Load all tutorial data from Data/Tutorials folder
function TutorialEngine:loadTutorials()
    local tutorialFolder = script.Parent.Parent.Data.Tutorials

    -- Get all tutorial modules (skip the schema file)
    for _, child in ipairs(tutorialFolder:GetChildren()) do
        if child:IsA("ModuleScript") and child.Name:match("^Tutorial_") then
            local success, tutorialData = pcall(require, child)
            if success and tutorialData then
                -- Store tutorial by ID
                self.tutorials[tutorialData.id] = tutorialData

                -- Initialize completion tracking
                if not self:getTutorialCompletion(tutorialData.id) then
                    self:setTutorialCompletion(tutorialData.id, {
                        completed = false,
                        currentStep = 0,
                        completedSteps = {},
                    })
                end
            else
                warn("Failed to load tutorial:", child.Name, tutorialData)
            end
        end
    end

    print("[TutorialEngine] Loaded", self:getTutorialCount(), "tutorials")
end

-- Get tutorial count
function TutorialEngine:getTutorialCount()
    local count = 0
    for _ in pairs(self.tutorials) do
        count = count + 1
    end
    return count
end

-- Get all tutorials (returns array for easier UI iteration)
function TutorialEngine:getAllTutorials()
    local tutorialList = {}
    for id, tutorial in pairs(self.tutorials) do
        table.insert(tutorialList, tutorial)
    end

    -- Sort by tutorial ID (which includes numbering)
    table.sort(tutorialList, function(a, b)
        return a.id < b.id
    end)

    return tutorialList
end

-- Get tutorial by ID
function TutorialEngine:getTutorial(tutorialId)
    return self.tutorials[tutorialId]
end

-- Start a tutorial
function TutorialEngine:startTutorial(tutorialId)
    local tutorial = self.tutorials[tutorialId]
    if not tutorial then
        warn("[TutorialEngine] Tutorial not found:", tutorialId)
        return false
    end

    -- Check if already active
    if self.state == TutorialEngine.States.ACTIVE then
        self:exitTutorial()
    end

    -- Set state
    self.state = TutorialEngine.States.ACTIVE
    self.currentTutorial = tutorialId
    self.currentStep = 1

    -- Save progress
    self:saveProgress()

    -- Fire callback
    if self.callbacks.onTutorialStarted then
        self.callbacks.onTutorialStarted(tutorialId)
    end

    -- Show first step
    self:showCurrentStep()

    print("[TutorialEngine] Started tutorial:", tutorialId)
    return true
end

-- Exit current tutorial
function TutorialEngine:exitTutorial()
    if self.state == TutorialEngine.States.IDLE then
        return
    end

    local tutorialId = self.currentTutorial

    -- Reset state
    self.state = TutorialEngine.States.IDLE
    self.currentTutorial = nil
    self.currentStep = 0

    -- Fire callback
    if self.callbacks.onTutorialExited then
        self.callbacks.onTutorialExited(tutorialId)
    end

    print("[TutorialEngine] Exited tutorial:", tutorialId)
end

-- Show current step
function TutorialEngine:showCurrentStep()
    if not self.currentTutorial then return end

    local tutorial = self.tutorials[self.currentTutorial]
    if not tutorial then return end

    local step = tutorial.steps[self.currentStep]
    if not step then
        warn("[TutorialEngine] Invalid step number:", self.currentStep)
        return
    end

    -- Fire step changed callback
    if self.callbacks.onStepChanged then
        self.callbacks.onStepChanged(self.currentStep, step, tutorial)
    end

    -- Set state to waiting if validation is not manual
    if step.validation.type ~= "manual" then
        self.state = TutorialEngine.States.WAITING
    end

    print("[TutorialEngine] Showing step", self.currentStep, "of", #tutorial.steps)
end

-- Advance to next step
function TutorialEngine:nextStep()
    if not self.currentTutorial then return end

    local tutorial = self.tutorials[self.currentTutorial]
    if not tutorial then return end

    -- Mark current step as completed
    self:markStepCompleted(self.currentStep)

    -- Check if tutorial is complete
    if self.currentStep >= #tutorial.steps then
        self:completeTutorial()
        return
    end

    -- Move to next step
    self.currentStep = self.currentStep + 1
    self.state = TutorialEngine.States.ACTIVE

    -- Save progress
    self:saveProgress()

    -- Show next step
    self:showCurrentStep()
end

-- Go back to previous step
function TutorialEngine:previousStep()
    if not self.currentTutorial then return end
    if self.currentStep <= 1 then return end

    self.currentStep = self.currentStep - 1
    self.state = TutorialEngine.States.ACTIVE

    -- Save progress
    self:saveProgress()

    -- Show previous step
    self:showCurrentStep()
end

-- Mark step as completed
function TutorialEngine:markStepCompleted(stepNumber)
    if not self.currentTutorial then return end

    local completion = self:getTutorialCompletion(self.currentTutorial)
    if not completion.completedSteps then
        completion.completedSteps = {}
    end

    completion.completedSteps[stepNumber] = true
    completion.currentStep = stepNumber

    self:setTutorialCompletion(self.currentTutorial, completion)

    -- Fire callback
    if self.callbacks.onStepCompleted then
        self.callbacks.onStepCompleted(stepNumber)
    end
end

-- Complete current tutorial
function TutorialEngine:completeTutorial()
    if not self.currentTutorial then return end

    local tutorialId = self.currentTutorial

    -- Mark as completed
    local completion = self:getTutorialCompletion(tutorialId)
    completion.completed = true
    completion.completedAt = os.time()
    self:setTutorialCompletion(tutorialId, completion)

    -- Change state
    self.state = TutorialEngine.States.COMPLETED

    -- Fire callback
    if self.callbacks.onTutorialCompleted then
        self.callbacks.onTutorialCompleted(tutorialId)
    end

    print("[TutorialEngine] Completed tutorial:", tutorialId)
end

-- Validate step completion (called by StudioMonitor)
function TutorialEngine:validateStep(validationType, data)
    if self.state ~= TutorialEngine.States.WAITING then
        return false
    end

    if not self.currentTutorial then return false end

    local tutorial = self.tutorials[self.currentTutorial]
    if not tutorial then return false end

    local step = tutorial.steps[self.currentStep]
    if not step then return false end

    -- Check if validation type matches
    if step.validation.type ~= validationType then
        return false
    end

    -- Validate based on type
    local isValid = false

    if validationType == "partCreated" then
        isValid = self:validatePartCreated(step.validation, data)
    elseif validationType == "selectionChanged" then
        isValid = self:validateSelectionChanged(step.validation, data)
    elseif validationType == "propertyChanged" or validationType == "propertySet" then
        isValid = self:validatePropertyChanged(step.validation, data)
    elseif validationType == "scriptCreated" then
        isValid = self:validateScriptCreated(step.validation, data)
    elseif validationType == "objectCreated" then
        isValid = self:validateObjectCreated(step.validation, data)
    end

    -- If valid, advance to next step
    if isValid then
        print("[TutorialEngine] Step validation passed!")

        -- Small delay for better UX
        task.wait(0.5)

        self:nextStep()
        return true
    end

    return false
end

-- Validation helpers
function TutorialEngine:validatePartCreated(validation, data)
    if not data or not data.part then return false end

    -- Check part type if specified
    if validation.partType then
        return data.part.ClassName == validation.partType
    end

    return true
end

function TutorialEngine:validateSelectionChanged(validation, data)
    if not data or not data.selection then return false end

    -- Check if anything is selected
    if #data.selection == 0 then return false end

    -- Check object type if specified
    if validation.objectType then
        for _, obj in ipairs(data.selection) do
            if obj.ClassName == validation.objectType then
                return true
            end
        end
        return false
    end

    return true
end

function TutorialEngine:validatePropertyChanged(validation, data)
    if not data or not data.object then return false end

    -- Check object type if specified
    if validation.objectType then
        if data.object.ClassName ~= validation.objectType then
            return false
        end
    end

    -- Check property name if specified
    if validation.propertyName then
        if data.propertyName ~= validation.propertyName then
            return false
        end
    end

    -- Check expected value if specified
    if validation.expectedValue ~= nil then
        return data.newValue == validation.expectedValue
    end

    return true
end

function TutorialEngine:validateScriptCreated(validation, data)
    if not data or not data.script then return false end

    -- Check script type if specified
    if validation.scriptType then
        if data.script.ClassName ~= validation.scriptType then
            return false
        end
    end

    -- Check parent type if specified
    if validation.parentType then
        if data.script.Parent and data.script.Parent.ClassName ~= validation.parentType then
            return false
        end
    end

    return true
end

function TutorialEngine:validateObjectCreated(validation, data)
    if not data or not data.object then return false end

    -- Check object type if specified
    if validation.objectType then
        if data.object.ClassName ~= validation.objectType then
            return false
        end
    end

    -- Check parent type if specified
    if validation.parentType then
        if data.object.Parent and data.object.Parent.ClassName ~= validation.parentType then
            return false
        end
    end

    return true
end

-- Event callbacks
function TutorialEngine:onTutorialStarted(callback)
    self.callbacks.onTutorialStarted = callback
end

function TutorialEngine:onStepChanged(callback)
    self.callbacks.onStepChanged = callback
end

function TutorialEngine:onStepCompleted(callback)
    self.callbacks.onStepCompleted = callback
end

function TutorialEngine:onTutorialCompleted(callback)
    self.callbacks.onTutorialCompleted = callback
end

function TutorialEngine:onTutorialExited(callback)
    self.callbacks.onTutorialExited = callback
end

-- Progress persistence
function TutorialEngine:saveProgress()
    if not self.currentTutorial then return end

    local completion = self:getTutorialCompletion(self.currentTutorial)
    completion.currentStep = self.currentStep
    self:setTutorialCompletion(self.currentTutorial, completion)
end

function TutorialEngine:loadProgress()
    -- Progress is loaded per-tutorial when tutorials are loaded
    -- This could be extended to restore the last active tutorial
end

function TutorialEngine:getTutorialCompletion(tutorialId)
    local saved = self.plugin:GetSetting("Tutorial_" .. tutorialId)
    if saved then
        return saved
    end
    return {
        completed = false,
        currentStep = 0,
        completedSteps = {},
    }
end

function TutorialEngine:setTutorialCompletion(tutorialId, completion)
    self.plugin:SetSetting("Tutorial_" .. tutorialId, completion)
end

-- Get current state
function TutorialEngine:getState()
    return self.state
end

function TutorialEngine:getCurrentTutorial()
    return self.currentTutorial
end

function TutorialEngine:getCurrentStep()
    return self.currentStep
end

function TutorialEngine:getCurrentStepData()
    if not self.currentTutorial then return nil end
    local tutorial = self.tutorials[self.currentTutorial]
    if not tutorial then return nil end
    return tutorial.steps[self.currentStep]
end

-- Cleanup
function TutorialEngine:destroy()
    self.callbacks = {}
    self.tutorials = {}
    self.currentTutorial = nil
    self.currentStep = 0
end

return TutorialEngine
