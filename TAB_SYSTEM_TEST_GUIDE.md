# Tab System Testing Guide

This guide helps you test the newly implemented tab system in LearnStudio.

## Prerequisites

1. Roblox Studio installed
2. Plugin build and install script ready
3. Test place open in Studio

---

## Installation & First Run

### Step 1: Build and Install Plugin
```bash
./install-plugin.sh
```

### Step 2: Restart Roblox Studio
- **Important**: Fully quit and restart Studio (not just close the place)
- This ensures the new plugin version loads

### Step 3: Open Plugin
1. Open any place in Roblox Studio
2. Look for **LearnStudio** button in the PLUGINS ribbon
3. Click it to open the widget

---

## Visual Inspection Checklist

### Header (Top Bar)
- [ ] Header is visible at the top
- [ ] "LearnStudio v0.1.0-alpha" text is visible
- [ ] Header has dark background (RGB: 35, 35, 35)
- [ ] Text is white and uses Gotham Bold font

### Sidebar (Left Side)
- [ ] Sidebar is visible on the left
- [ ] Sidebar width is approximately 70 pixels
- [ ] Sidebar has darker background than content area
- [ ] Three tabs are visible vertically:
  - "Tutorials" (top)
  - "Code Help" (middle)
  - "Dashboard" (bottom)

### Tab Buttons
- [ ] Each tab button is readable
- [ ] Tab labels are centered
- [ ] First tab ("Tutorials") should be active by default
- [ ] Active tab has:
  - White text
  - Blue left border (3px wide)
  - Slightly lighter background
- [ ] Inactive tabs have:
  - Gray text
  - No visible border
  - Transparent or very dark background

---

## Interaction Testing

### Test 1: Tab Switching
1. Click on "Code Help" tab
   - [ ] Tab switches to Code Help
   - [ ] Previous tab ("Tutorials") becomes inactive
   - [ ] Code Help tab shows active styling
   - [ ] Content panel shows "💡 Code Help" heading
   - [ ] Console shows: `[LearnStudio] Switched to tab: Code Help`

2. Click on "Dashboard" tab
   - [ ] Tab switches to Dashboard
   - [ ] Code Help becomes inactive
   - [ ] Dashboard shows active styling
   - [ ] Content panel shows "📊 Progress Dashboard" heading
   - [ ] Console shows: `[LearnStudio] Switched to tab: Dashboard`

3. Click back on "Tutorials" tab
   - [ ] Tab switches back to Tutorials
   - [ ] Dashboard becomes inactive
   - [ ] Content panel shows "📚 Tutorials" heading

### Test 2: Hover States
1. Hover over an **inactive** tab
   - [ ] Tab background becomes slightly lighter
   - [ ] Text color brightens
   - [ ] Transition is smooth (not instant)

2. Move mouse away from tab
   - [ ] Tab returns to inactive state
   - [ ] Transition is smooth

3. Hover over the **active** tab
   - [ ] No visual change (already active)
   - [ ] Left border remains visible

### Test 3: Content Panel Display
For each tab, verify the placeholder content:

**Tutorials Tab:**
- [ ] Title: "📚 Tutorials"
- [ ] Description mentions "Interactive tutorials coming soon!"
- [ ] Lists future features (step-by-step, visual highlights, etc.)

**Code Help Tab:**
- [ ] Title: "💡 Code Help"
- [ ] Description mentions "Code explanation engine coming soon!"
- [ ] Lists future features (line-by-line breakdown, pattern recognition, etc.)

**Dashboard Tab:**
- [ ] Title: "📊 Progress Dashboard"
- [ ] Description mentions "Progress tracking coming soon!"
- [ ] Lists future features (tutorials completed, challenge success rates, etc.)

---

## Layout Testing

### Test 4: Widget Resizing
1. Make the widget **very small** (minimum size: 300x400)
   - [ ] Tabs remain visible and clickable
   - [ ] Content doesn't overflow
   - [ ] Text wraps appropriately
   - [ ] No UI elements clipping

2. Make the widget **very large** (full screen)
   - [ ] Sidebar stays fixed width (70px)
   - [ ] Content area expands to fill space
   - [ ] Tab buttons stay top-aligned
   - [ ] No layout breaks

### Test 5: Widget Docking
1. Dock the widget to **left side** of Studio
   - [ ] Layout remains correct
   - [ ] Tabs are readable
   - [ ] Content displays properly

2. Dock the widget to **right side**
   - [ ] Same as above

3. Dock the widget to **bottom**
   - [ ] Layout adapts (if horizontal space is limited)
   - [ ] Tabs remain functional

4. **Float** the widget (undock)
   - [ ] Returns to normal layout
   - [ ] No visual glitches

---

## Performance Testing

### Test 6: Responsiveness
1. Rapidly click between tabs (10-20 times quickly)
   - [ ] All tab switches work correctly
   - [ ] No lag or freezing
   - [ ] No visual glitches
   - [ ] Console shows all tab changes

2. Check Studio performance
   - [ ] Open Studio's **Performance Stats** (Shift+F5)
   - [ ] With plugin open and idle, CPU usage should be very low (<5%)
   - [ ] Memory usage should be under 50MB

### Test 7: Multiple Open/Close Cycles
1. Close the widget (click plugin button to toggle off)
   - [ ] Widget disappears
   - [ ] No console errors

2. Open the widget again
   - [ ] Widget reappears in same state
   - [ ] Default tab is active (Tutorials)
   - [ ] No console errors

3. Repeat 5-10 times
   - [ ] Consistent behavior
   - [ ] No memory leaks (check Performance Stats)

---

## Console Output Verification

### Expected Console Messages

**On plugin initialization:**
```
[LearnStudio] Plugin initialized successfully with tab system!
```

**On each tab switch:**
```
[LearnStudio] Switched to tab: Tutorials
[LearnStudio] Switched to tab: Code Help
[LearnStudio] Switched to tab: Dashboard
```

**On plugin unload (Studio quit):**
```
[LearnStudio] Plugin unloaded and cleaned up
```

### Check for Errors
- [ ] No Lua errors in console
- [ ] No warnings about missing modules
- [ ] No "attempt to index nil" errors
- [ ] No "invalid argument" errors

---

## Edge Cases & Error Handling

### Test 8: Rapid State Changes
1. Click tabs very quickly while hovering
   - [ ] No visual glitches
   - [ ] State always resolves correctly
   - [ ] Active tab is always clear

2. Resize widget while switching tabs
   - [ ] No layout breaks
   - [ ] Tab switching continues to work

### Test 9: Studio Stress Test
1. Open a complex place (1000+ parts, many scripts)
2. Open LearnStudio plugin
   - [ ] Plugin opens normally
   - [ ] Tab switching works smoothly
   - [ ] No performance degradation

---

## Known Limitations (Expected)

These are **not** bugs, just Phase 1 limitations:

- ✅ Tab icons are not implemented (labels only)
- ✅ Content panels show placeholder text (real features coming in later phases)
- ✅ No keyboard navigation (arrow keys don't work)
- ✅ No tab badges or notification counts
- ✅ Tabs cannot be reordered or customized

---

## Reporting Issues

If you find bugs, note:

1. **What happened** (visual glitch, error, crash, etc.)
2. **Steps to reproduce** (what you did before it happened)
3. **Console output** (copy any error messages)
4. **Studio version** (Help → About Roblox Studio)
5. **OS** (Windows or macOS)

---

## Success Criteria

The tab system implementation is **successful** if:

- ✅ All 3 tabs render correctly
- ✅ Tab switching works smoothly with visual feedback
- ✅ Hover states work on all tabs
- ✅ Active tab is clearly indicated (blue border + white text)
- ✅ Content panels show/hide correctly
- ✅ No console errors during normal use
- ✅ Plugin can be opened/closed multiple times without issues
- ✅ CPU usage is <5% when idle
- ✅ Layout works in different widget sizes and docking positions

---

## Next Steps After Testing

Once testing is complete and any bugs are fixed:

1. ✅ Mark "Tab System Implementation" as complete in PLAN.md
2. ✅ Move on to next phase: Tutorial Engine implementation
3. ✅ Consider creating actual tab icons for visual polish (optional)

---

**Happy Testing! 🚀**
