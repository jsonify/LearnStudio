--[[
    Tutorial 03: Make a Clickable Button

    Teaches beginners how to create an interactive button using ClickDetector.
    Introduces events, ClickDetector, and changing properties via code.
]]

return {
    -- Metadata
    id = "clickable-button",
    title = "Make a Clickable Button",
    description = "Create a button that players can click to trigger actions",
    difficulty = "beginner",
    estimatedTime = 10,
    category = "scripting",
    icon = "pointer",

    -- Tutorial steps
    steps = {
        {
            stepNumber = 1,
            title = "Creating Interactive Objects",
            instruction = "Let's create a button that changes color when clicked! This teaches you how to make your game respond to player actions.",
            details = "Interactive objects are what make games fun. Buttons can open doors, spawn enemies, give points, or do anything you can imagine. You'll learn to use a ClickDetector and event handling.",
            hint = "Click 'Next' to start building an interactive button.",

            validation = {
                type = "manual",
            },
        },

        {
            stepNumber = 2,
            title = "Insert the Button Part",
            instruction = "Insert a new Part into the Workspace. This will be your clickable button.",
            details = "Start with a basic Part - we'll customize it to look like a button in the next steps.",
            hint = "Use the Model tab > Part button to insert a part.",

            validation = {
                type = "partCreated",
                partType = "Part",
            },
        },

        {
            stepNumber = 3,
            title = "Make It Look Like a Button",
            instruction = "Select your part and change its BrickColor to 'Bright red' in the Properties window.",
            details = "Red is often used for buttons and interactive objects in games. Changing the color makes it clear to players that this object is special and can be interacted with.",
            hint = "In Properties, find 'BrickColor' and click on it to see the color palette. Select any red color.",

            validation = {
                type = "propertyChanged",
                objectType = "Part",
                propertyName = "BrickColor",
            },
        },

        {
            stepNumber = 4,
            title = "Resize the Button",
            instruction = "In Properties, find the 'Size' property and change it to make a flatter, button-like shape. Try: X=4, Y=1, Z=4",
            details = "Buttons are usually flat and wide, not tall cubes. The Size property controls how big the part is in each direction (X, Y, Z).",
            hint = "Click on the Size property and enter new values: 4, 1, 4",

            validation = {
                type = "propertyChanged",
                objectType = "Part",
                propertyName = "Size",
            },
        },

        {
            stepNumber = 5,
            title = "Add a ClickDetector",
            instruction = "Right-click your part in the Explorer, then select Insert Object > ClickDetector.",
            details = "A ClickDetector is a special object that detects when a player clicks on the part. It's what makes the part 'clickable' in-game. Without it, clicking the part would do nothing!",
            hint = "In Explorer: Right-click the part > Insert Object > ClickDetector",

            validation = {
                type = "objectCreated",
                objectType = "ClickDetector",
                parentType = "Part",
            },
        },

        {
            stepNumber = 6,
            title = "Insert a Script",
            instruction = "Right-click on your part (not the ClickDetector) and insert a Script.",
            details = "This Script will contain code that runs when the button is clicked. Make sure to insert it as a child of the Part, not the ClickDetector.",
            hint = "Right-click the Part > Insert Object > Script",

            validation = {
                type = "scriptCreated",
                scriptType = "Script",
                parentType = "Part",
            },
        },

        {
            stepNumber = 7,
            title = "Understand Click Events",
            instruction = "Let's learn how the click event works before writing code.",
            details = [[When a player clicks the button, the ClickDetector fires a 'MouseClick' event. We can connect to this event with code to run a function.

The pattern looks like this:
```lua
clickDetector.MouseClick:Connect(function(playerWhoClicked)
    -- Code here runs when clicked
end)
```

This is called an "event handler" - it handles the click event.]],
            hint = "Click 'Next' when you understand how events work.",

            validation = {
                type = "manual",
            },
        },

        {
            stepNumber = 8,
            title = "Write the Click Handler Code",
            instruction = "Add this code to your Script to make the button change color when clicked:",
            details = [[Copy this code into your Script:

```lua
local button = script.Parent
local clickDetector = button:FindFirstChildOfClass("ClickDetector")

-- Colors to cycle through
local colors = {
    BrickColor.new("Bright red"),
    BrickColor.new("Bright blue"),
    BrickColor.new("Bright green"),
    BrickColor.new("Bright yellow")
}
local currentColorIndex = 1

-- When the button is clicked
clickDetector.MouseClick:Connect(function(player)
    print(player.Name .. " clicked the button!")

    -- Change to next color
    currentColorIndex = currentColorIndex + 1
    if currentColorIndex > #colors then
        currentColorIndex = 1  -- Loop back to first color
    end

    button.BrickColor = colors[currentColorIndex]
end)
```

This makes the button cycle through different colors each time it's clicked!]],
            hint = "Open the Script and paste this code, replacing any existing code.",

            validation = {
                type = "manual",
            },
        },

        {
            stepNumber = 9,
            title = "Test Your Button",
            instruction = "Press Play (F5) to test your game. Click on the button and watch it change colors!",
            details = "When you click the button in play mode, it should cycle through red, blue, green, and yellow. Check the Output window to see the print messages confirming each click.",
            hint = "Press F5 to play, click the button a few times, then press F5 again to stop.",

            validation = {
                type = "manual",
            },
        },

        {
            stepNumber = 10,
            title = "Congratulations!",
            instruction = "You've created an interactive button! You now understand events, ClickDetectors, and player interaction.",
            details = [[You've learned powerful concepts:
- ClickDetector makes parts clickable
- Events let your code respond to player actions
- You can change object properties through code
- Functions can be called when events fire

Try modifying the code to do different things when clicked - play sounds, spawn objects, or give points!]],
            hint = "Click 'Finish' to complete this tutorial and explore more!",

            validation = {
                type = "manual",
            },
        },
    }
}
