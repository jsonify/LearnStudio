# LearnStudio Development Workflow

## Plugin Installation (One-Time Setup)

The plugin is already installed in Roblox Studio. It will persist across Studio restarts and will appear in the PLUGINS ribbon automatically.

**No action needed** - the plugin will always be there unless you manually delete it from `~/Documents/Roblox/Plugins/`.

---

## Development Workflow

### Option 1: Live Development with Rojo Sync (Recommended for Testing)

For rapid iteration and testing changes without rebuilding:

1. **Start Rojo sync server:**
   ```bash
   rojo serve
   ```

2. **In Roblox Studio:**
   - Click the **Rojo** button in the toolbar
   - Click **Connect** (should show "LearnStudio" on localhost:34872)
   - Your code will sync to `ServerStorage.LearnStudio` in real-time

3. **Test your code:**
   - Changes you make in your editor will sync immediately to Studio
   - You can test logic by running scripts from ServerStorage
   - ⚠️ **Note:** This won't update the installed plugin - just syncs code for testing

### Option 2: Rebuild and Reinstall Plugin

When you want to test the actual plugin behavior (toolbar button, widget, etc.):

1. **Run the install script:**
   ```bash
   ./install-plugin.sh
   ```

2. **Restart Roblox Studio** (quit and reopen the app)

3. The updated plugin will now appear in the PLUGINS ribbon

---

## When to Use Each Workflow

### Use Rojo Sync (`rojo serve`) when:
- Testing business logic changes
- Iterating on algorithms or data structures
- Debugging core functionality
- You want instant feedback without restarting Studio

### Use Plugin Rebuild (`./install-plugin.sh`) when:
- Testing UI changes in the actual widget
- Testing toolbar button behavior
- Verifying plugin lifecycle (initialization, unloading)
- Final testing before release
- You changed `Main.server.lua` and want to see plugin-specific behavior

---

## Daily Startup Checklist

### For Active Development:
1. ✅ Open terminal in project directory
2. ✅ Run `rojo serve` (leave it running)
3. ✅ Open Roblox Studio
4. ✅ Click Rojo → Connect
5. ✅ Start coding! Changes sync automatically

### For Plugin Testing:
1. ✅ Make your code changes
2. ✅ Run `./install-plugin.sh`
3. ✅ Restart Roblox Studio
4. ✅ Test the plugin from the PLUGINS ribbon

---

## Important Notes

### Plugin Persistence
- ✅ **Plugin persists** - Once installed, it's always in Studio (like any other plugin)
- ✅ **No reinstall needed** unless you change plugin code
- ✅ **Works offline** - No need for Rojo to be running for the plugin to work

### Rojo Sync vs Plugin
- **Rojo Sync** (`rojo serve`): For live development, syncs to ServerStorage
- **Plugin Install** (`./install-plugin.sh`): For testing actual plugin functionality

### File Structure
- `src/Main.server.lua` - Plugin entry point (must be `.server.lua` for plugins)
- `default.project.json` - Used for Rojo sync (ServerStorage)
- `plugin.project.json` - Used for building the plugin file

---

## Troubleshooting

### Plugin not appearing after changes?
1. Did you run `./install-plugin.sh`?
2. Did you **fully restart** Roblox Studio (quit the app)?
3. Check `~/Documents/Roblox/Plugins/LearnStudio.rbxm` exists

### Rojo not connecting?
1. Is `rojo serve` running in terminal?
2. Check the port matches (should be localhost:34872)
3. Click Rojo → Settings in Studio to verify

### Plugin errors on startup?
1. Open Studio Output window (View → Output)
2. Look for `[LearnStudio]` messages or errors
3. Check that `Main.server.lua` has no syntax errors

---

## Quick Reference Commands

```bash
# Start live development sync
rojo serve

# Build and install plugin (requires Studio restart)
./install-plugin.sh

# Check if plugin is installed
ls -lh ~/Documents/Roblox/Plugins/LearnStudio.rbxm
```
