--[[
    Tutorial Data Schema

    This file documents the structure of tutorial data files.
    Each tutorial is a ModuleScript that returns a table with the following structure:
]]

--[[
TUTORIAL STRUCTURE:
{
    -- Metadata
    id = string,              -- Unique identifier (e.g., "insert-first-part")
    title = string,           -- Display name (e.g., "Insert Your First Part")
    description = string,     -- Brief description of what the tutorial teaches
    difficulty = string,      -- "beginner", "intermediate", or "advanced"
    estimatedTime = number,   -- Estimated completion time in minutes
    category = string,        -- Category (e.g., "basics", "scripting", "building")
    icon = string?,           -- Optional icon identifier

    -- Tutorial steps
    steps = {
        {
            stepNumber = number,     -- Step sequence number (1-indexed)
            title = string,          -- Short step title
            instruction = string,    -- Main instruction text (what to do)
            details = string?,       -- Optional detailed explanation (why/how)
            hint = string?,          -- Optional hint if user is stuck

            -- Validation: How to check if step is complete
            validation = {
                type = string,       -- Validation type (see VALIDATION_TYPES below)

                -- Type-specific validation data
                -- For "manual": no additional data needed
                -- For "partCreated": partType, partName (optional)
                -- For "selectionChanged": objectName (optional), objectType (optional)
                -- For "propertySet": objectName, propertyName, expectedValue
                -- For "scriptCreated": scriptName (optional)

                [string] = any,      -- Additional validation parameters
            },

            -- Optional: UI element to highlight in Studio
            highlight = {
                target = string?,    -- Studio UI element identifier
                description = string?, -- What this UI element does
            }?,
        }
    }
}

VALIDATION TYPES:
- "manual"           - User clicks "Next" button manually (no auto-validation)
- "partCreated"      - Detects when a Part is created in Workspace
- "selectionChanged" - Detects when user selects specific object(s)
- "propertySet"      - Detects when a property is set to specific value
- "scriptCreated"    - Detects when a Script is created
- "objectRenamed"    - Detects when an object is renamed
- "wait"             - Wait for a duration (for pacing/reading steps)

EXAMPLE TUTORIAL:
{
    id = "example-tutorial",
    title = "Example Tutorial",
    description = "This is an example",
    difficulty = "beginner",
    estimatedTime = 5,
    category = "basics",

    steps = {
        {
            stepNumber = 1,
            title = "Insert a Part",
            instruction = "Click the 'Part' button in the Model tab to insert a part",
            details = "Parts are the basic building blocks of Roblox games",
            hint = "Look for the cube icon in the ribbon menu at the top",

            validation = {
                type = "partCreated",
                partType = "Part",
            },
        },
    }
}
]]

-- This is a documentation file only, no actual code
return nil
