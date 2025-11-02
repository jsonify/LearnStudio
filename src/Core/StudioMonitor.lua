--[[
    StudioMonitor.lua

    Monitors Roblox Studio events and user actions to detect tutorial step completion.

    Monitors:
    - Part creation in Workspace
    - Selection changes
    - Script creation
    - Property changes
    - Object creation/deletion

    This module acts as a bridge between Studio events and TutorialEngine validation.
]]

local Selection = game:GetService("Selection")
local RunService = game:GetService("RunService")

local StudioMonitor = {}
StudioMonitor.__index = StudioMonitor

-- Create a new StudioMonitor instance
function StudioMonitor.new(tutorialEngine)
    local self = setmetatable({}, StudioMonitor)

    self.tutorialEngine = tutorialEngine
    self.connections = {}
    self.isMonitoring = false

    -- Debounce settings
    self.debounceDelay = 0.3  -- 300ms debounce for rapid events

    -- Tracked objects for property change monitoring
    self.trackedObjects = {}

    return self
end

-- Start monitoring Studio events
function StudioMonitor:startMonitoring()
    if self.isMonitoring then return end

    print("[StudioMonitor] Starting Studio event monitoring")

    -- Monitor part creation in Workspace
    self:connectPartCreation()

    -- Monitor selection changes
    self:connectSelectionChanged()

    -- Monitor script creation
    self:connectScriptCreation()

    -- Monitor general object creation (for ClickDetectors, etc.)
    self:connectObjectCreation()

    self.isMonitoring = true
end

-- Stop monitoring
function StudioMonitor:stopMonitoring()
    if not self.isMonitoring then return end

    print("[StudioMonitor] Stopping Studio event monitoring")

    -- Disconnect all connections
    for _, connection in ipairs(self.connections) do
        connection:Disconnect()
    end
    self.connections = {}

    -- Clear tracked objects
    for object, _ in pairs(self.trackedObjects) do
        self:stopTrackingObject(object)
    end

    self.isMonitoring = false
end

-- Connect to Workspace part creation
function StudioMonitor:connectPartCreation()
    local workspace = game:GetService("Workspace")

    local function onChildAdded(child)
        -- Debounce check
        if not RunService:IsEdit() then return end

        -- Check if it's a Part or BasePart
        if child:IsA("BasePart") then
            print("[StudioMonitor] Part created:", child.Name, child.ClassName)

            -- Notify tutorial engine
            self.tutorialEngine:validateStep("partCreated", {
                part = child
            })

            -- Start tracking this part for property changes
            self:trackObject(child)
        end
    end

    local connection = workspace.ChildAdded:Connect(onChildAdded)
    table.insert(self.connections, connection)

    -- Also monitor descendants for nested parts
    local descConnection = workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") then
            onChildAdded(descendant)
        end
    end)
    table.insert(self.connections, descConnection)
end

-- Connect to selection changes
function StudioMonitor:connectSelectionChanged()
    local debounceTimer = nil

    local function onSelectionChanged()
        -- Debounce rapid selection changes
        if debounceTimer then
            debounceTimer:Disconnect()
        end

        debounceTimer = task.delay(self.debounceDelay, function()
            local selection = Selection:Get()

            print("[StudioMonitor] Selection changed:", #selection, "objects selected")

            -- Notify tutorial engine
            self.tutorialEngine:validateStep("selectionChanged", {
                selection = selection
            })

            -- Track selected objects for property changes
            for _, obj in ipairs(selection) do
                if obj:IsA("Instance") then
                    self:trackObject(obj)
                end
            end

            debounceTimer = nil
        end)
    end

    local connection = Selection.SelectionChanged:Connect(onSelectionChanged)
    table.insert(self.connections, connection)
end

-- Connect to script creation
function StudioMonitor:connectScriptCreation()
    local workspace = game:GetService("Workspace")

    local function onScriptAdded(script)
        if script:IsA("BaseScript") then
            print("[StudioMonitor] Script created:", script.Name, script.ClassName)

            -- Notify tutorial engine
            self.tutorialEngine:validateStep("scriptCreated", {
                script = script
            })
        end
    end

    -- Monitor scripts in Workspace (most common location for beginners)
    local workspaceConnection = workspace.DescendantAdded:Connect(onScriptAdded)
    table.insert(self.connections, workspaceConnection)

    -- Also monitor ServerScriptService
    local serverScriptService = game:GetService("ServerScriptService")
    local sssConnection = serverScriptService.DescendantAdded:Connect(onScriptAdded)
    table.insert(self.connections, sssConnection)

    -- Monitor StarterPlayer scripts
    local starterPlayer = game:GetService("StarterPlayer")
    local starterConnection = starterPlayer.DescendantAdded:Connect(onScriptAdded)
    table.insert(self.connections, starterConnection)
end

-- Connect to general object creation (ClickDetector, etc.)
function StudioMonitor:connectObjectCreation()
    local workspace = game:GetService("Workspace")

    local function onObjectAdded(object)
        -- Notify for any object creation
        if object:IsA("Instance") then
            print("[StudioMonitor] Object created:", object.Name, object.ClassName)

            -- Notify tutorial engine
            self.tutorialEngine:validateStep("objectCreated", {
                object = object
            })
        end
    end

    local connection = workspace.DescendantAdded:Connect(onObjectAdded)
    table.insert(self.connections, connection)
end

-- Track an object for property changes
function StudioMonitor:trackObject(object)
    if not object or not object:IsA("Instance") then return end

    -- Don't track if already tracking
    if self.trackedObjects[object] then return end

    print("[StudioMonitor] Tracking object for property changes:", object.Name)

    -- Store connections for this object
    self.trackedObjects[object] = {}

    -- Common properties to monitor
    local propertiesToMonitor = {
        "Position", "Size", "Color", "BrickColor", "Material",
        "Transparency", "Anchored", "CFrame", "Name"
    }

    for _, propName in ipairs(propertiesToMonitor) do
        -- Check if property exists on this object
        local success, currentValue = pcall(function()
            return object[propName]
        end)

        if success then
            -- Create a property changed signal
            local connection = object:GetPropertyChangedSignal(propName):Connect(function()
                local newValue = object[propName]
                print("[StudioMonitor] Property changed:", object.Name, propName, "=", tostring(newValue))

                -- Notify tutorial engine
                self.tutorialEngine:validateStep("propertyChanged", {
                    object = object,
                    propertyName = propName,
                    newValue = newValue
                })

                -- Also try propertySet validation type
                self.tutorialEngine:validateStep("propertySet", {
                    object = object,
                    propertyName = propName,
                    newValue = newValue
                })
            end)

            table.insert(self.trackedObjects[object], connection)
        end
    end

    -- Clean up when object is destroyed
    local ancestryConnection = object.AncestryChanged:Connect(function(child, parent)
        if not parent then
            -- Object was removed/destroyed
            self:stopTrackingObject(object)
        end
    end)
    table.insert(self.trackedObjects[object], ancestryConnection)
end

-- Stop tracking an object
function StudioMonitor:stopTrackingObject(object)
    if not self.trackedObjects[object] then return end

    -- Disconnect all property change connections
    for _, connection in ipairs(self.trackedObjects[object]) do
        connection:Disconnect()
    end

    self.trackedObjects[object] = nil
end

-- Cleanup
function StudioMonitor:destroy()
    self:stopMonitoring()
    self.tutorialEngine = nil
end

return StudioMonitor
