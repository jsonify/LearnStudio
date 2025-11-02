--[[
    Tutorial 02: Create a Moving Platform

    Teaches beginners how to create a moving platform using basic scripting.
    Introduces Scripts, Anchored property, and simple CFrame manipulation.
]]

return {
    -- Metadata
    id = "moving-platform",
    title = "Create a Moving Platform",
    description = "Build a platform that moves back and forth automatically",
    difficulty = "beginner",
    estimatedTime = 8,
    category = "scripting",
    icon = "code",

    -- Tutorial steps
    steps = {
        {
            stepNumber = 1,
            title = "Understanding Moving Platforms",
            instruction = "In this tutorial, you'll create a platform that moves automatically. This is a common feature in obby (obstacle course) games!",
            details = "Moving platforms use Scripts (code) to change their position over time. You'll learn how to insert a Script, write basic Lua code, and make an object move.",
            hint = "Click 'Next' when you're ready to start building.",

            validation = {
                type = "manual",
            },
        },

        {
            stepNumber = 2,
            title = "Insert the Platform Part",
            instruction = "Insert a new Part into the Workspace. This will be your moving platform.",
            details = "Just like in the previous tutorial, use the Model tab to insert a Part. This part will become the platform that players stand on.",
            hint = "Click the 'Part' button in the Model tab at the top.",

            validation = {
                type = "partCreated",
                partType = "Part",
            },
        },

        {
            stepNumber = 3,
            title = "Anchor the Platform",
            instruction = "Select your part, then in the Properties window, scroll down and check the 'Anchored' property.",
            details = "Anchored parts don't fall due to gravity and can't be moved by physics. This is important because we want our platform to move only when we tell it to with code, not fall to the ground!",
            hint = "Find the Properties window (usually on the right side) and look for the checkbox next to 'Anchored'.",

            validation = {
                type = "propertySet",
                objectType = "Part",
                propertyName = "Anchored",
                expectedValue = true,
            },
        },

        {
            stepNumber = 4,
            title = "Insert a Script",
            instruction = "Right-click on your part in the Explorer, then select Insert Object > Script.",
            details = "Scripts contain code that makes things happen in your game. By placing a Script inside a Part, we can write code that controls that part's behavior.",
            hint = "In the Explorer window, find your part, right-click it, hover over 'Insert Object', and click 'Script'.",

            validation = {
                type = "scriptCreated",
                scriptType = "Script",
                parentType = "Part",
            },
        },

        {
            stepNumber = 5,
            title = "Understand the Movement Code",
            instruction = "We'll use this code to move the platform. Read through it - you don't need to write it yet, just understand what it does.",
            details = [[The code will:
1. Get reference to the part (the platform)
2. Store its starting position
3. Loop forever
4. Move the part right by 10 studs
5. Wait 2 seconds
6. Move the part back to start
7. Wait 2 seconds
8. Repeat

This creates a back-and-forth motion.]],
            hint = "Click 'Next' when you understand the concept. In the next tutorial, you'll learn to write this code yourself!",

            validation = {
                type = "manual",
            },
        },

        {
            stepNumber = 6,
            title = "Add the Movement Code",
            instruction = "Copy this code into your Script: (Code will be shown in the tutorial panel)",
            details = [[Here's the code to make your platform move:

```lua
local platform = script.Parent
local startPosition = platform.Position
local moveDistance = 10

while true do
    -- Move right
    platform.Position = startPosition + Vector3.new(moveDistance, 0, 0)
    wait(2)

    -- Move back to start
    platform.Position = startPosition
    wait(2)
end
```

Copy this into your Script by clicking on the Script in the Explorer and pasting the code.]],
            hint = "Double-click the Script in the Explorer to open the code editor, delete any existing code, and paste this code.",

            validation = {
                type = "manual",  -- We can't easily validate code content
            },
        },

        {
            stepNumber = 7,
            title = "Test Your Moving Platform",
            instruction = "Click the 'Play' button (or press F5) to test your game and watch the platform move!",
            details = "When you press Play, your game starts running and all Scripts execute. You should see your platform move back and forth. Press Stop to return to editing mode.",
            hint = "The Play button is the blue triangle in the toolbar at the top.",

            validation = {
                type = "manual",
            },
        },

        {
            stepNumber = 8,
            title = "Tutorial Complete!",
            instruction = "Congratulations! You've created your first scripted object in Roblox!",
            details = "You've learned how to use Scripts to make objects move automatically. This is the foundation for creating interactive games. Try changing the numbers in the code to make the platform move differently!",
            hint = "Click 'Finish' to complete this tutorial.",

            validation = {
                type = "manual",
            },
        },
    }
}
