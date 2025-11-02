# LearnStudio - Phase 1 Setup Guide

## Prerequisites

1. **Roblox Studio** - Download from [roblox.com/create](https://www.roblox.com/create)
2. **Rojo** - Roblox external editor sync tool

## Installing Rojo

### Option 1: Aftman (Recommended for Roblox developers)
```bash
# Install aftman
curl -L https://github.com/LPGhatguy/aftman/releases/latest/download/aftman-linux-x86_64.zip -o aftman.zip
unzip aftman.zip
chmod +x aftman
sudo mv aftman /usr/local/bin/

# Install Rojo via aftman
aftman add rojo-rbx/rojo
aftman install
```

### Option 2: Cargo (if you have Rust installed)
```bash
cargo install rojo
```

### Option 3: Direct Binary Download
Visit [Rojo Releases](https://github.com/rojo-rbx/rojo/releases) and download the appropriate binary for your platform.

## Development Workflow

### 1. Start Rojo Sync Server
```bash
cd /path/to/LearnStudio
rojo serve
```

This starts a local server (default port 34872) that syncs your filesystem to Roblox Studio.

### 2. Connect from Roblox Studio
- Open Roblox Studio
- Install the Rojo plugin from the Studio Plugin Marketplace (if not already installed)
- Click the Rojo plugin button
- Click "Connect" (it should auto-detect localhost:34872)

### 3. Develop and Test
- Edit Lua files in your editor (VSCode, Sublime, etc.)
- Changes sync to Studio instantly
- Test the plugin directly in Studio

### 4. Build Plugin File (for distribution)
```bash
rojo build -o LearnStudio.rbxmx
```

This creates a `.rbxmx` file that can be:
- Shared with others
- Installed manually in Studio's Plugins folder
- Published to the Roblox Plugin Marketplace

## Project Structure

```
LearnStudio/
├── default.project.json    # Rojo configuration
├── src/
│   ├── Main.lua            # Plugin entry point ✅
│   ├── UI/                 # UI components (empty - Phase 1)
│   ├── Core/               # Business logic (empty - Phase 1)
│   ├── Data/               # Tutorial/challenge content (empty - Phase 1)
│   └── Utils/              # Helper modules (empty - Phase 1)
```

## Current Status

**Phase 1 MVP Setup: COMPLETE** ✅

- ✅ Rojo project configured
- ✅ Directory structure created
- ✅ Basic plugin entry point (Main.lua)
- ✅ Dockable widget UI foundation

## Next Steps (Implementation)

1. **Create Tutorial Content** - Add 5 beginner tutorials in `src/Data/Tutorials/`
2. **Build Tutorial UI** - Implement `src/UI/TutorialPanel.lua`
3. **Code Analyzer** - Create basic pattern matcher in `src/Core/CodeAnalyzer.lua`
4. **Progress Tracking** - Implement `src/Core/ProgressTracker.lua` with plugin DataStore

## Testing the Plugin

1. Start `rojo serve`
2. Open Roblox Studio
3. Connect via Rojo plugin
4. Click the LearnStudio toolbar button
5. The widget should open showing the placeholder UI

## Troubleshooting

**Rojo won't connect:**
- Ensure `rojo serve` is running
- Check firewall settings (port 34872)
- Try restarting Roblox Studio

**Changes not syncing:**
- Check Rojo terminal for errors
- Ensure you're editing files in the correct directory
- Try disconnecting and reconnecting in Studio

**Plugin not appearing:**
- Check ServerStorage in Studio Explorer
- Verify `default.project.json` is valid JSON
- Look for errors in Studio Output window

## Resources

- [Rojo Documentation](https://rojo.space/docs/)
- [Roblox Plugin Documentation](https://create.roblox.com/docs/studio/plugins)
- [LearnStudio Design Doc](./roblox-teaching-plugin-design.md)
