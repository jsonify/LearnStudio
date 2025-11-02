#!/bin/bash
# Build and install LearnStudio plugin to Roblox Studio

echo "🔨 Building LearnStudio plugin..."
rojo build plugin.project.json -o LearnStudio.rbxm

if [ $? -eq 0 ]; then
    echo "📦 Installing to Roblox plugins folder..."
    mkdir -p ~/Documents/Roblox/Plugins
    cp LearnStudio.rbxm ~/Documents/Roblox/Plugins/
    echo "✅ Plugin installed! Restart Roblox Studio to see changes."
else
    echo "❌ Build failed!"
    exit 1
fi
