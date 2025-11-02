--[[
    Tutorial 01: Insert Your First Part

    Teaches beginners how to insert and manipulate their first part in Roblox Studio.
    This is the most basic tutorial for complete beginners.
]]

return {
    -- Metadata
    id = "insert-first-part",
    title = "Insert Your First Part",
    description = "Learn how to add and modify your first part in Roblox Studio",
    difficulty = "beginner",
    estimatedTime = 3,
    category = "basics",
    icon = "cube",

    -- Tutorial steps
    steps = {
        {
            stepNumber = 1,
            title = "Welcome to LearnStudio!",
            instruction = "Let's learn how to insert your first part into the game world.",
            details = "Parts are the basic building blocks of every Roblox game. You'll use them to create walls, floors, obstacles, and more. In this tutorial, we'll insert a part and learn how to modify it.",
            hint = "Click the 'Next' button when you're ready to continue.",

            validation = {
                type = "manual",  -- User clicks Next manually
            },
        },

        {
            stepNumber = 2,
            title = "Insert a Part",
            instruction = "In the top menu, click the 'Model' tab, then click the 'Part' button to insert a part.",
            details = "The Model tab contains tools for building your game. The Part button creates a new part and places it in the Workspace, which is where all visible objects in your game live.",
            hint = "Look for the blue cube icon labeled 'Part' in the ribbon menu at the top of Studio.",

            validation = {
                type = "partCreated",
                partType = "Part",  -- Any type of Part
            },

            highlight = {
                target = "PartButton",
                description = "This button creates a new Part in your game",
            },
        },

        {
            stepNumber = 3,
            title = "Select Your Part",
            instruction = "Click on the part you just created to select it.",
            details = "When a part is selected, you'll see a blue outline around it and its properties will appear in the Properties window. This lets you modify the part's appearance and behavior.",
            hint = "Click on the gray block that appeared in your game world.",

            validation = {
                type = "selectionChanged",
                objectType = "Part",  -- User selects any Part
            },
        },

        {
            stepNumber = 4,
            title = "Move Your Part",
            instruction = "With the part selected, click and drag it to move it to a new position.",
            details = "You can move parts by clicking and dragging them in the 3D view. You can also use the Move tool in the Model tab for more precise positioning.",
            hint = "Try clicking the part and dragging it up, down, left, or right.",

            validation = {
                type = "propertyChanged",
                objectType = "Part",
                propertyName = "Position",  -- Detects when Position changes
            },
        },

        {
            stepNumber = 5,
            title = "Congratulations!",
            instruction = "You've inserted and moved your first part! You're now ready to build amazing things in Roblox.",
            details = "You've learned the fundamental skill of adding objects to your game. Every Roblox game starts with simple parts like this. Next, you can explore changing colors, sizes, materials, and eventually adding scripts to make parts interactive!",
            hint = "Click 'Finish' to complete this tutorial and return to the tutorial list.",

            validation = {
                type = "manual",
            },
        },
    }
}
